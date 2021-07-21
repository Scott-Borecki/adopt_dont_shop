require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to(:application) }
    it { should belong_to(:pet) }
    it { should validate_presence_of(:status).on(:create) }
  end

  describe 'object creation' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      @lucille = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)

      @bob = Application.create!(name: 'Bob', street_address: '456 Main Street', city: 'Arvada', state: 'Colorado', zip_code: '80003', description: 'Great with animals!', status: 'Pending')

      @bob.pets << @lucille

      @application_pet_1 = ApplicationPet.find_by!(application_id: @bob.id, pet_id: @lucille.id)
    end

    it 'has a default status of pending' do
      expect(@application_pet_1.status).to eq('Pending')
    end
  end

  describe 'instance methods' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      @lucille = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)

      @bob = Application.create!(name: 'Bob', street_address: '456 Main Street', city: 'Arvada', state: 'Colorado', zip_code: '80003', description: 'Great with animals!', status: 'Pending')

      @bob.pets << @lucille

      @application_pet_1 = ApplicationPet.find_by!(application_id: @bob.id, pet_id: @lucille.id)
    end

    describe '.approve' do
      it 'can approve a pet on an application' do
        expect(@application_pet_1.status).to eq('Pending')

        @application_pet_1.approve

        actual = ApplicationPet.find(@application_pet_1.id).status
        expect(actual).to eq('Approved')
      end
    end

    describe '.reject' do
      it 'can reject a pet on an application' do
        expect(@application_pet_1.status).to eq('Pending')

        @application_pet_1.reject

        actual = ApplicationPet.find(@application_pet_1.id).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '.approved?' do
      it 'can return whether a pet is approved on an application' do
        expect(@application_pet_1.approved?).to eq(false)

        @application_pet_1.approve

        actual = ApplicationPet.find(@application_pet_1.id)
        expect(actual.approved?).to eq(true)
      end
    end

    describe '.pending?' do
      it 'can return whether a pet is approved on an application' do
        expect(@application_pet_1.pending?).to eq(true)

        @application_pet_1.update(status: 'Approved')

        actual = ApplicationPet.find(@application_pet_1.id)
        expect(actual.pending?).to eq(false)
      end
    end

    describe '.rejected?' do
      it 'can return whether a pet is rejeced on an application' do
        expect(@application_pet_1.rejected?).to eq(false)

        @application_pet_1.reject

        actual = ApplicationPet.find(@application_pet_1.id)
        expect(actual.rejected?).to eq(true)
      end
    end
  end
end
