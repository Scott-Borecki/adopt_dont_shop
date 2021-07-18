class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip_code, :description,
            :status, presence: true
  validates :zip_code, numericality: true
  has_many :application_pets, :dependent => :destroy
  has_many :pets, through: :application_pets

  def pet_approved?(pet)
    application_pet = ApplicationPet.find_by!(application_id: id, pet_id: pet.id)
    application_pet.status == 'Approved'
  end
end
