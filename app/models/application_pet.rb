class ApplicationPet < ApplicationRecord
  validates :status, presence: true
  validates :status, inclusion: { in: %w(Pending Approved Rejected) }
  belongs_to :pet
  belongs_to :application

  def self.approved_pets
    where(status: 'Approved')
  end

  def self.rejected_pets
    where(status: 'Rejected')
  end

  def self.number_of_approved_pets
    approved_pets.length
  end

  def self.number_of_rejected_pets
    rejected_pets.length
  end

  def approve
    update(status: 'Approved')
  end

  def reject
    update(status: 'Rejected')
  end

  def approved?
    status == 'Approved'
  end

  def rejected?
    status == 'Rejected'
  end
end
