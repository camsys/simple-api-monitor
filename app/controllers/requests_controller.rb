class RequestsController < ApplicationController

  def index
  	@requests = Request.all.order(:name)

    #This is inefficient, but will be OK for a small number of requets
    @passing = []
    @failing = []
    
    @requests.each do |request|
      if request.status
        @passing << request
      else
        @failing << request
      end
    end
  	
    @new_request = Request.new
  end

  def show
  	@request = Request.find(params[:id])
  	@new_test = Test.new
  end

  def create
  	request = Request.create!(request_params)
    #Headers must be handled separately
    unless headers.blank?
      request.headers = eval(params[:request][:headers])
      request.save!
    end
  	redirect_to requests_path
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