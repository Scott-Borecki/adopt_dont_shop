class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip_code, :status,
            presence: true
  validates :description, presence: true, on: :update
  validates :zip_code, numericality: true, length: { is: 5 }
  validates :status, inclusion: { in: ['In Progress', 'Pending', 'Accepted', 'Rejected'] }
  has_many :application_pets, :dependent => :destroy
  has_many :pets, through: :application_pets

  def add_pet(pet_id)
    pet = Pet.find(pet_id)
    pets << pet
  end

  def approve_pet(pet_id)
    application_pet_by_pet_id(pet_id).approve
  end

  def reject_pet(pet_id)
    application_pet_by_pet_id(pet_id).reject
  end

  def pet_approved?(pet_id)
    application_pet_by_pet_id(pet_id).approved?
  end

  def pet_rejected?(pet_id)
    application_pet_by_pet_id(pet_id).rejected?
  end

  def all_pets_approved?
    pets.all? { |pet| pet_approved?(pet.id) }
  end

  def any_pets_rejected?
    pets.any? { |pet| pet_rejected?(pet.id) }
  end

  def reviews_remaining?
    pets.any? { |pet| application_pet_by_pet_id(pet.id).pending? }
  end

  def application_pet_by_pet_id(pet_id)
    application_pets.find_by(pet_id: pet_id)
  end
end
