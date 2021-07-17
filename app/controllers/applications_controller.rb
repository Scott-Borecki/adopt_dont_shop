class ApplicationsController < ApplicationController
  def new
  end

  def show
    @application = Application.find(params[:id])
    if params[:search_name]
      @pets = Pet.search(params[:search_name]).to_a
    end
  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def adopt
    application = Application.find(params[:application_id])
    pet = Pet.find(params[:pet_id])
    application.pets << pet
    redirect_to "/applications/#{application.id}"
  end

  def submit
    application = Application.find(params[:id])
    application.update(application_params)
    redirect_to "/applications/#{application.id}"
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
