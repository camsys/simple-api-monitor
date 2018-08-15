class RequestsController < ApplicationController

  def index
  	@requests = Request.all.order(:name)

    #This is inefficient, but will be OK for a small number of requets
    @passing = []
    @failing_high = []
    @failing_low = []
    
    @requests.each do |request|
      if request.status
        @passing << request
      else
        if request.tests.failing.high_priority.count > 0
          @failing_high << request
        else
          @failing_low << request 
        end
      end
    end
  	
    @new_request = Request.new
  end

  def show
  	@request = Request.find(params[:id])
  	@new_test = Test.new
  end

  def create
  	request = Request.create(request_params)
    #Headers must be handled separately
    unless headers.blank?
      begin 
        request.headers = eval(params[:request][:headers])
      rescue
        request.errors.add(:headers, :blank, message: "Invalid Headers")
      end 
    end
    if request.save
      redirect_to requests_path, flash: { success: "Request Created" }
    else
      request.validate
      redirect_to requests_path, flash: { danger: request.errors.full_messages.first}
    end

  end

  def destroy
  	@request = Request.find(params[:id])
  	@request.destroy
  	redirect_to requests_path
  end

  def refresh
  	@request = Request.find(params[:id])
  	@request.refresh
  	redirect_to request_path(@request)
  end

  private

  def request_params
  	params.require(:request).permit(:name, :url, :use_ssl, :format)
  end

 
 end