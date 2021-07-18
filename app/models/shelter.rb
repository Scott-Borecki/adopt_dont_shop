class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.order_by_name_reverse
    find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  def self.with_pending_applications
    joins(pets: [{application_pets: :application}]).where(applications: { status: 'Pending' }).distinct
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def average_age_of_adoptable_pets
    number_of_adoptable_pets > 0 ? adoptable_pets.average(:age).round(2) : 0
  end

  def number_of_adoptable_pets
    adoptable_pets.count
  end

  def number_of_pets_adopted
    pets.joins(:applications).where(applications: { status: 'Accepted' }).count
  end
end
