class Application < ApplicationRecord
  validates :name, :street_address, :city, :state, :zip_code, :description,
            :status, presence: true
  validates :zip_code, numericality: true
  has_many :application_pets, :dependent => :destroy
  has_many :pets, through: :application_pets
end
