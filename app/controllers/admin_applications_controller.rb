class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if @application.reviews_remaining?
    elsif @application.all_pets_approved?
      @application.update(status: 'Accepted')
      @application.pets.each { |pet| pet.adopt }
    elsif @application.any_pets_rejected?
      @application.update(status: 'Rejected')
    end
  end

  def approve_pet
    application = Application.find(params[:application_id])
    application_pet = application.application_pets.find_by(pet_id: params[:pet_id])
    application_pet.update(status: 'Approved')
    redirect_to "/admin/applications/#{application.id}"
  end

  def reject_pet
    application = Application.find(params[:application_id])
    application_pet = application.application_pets.find_by(pet_id: params[:pet_id])
    application_pet.update(status: 'Rejected')
    redirect_to "/admin/applications/#{application.id}"
  end
end
