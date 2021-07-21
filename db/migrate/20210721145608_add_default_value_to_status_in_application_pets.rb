class AddDefaultValueToStatusInApplicationPets < ActiveRecord::Migration[5.2]
  def change
    change_column_default :application_pets, :status, from: nil, to: "Pending"
  end
end
