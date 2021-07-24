class Pet < ApplicationRecord
  belongs_to :shelter

  has_many :application_pets, :dependent => :destroy
  has_many :applications, through: :application_pets

  validates :name, presence: true
  validates :adoptable, inclusion: { in: [true, false] }
  validates :age, presence: true, numericality: true

  def self.adoptable
    where(adoptable: true)
  end

  def shelter_name
    shelter.name
  end

  def not_adoptable?
    adoptable == false
  end

  def adopt
    update!(adoptable: false)
  end

  def actions_required
    applications.where(application_pets: { status: 'Pending' })
  end
end
