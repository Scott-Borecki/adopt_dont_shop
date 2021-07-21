require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter',
                                city: 'Aurora, CO', foster_program: false,
                                rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate',
                                    breed: 'tuxedo shorthair', age: 5,
                                    adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia',
                                    breed: 'shorthair', age: 3,
                                    adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann',
                                    breed: 'ragdoll', age: 3,
                                    adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.adopt' do
      it 'can adopt a pet and make it not adoptable' do
        expect(@pet_1.adoptable).to be(true)

        @pet_1.adopt

        expect(@pet_1.adoptable).to be(false)
      end
    end

    describe '.actions_required' do
      it 'returns the applications where action is required for pet'  do
        scott = Application.create!(name: 'Scott',
                                    street_address: '123 Main Street',
                                    city: 'Denver', state: 'Colorado',
                                    zip_code: '80202',
                                    description: 'Great with animals!',
                                    status: 'Pending')
        bob = Application.create!(name: 'Bob',
                                  street_address: '456 Main Street',
                                  city: 'Denver', state: 'Colorado',
                                  zip_code: '80202',
                                  description: 'Great with animals!',
                                  status: 'Pending')
        sierra = Application.create!(name: 'Sierra',
                                    street_address: '789 Main Street',
                                    city: 'Arvada', state: 'Colorado',
                                    zip_code: '80003',
                                    description: 'Great with animals!',
                                    status: 'Accepted')
        laura = Application.create!(name: 'Laura',
                                    street_address: '1550 Main Street',
                                    city: 'Aurora', state: 'Colorado',
                                    zip_code: '80010',
                                    description: 'Great with animals!',
                                    status: 'Rejected')

        scott.pets << @pet_1
        scott.pets << @pet_2
        bob.pets << @pet_1
        bob.pets << @pet_2
        sierra.pets << @pet_3
        laura.pets << @pet_1
        laura.pets << @pet_2

        ap_1_scott = @pet_1.application_pets.find_by(application_id: scott.id)
        ap_2_scott = @pet_2.application_pets.find_by(application_id: scott.id)

        ap_1_bob = @pet_1.application_pets.find_by(application_id: bob.id)
        ap_2_bob = @pet_2.application_pets.find_by(application_id: bob.id)
        ap_1_bob.update(status: 'Approved')

        ap_3_sierra = @pet_3.application_pets.find_by(application_id: sierra.id)
        ap_3_sierra.update(status: 'Approved')

        ap_1_laura = @pet_1.application_pets.find_by(application_id: laura.id)
        ap_2_laura = @pet_2.application_pets.find_by(application_id: laura.id)
        ap_1_laura.update(status: 'Rejected')
        ap_2_laura.update(status: 'Approved')

        expect(@pet_1.actions_required).to eq([scott])
        expect(@pet_2.actions_required).to eq([scott, bob])
        expect(@pet_3.actions_required).to eq([])
      end
    end
  end
end
