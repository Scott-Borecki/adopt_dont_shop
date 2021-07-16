class ApplicationsController < ApplicationController
  def new
  end

  def show
    @applicant = Application.find(params[:id])
  end

  def create
    applicant = Application.create!(application_params)
    redirect_to "/applications/#{applicant.id}"
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
