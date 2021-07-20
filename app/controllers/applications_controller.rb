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
    # PARAMS via URI: :application_id, :pet_id
    application = Application.find(params[:application_id])
    application.add_pet(params[:pet_id])
    redirect_to "/applications/#{application.id}"
  end

  def submit
    application = Application.find(params[:id])
    application.update!(application_params)
    # Application.submit(params[:id], params)
    redirect_to "/applications/#{application.id}"
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)
  end
end
