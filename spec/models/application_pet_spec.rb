require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to(:application) }
    it { should belong_to(:pet) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status)
           .in_array(['Pending', 'Approved','Rejected']) }
  end

  let!(:shelter_1) do
      Shelter.create!(
      name: 'Aurora shelter',
      city: 'Aurora, CO',
      foster_program: false,
      rank: 9
    )
  end

  let!(:lucille) do
    Pet.create!(
      adoptable: true,
      age: 1,
      breed: 'sphynx',
      name: 'Lucille Bald',
      shelter_id: shelter_1.id
    )
  end

  let!(:bob) do
    Application.create!(
      name: 'Bob',
      street_address: '456 Main Street',
      city: 'Arvada',
      state: 'Colorado',
      zip_code: '80003',
      description: 'Great with animals!',
      status: 'Pending'
    )
  end

  let!(:application_pet_1) do
    ApplicationPet.create!(
      application: bob,
      pet: lucille
    )
  end

  describe 'object creation' do
    it 'has a default status of pending' do
      expect(application_pet_1.status).to eq('Pending')
    end
  end

  describe 'class methods' do
    describe '.approved_pets' do
      it 'returns all the approved pets' do
        expect(ApplicationPet.approved_pets).to eq([])

        application_pet_1.approve

        expect(ApplicationPet.approved_pets).to eq([application_pet_1])
      end
    end

    describe '.rejected_pets' do
      it 'returns all the rejected pets' do
        expect(ApplicationPet.rejected_pets).to eq([])

        application_pet_1.reject

        expect(ApplicationPet.rejected_pets).to eq([application_pet_1])
      end
    end

    describe '.number_of_approved_pets' do
      it 'returns the number of approved pets' do
        expect(ApplicationPet.approved_pets).to eq([])

        application_pet_1.approve

        expect(ApplicationPet.number_of_approved_pets).to eq(1)
      end
    end

    describe '.number_of_rejected_pets' do
      it 'returns the number of rejected pets' do
        expect(ApplicationPet.rejected_pets).to eq([])

        application_pet_1.reject

        expect(ApplicationPet.number_of_rejected_pets).to eq(1)
      end
    end
  end

  describe 'instance methods' do
    describe '#approve' do
      it 'approves a pet on an application' do
        expect(application_pet_1.status).to eq('Pending')

        application_pet_1.approve

        expect(application_pet_1.status).to eq('Approved')
      end
    end

    describe '#reject' do
      it 'rejects a pet on an application' do
        expect(application_pet_1.status).to eq('Pending')

        application_pet_1.reject

        expect(application_pet_1.status).to eq('Rejected')
      end
    end

    describe '#approved?' do
      it 'returns whether a pet is approved on an application' do
        expect(application_pet_1).to_not be_approved

        application_pet_1.approve

        expect(application_pet_1).to be_approved
      end
    end

    describe '#rejected?' do
      it 'can return whether a pet is rejeced on an application' do
        expect(application_pet_1).to_not be_rejected

        application_pet_1.reject

        expect(application_pet_1).to be_rejected
      end
    end
  end
end
