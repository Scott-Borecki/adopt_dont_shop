class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @application.process
  end

  def approve_pet
    # PARAMS via URI: :application_id, :pet_id
    application = Application.find(params[:application_id])
    application.approve_pet(params[:pet_id])
    redirect_to "/admin/applications/#{application.id}"
  end

  def reject_pet
    # PARAMS via URI: :application_id, :pet_id
    application = Application.find(params[:application_id])
    application.reject_pet(params[:pet_id])
    redirect_to "/admin/applications/#{application.id}"
  end
end
