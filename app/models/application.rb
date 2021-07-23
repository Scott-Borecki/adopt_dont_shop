class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip_code, :status,
            presence: true
  validates :description, presence: true, on: :update
  validates :zip_code, numericality: true, length: { is: 5 }
  validates :status, presence: true
  validates :status, inclusion: { in: ['In Progress', 'Pending', 'Accepted',
                                       'Rejected'] }
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

  def number_of_pets_approved
    application_pets.where(status: 'Approved').length
  end

  def number_of_pets_rejected
    application_pets.where(status: 'Rejected').length
  end

  def number_of_pets
    application_pets.length
  end

  def all_pets_approved?
    number_of_pets_approved == number_of_pets
  end

  def any_pets_rejected?
    number_of_pets_rejected.positive?
  end

  def reviews_remaining?
    status == 'In Progress' ||
      number_of_pets.zero? ||
      number_of_pets_approved + number_of_pets_rejected < number_of_pets
  end

  def adopt_all_pets
    pets.each(&:adopt)
  end

  def application_pet_by_pet_id(pet_id)
    application_pets.find_by(pet_id: pet_id)
  end

  def in_progress?
    status == 'In Progress'
  end

  def accept
    update(status: 'Accepted')
  end

  def reject
    update(status: 'Rejected')
  end
end
