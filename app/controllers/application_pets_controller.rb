class ApplicationPetsController < ApplicationController
  def create
    # PARAMS via URI: :application_id, :pet_id
    application = Application.find(params[:application_id])
    application.add_pet(params[:pet_id])
    redirect_to "/applications/#{application.id}"
  end

  def update
    # PARAMS via URI: :application_id, :pet_id
    application = Application.find(params[:application_id])
    if params[:update] == 'Approve'
      application.approve_pet(params[:pet_id])
      redirect_to "/admin/applications/#{application.id}"
    elsif params[:update] == 'Reject'
      application.reject_pet(params[:pet_id])
      redirect_to "/admin/applications/#{application.id}"
    end
  end
end
