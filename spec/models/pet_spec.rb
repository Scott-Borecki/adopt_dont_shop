require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
    it { should validate_presence_of(:name) }
  end

  let!(:shelter_1) do
    Shelter.create!(
      name: 'Aurora shelter',
      city: 'Aurora, CO',
      foster_program: false,
      rank: 9
    )
  end

  let!(:pet_1) do
    shelter_1.pets.create!(
      name: 'Mr. Pirate',
      breed: 'tuxedo shorthair',
      age: 5,
      adoptable: true
    )
  end

  let!(:pet_2) do
    shelter_1.pets.create!(
      name: 'Clawdia',
      breed: 'shorthair',
      age: 3,
      adoptable: true
    )
  end

  let!(:pet_3) do
    shelter_1.pets.create!(
      name: 'Ann',
      breed: 'ragdoll',
      age: 3,
      adoptable: false
    )
  end

  describe 'class methods' do
    describe '.search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([pet_2])
      end
    end

    describe '.adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([pet_1, pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '#shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(pet_3.shelter_name).to eq(shelter_1.name)
      end
    end

    describe '#not_adoptable?' do
      context 'when pet is adoptable' do
        specify { expect(pet_1).to_not be_not_adoptable }
      end

      context 'when pet is not adoptable' do
        specify { expect(pet_3).to be_not_adoptable }
      end
    end

    describe '#adopt' do
      it 'adopts a pet and make it not adoptable' do
        expect(pet_1.adoptable).to be(true)

        pet_1.adopt

        expect(pet_1.adoptable).to be(false)
      end
    end

    describe '#actions_required' do
      it 'returns the applications where action is required for pet'  do
        scott = Application.create!(
          name: 'Scott',
          street_address: '123 Main Street',
          city: 'Denver',
          state: 'Colorado',
          zip_code: '80202',
          description: 'Great with animals!',
          status: 'Pending'
        )
        bob = Application.create!(
          name: 'Bob',
          street_address: '456 Main Street',
          city: 'Denver',
          state: 'Colorado',
          zip_code: '80202',
          description: 'Great with animals!',
          status: 'Pending'
        )
        sierra = Application.create!(
          name: 'Sierra',
          street_address: '789 Main Street',
          city: 'Arvada',
          state: 'Colorado',
          zip_code: '80003',
          description: 'Great with animals!',
          status: 'Accepted'
        )
        laura = Application.create!(
          name: 'Laura',
          street_address: '1550 Main Street',
          city: 'Aurora',
          state: 'Colorado',
          zip_code: '80010',
          description: 'Great with animals!',
          status: 'Rejected'
        )

        ApplicationPet.create!(application: scott, pet: pet_1)
        ApplicationPet.create!(application: scott, pet: pet_2)

        ApplicationPet.create!(application: bob, pet: pet_1, status: 'Approved')
        ApplicationPet.create!(application: bob, pet: pet_2)

        ApplicationPet.create!(application: sierra, pet: pet_3, status: 'Approved')

        ApplicationPet.create!(application: laura, pet: pet_1, status: 'Rejected')
        ApplicationPet.create!(application: laura, pet: pet_2, status: 'Approved')

        expect(pet_1.actions_required).to eq([scott])
        expect(pet_2.actions_required).to eq([scott, bob])
        expect(pet_3.actions_required).to eq([])
      end
    end
  end
end
