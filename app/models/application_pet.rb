class ApplicationPet < ApplicationRecord
  validates :status, presence: true
  validates :status, inclusion: { in: %w(Pending Approved Rejected) }
  belongs_to :pet
  belongs_to :application

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
