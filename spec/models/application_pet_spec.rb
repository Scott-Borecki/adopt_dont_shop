require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to(:application) }
    it { should belong_to(:pet) }
  end

  describe 'class methods' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
      @pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: @shelter_1.id)

      @application_1 = Application.create!(name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'Pending')

      @application_2 = Application.create!(name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'Pending')

      @application_1.pets << @pet_1
      @application_2.pets << @pet_1

      @application_pet_1 = ApplicationPet.find_by!(application_id: @application_1.id, pet_id: @pet_1.id)
      @application_pet_2 = ApplicationPet.find_by!(application_id: @application_2.id, pet_id: @pet_1.id)
    end

    describe '#action_required' do
      it 'can return the application where action is required' do
        expect(ApplicationPet.action_required(@pet_1)).to eq([@application_pet_1, @application_pet_2])
      end
    end
  end
end
