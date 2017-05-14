class RequestsController < ApplicationController

  def index
  	@requests = Request.all
  	@new_request = Request.new
  end

  def show
  	@request = Request.find(params[:id])
  end

  def create
  	Request.create!(request_params)
  	redirect_to requests_path
  end

  private

  def request_params
  	params.require(:request).permit(:name, :url, :headers, :use_ssl, :format)
  end

 
 end