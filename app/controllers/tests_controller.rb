class TestsController < ApplicationController

  def create
  	@test = Test.create!(request_params)
  	redirect_to request_path(@test.request)
  end

  def destroy
  	@test = Test.find(params[:id])
    @request = @test.request
  	@test.destroy
  	redirect_to request_path(@request)
  end

  private

  def request_params
  	params.require(:test).permit(:name, :key, :value, :request_id, :priority)
  end

 
 end