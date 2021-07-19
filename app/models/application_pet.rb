class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  def self.action_required(pet)
    where(pet_id: pet.id).where(status: nil)
  end
end
