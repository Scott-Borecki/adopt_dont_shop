class ApplicationsController < ApplicationController
  def new
  end

  def show
    @application = Application.find(params[:id])
    if params[:search_name]
      @pets = Pet.search(params[:search_name]).adoptable.to_a
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

  def update
    application = Application.find(params[:id])
    if application.update(application_params)
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/#{application.id}"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  private
  def application_params
    params.permit(:name, :street_address, :city, :state, :zip_code,
                  :description, :status)
  end
end
