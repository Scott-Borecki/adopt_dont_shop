class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if @application.reviews_remaining?
    elsif @application.all_pets_approved?
      @application.update(status: 'Accepted')
      @application.adopt_all_pets
    elsif @application.any_pets_rejected?
      @application.update(status: 'Rejected')
    end
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
