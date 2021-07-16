class AddTimestampToApplicationPets < ActiveRecord::Migration[5.2]
  def change
    add_column :application_pets, :created_at, :datetime, null: false
    add_column :application_pets, :updated_at, :datetime, null: false
  end
end
