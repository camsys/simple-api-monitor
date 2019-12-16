class Test < ApplicationRecord

  belongs_to :request

  serialize :key
  serialize :value
  serialize :actual_value
  serialize :history

  scope :failing, -> { where(:status => false) }
  scope :passing, -> { where(:status => true) }
  scope :high_priority, -> { where(:priority => Test::HIGH )}
  scope :low_priority, -> { where(:priority => Test::LOW )}

  #Constants
  HIGH = 1
  LOW = 0

  def run

    purge_history

    self.actual_value = nil
  	
    if request.response_body.nil? or request.response_code.nil?
      self.status = false
      self.consecutive_failures += 1
      add_history false
      self.save
  	  return self.consecutive_failures == Setting.alert_after_fail_count.to_i
  	end

  	begin
      body = nil
      title = nil
      if request.format == "xml"
        body = Hash.from_xml(request.response_body)
      elsif request.format == "json"
        body = JSON.parse(request.response_body)
      elsif request.format == "html"
        title = [Nokogiri::HTML(request.response_body).title]
      end

      code = request.response_code
      
      #Replace every instance of _body_ with the actual body of the response. 
      #Replace every instance of _code_ with the actual code of the response.
      #Replace every instance of _title_ with the HTML title
      if request.format == "html"
        decoded_key = self.key.gsub('_code_', code.to_s).gsub('_title_', title.to_s)      
      else
        decoded_key = self.key.gsub('_body_', body.to_s).gsub('_code_', code.to_s)
      end

      result = nil 
      begin
        result = eval(decoded_key)
      rescue Exception => exc
        self.status = false
        self.consecutive_failures += 1
        add_history false
        self.save
        return self.consecutive_failures == Setting.alert_after_fail_count.to_i
      end
      
      self.actual_value = result
      new_status = (result.to_s == value.to_s)
      self.status = new_status
      
      if new_status == false
        self.consecutive_failures += 1
      else
        self.consecutive_failures = 0
      end
      
      add_history new_status
      self.save
      return self.consecutive_failures == Setting.alert_after_fail_count.to_i
    rescue
      self.status = false
      self.consecutive_failures += 1
      add_history false
      self.save
      return self.consecutive_failures == Setting.alert_after_fail_count.to_i
    end

  end

  # Delete all history over 2 weeks old 
  # todo: make this 2 weeks a configurable
  def purge_history
    unless history.nil?
      two_weeks_ago = Time.now - 2.weeks
      self.history.delete_if { |x| x[:time] < two_weeks_ago }
      self.save
    end
  end

  def add_history result
    if self.history.nil?
      self.history = []
    end
    self.history << {time: Time.now, result: result}
  end

  def pass_rate
    if history.blank?
      return 0.0
    end
    # Successes / Total 
    (history.count{ |x| x[:result] == true }).to_f / history.count.to_f
  end

  # This should probably be in a serializer. It is used to generate the charts
  def history_array
    if history.blank?
      return []
    end
    history.collect{ |x| [x[:time].to_s, (x[:result] ? 1 : 0)  ]}
  end

  def priority_string
    case priority
    when Test::HIGH
      return "High"
    else
      return "Low"
    end
  end

end
