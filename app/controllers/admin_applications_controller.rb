class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if @application.reviews_remaining?
    elsif @application.all_pets_approved?
      @application.update(status: 'Accepted')
    elsif @application.any_pets_rejected?
      @application.update(status: 'Rejected')
    end
  end

  def approve_pet
    @application = Application.find(params[:application_id])
    @pet = Pet.find(params[:pet_id])
    @application_pet = ApplicationPet.find_by!(application_id: @application.id, pet_id: @pet.id)
    @application_pet.update(status: 'Approved')
    redirect_to "/admin/applications/#{@application.id}"
  end

  def reject_pet
    @application = Application.find(params[:application_id])
    @pet = Pet.find(params[:pet_id])
    @application_pet = ApplicationPet.find_by!(application_id: @application.id, pet_id: @pet.id)
    @application_pet.update(status: 'Rejected')
    redirect_to "/admin/applications/#{@application.id}"
  end
end
