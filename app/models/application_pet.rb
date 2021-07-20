class ApplicationPet < ApplicationRecord
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
