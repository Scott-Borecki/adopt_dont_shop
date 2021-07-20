class Veterinarian < ApplicationRecord
  validates :name, presence: true
  validates :review_rating, presence: true, numericality: true
  belongs_to :veterinary_office

  def self.on_call
    where(on_call: true)
  end

  def office_name
    veterinary_office.name
  end
end
