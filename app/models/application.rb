class Application < ApplicationRecord
  has_many :application_pets, :dependent => :destroy
  has_many :pets, through: :application_pets

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, numericality: true, length: { is: 5 }
  validates :description, presence: true, on: :update
  validates :status, presence: true, inclusion: { in: ['In Progress', 'Pending', 'Accepted', 'Rejected'] }

  def self.pending
    where(status: 'Pending')
  end

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

  def number_of_approved_pets
    application_pets.number_of_approved_pets
  end

  def number_of_rejected_pets
    application_pets.number_of_rejected_pets
  end

  def number_of_pets
    application_pets.size
  end

  def all_pets_approved?
    number_of_pets.positive? &&
      number_of_approved_pets == number_of_pets
  end

  def any_pets_rejected?
    number_of_pets.positive? &&
      number_of_rejected_pets.positive? &&
      number_of_approved_pets + number_of_rejected_pets == number_of_pets
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
    update!(status: 'Accepted')
  end

  def reject
    update!(status: 'Rejected')
  end

  def process
    if all_pets_approved?
      accept
      adopt_all_pets
    elsif any_pets_rejected?
      reject
    end
  end
end
