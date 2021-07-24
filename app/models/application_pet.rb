class ApplicationPet < ApplicationRecord
  # TODO(Scott Borecki): Check out enums for default statuses by integers

  belongs_to :pet
  belongs_to :application

  validates :status, presence: true,
                     inclusion: { in: %w[Pending Approved Rejected] }

  def self.approved_pets
    where(status: 'Approved')
  end

  def self.rejected_pets
    where(status: 'Rejected')
  end

  def self.number_of_approved_pets
    approved_pets.size
  end

  def self.number_of_rejected_pets
    rejected_pets.size
  end

  def approve
    update!(status: 'Approved')
  end

  def reject
    update!(status: 'Rejected')
  end

  def approved?
    status == 'Approved'
  end

  def rejected?
    status == 'Rejected'
  end
end
