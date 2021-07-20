class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip_code, :description,
            :status, presence: true
  validates :zip_code, numericality: true, length: { is: 5 }
  has_many :application_pets, :dependent => :destroy
  has_many :pets, through: :application_pets

  def add_pet(params)
    pet = Pet.find(params[:pet_id])
    pets << pet
  end

  def approve_pet(params)
    application_pet = application_pets.find_by(pet_id: params[:pet_id])
    application_pet.update(status: 'Approved')
  end

  def reject_pet(params)
    application_pet = application_pets.find_by(pet_id: params[:pet_id])
    application_pet.update(status: 'Rejected')
  end

  def pet_approved?(pet)
    application_pet = application_pets.find_by(pet_id: pet.id)
    application_pet.status == 'Approved'
  end

  def pet_rejected?(pet)
    application_pet = application_pets.find_by(pet_id: pet.id)
    application_pet.status == 'Rejected'
  end

  def all_pets_approved?
    pets.all? { |pet| pet_approved?(pet) }
  end

  def any_pets_rejected?
    pets.any? { |pet| pet_rejected?(pet) }
  end

  def reviews_remaining?
    pets.any? do |pet|
      application_pets.find_by(pet_id: pet.id).status.nil?
    end
  end
end
