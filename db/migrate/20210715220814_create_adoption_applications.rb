class CreateAdoptionApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :adoption_applications do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :description
      t.string :status
      
      t.timestamps
    end
  end
end
