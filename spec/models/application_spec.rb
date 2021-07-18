require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_numericality_of(:zip_code) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
      @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
      @pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: @shelter_1.id)

      @application = Application.create!(name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'Pending')

      @application.pets << @pet_1
      @application.pets << @pet_2
      @application.pets << @pet_3

      @application_pet_1 = ApplicationPet.find_by!(application_id: @application.id, pet_id: @pet_1.id)
      @application_pet_2 = ApplicationPet.find_by!(application_id: @application.id, pet_id: @pet_2.id)
      @application_pet_3 = ApplicationPet.find_by!(application_id: @application.id, pet_id: @pet_3.id)
    end

    describe '.pet_approved?' do
      it 'returns whether the application pet has been approved' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@application.pet_approved?(@pet_1)).to eq(true)
        expect(@application.pet_approved?(@pet_2)).to eq(false)
        expect(@application.pet_approved?(@pet_3)).to eq(false)
      end
    end

    describe '.pet_rejected?' do
      it 'returns whether the application pet has been rejected' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@application.pet_rejected?(@pet_1)).to eq(false)
        expect(@application.pet_rejected?(@pet_2)).to eq(true)
        expect(@application.pet_rejected?(@pet_3)).to eq(false)
      end
    end

    describe '.all_pets_approved?' do
      it 'returns whether all the pets have been approved' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@application.all_pets_approved?).to eq(true)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Rejected')

        expect(@application.all_pets_approved?).to eq(false)
      end
    end

    describe '.any_pets_rejected?' do
      it 'returns whether any pets were rejected' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@application.any_pets_rejected?).to eq(false)

        @application_pet_1.update(status: 'Rejected')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@application.any_pets_rejected?).to eq(true)
      end
    end
  end
end
