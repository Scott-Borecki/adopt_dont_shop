class AddDefaultValuesToBooleans < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pets, :adoptable, from: nil, to: true
    change_column_null :pets, :adoptable, false

    change_column_default :shelters, :foster_program, from: nil, to: true
    change_column_null :shelters, :foster_program, false

    change_column_default :veterinarians, :on_call, from: nil, to: true
    change_column_null :veterinarians, :on_call, false

    change_column_default :veterinary_offices, :boarding_services, from: nil, to: true
    change_column_null :veterinary_offices, :boarding_services, false
  end
end
