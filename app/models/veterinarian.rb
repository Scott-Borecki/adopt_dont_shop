class Veterinarian < ApplicationRecord
  belongs_to :veterinary_office

  validates :name, presence: true
  validates :review_rating, presence: true, numericality: true
  validates :on_call, inclusion: { in: [true, false] }

  def self.on_call
    where(on_call: true)
  end

  def office_name
    veterinary_office.name
  end
end
