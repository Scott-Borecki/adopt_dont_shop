require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  describe 'methods' do

    let!(:shelter_1) do
      Shelter.create(
        name: 'Aurora shelter',
        city: 'Aurora, CO',
        foster_program: false,
        rank: 9
      )
    end

    let!(:shelter_2) do
      Shelter.create(
        name: 'RGV animal shelter',
        city: 'Harlingen, TX',
        foster_program: false,
        rank: 5
      )
    end

    let!(:shelter_3) do
      Shelter.create(
        name: 'Fancy pets of Colorado',
        city: 'Denver, CO',
        foster_program: true,
        rank: 10
      )
    end

    let!(:pet_1) do
      shelter_1.pets.create(
        name: 'Mr. Pirate',
        breed: 'tuxedo shorthair',
        age: 5,
        adoptable: false
      )
    end

    let!(:pet_2) do
      shelter_1.pets.create(
        name: 'Clawdia',
        breed: 'shorthair',
        age: 3,
        adoptable: true
      )
    end

    let!(:pet_3) do
      shelter_3.pets.create(
        name: 'Lucille Bald',
        breed: 'sphynx',
        age: 8,
        adoptable: true
      )
    end

    let!(:pet_4) do
      shelter_1.pets.create(
        name: 'Ann',
        breed: 'ragdoll',
        age: 5,
        adoptable: true
      )
    end

    let(:scott) do
      Application.create!(
        name: 'Scott',
        street_address: '123 Main Street',
        city: 'Denver',
        state: 'Colorado',
        zip_code: '80202',
        description: 'Great with animals!',
        status: 'Pending'
      )
    end

    let(:bob) do
      Application.create!(
        name: 'Bob',
        street_address: '456 Main Street',
        city: 'Denver',
        state: 'Colorado',
        zip_code: '80202',
        description: 'Great with animals!',
        status: 'In Progress'
      )
    end

    let(:sierra) do
      Application.create!(
        name: 'Sierra',
        street_address: '345 Main Street',
        city: 'Arvada',
        state: 'Colorado',
        zip_code: '80003',
        description: 'Great with animals!',
        status: 'Pending'
      )
    end

    describe 'class methods' do
      describe '.search' do
        it 'returns partial matches' do
          expect(Shelter.search("Fancy")).to eq([shelter_3])
        end
      end

      describe '.order_by_recently_created' do
        it 'returns shelters with the most recently created first' do
          expect(Shelter.order_by_recently_created)
            .to eq([shelter_3, shelter_2, shelter_1])
        end
      end

      describe '.order_by_number_of_pets' do
        it 'orders the shelters by number of pets they have, descending' do
          expect(Shelter.order_by_number_of_pets)
            .to eq([shelter_1, shelter_3, shelter_2])
        end
      end

      describe '.order_by_name' do
        it 'orders the shelters by name in alphabetical order' do
          expect(Shelter.order_by_name)
            .to eq([shelter_1, shelter_3, shelter_2])
        end
      end

      describe '.order_by_name_reverse' do
        it 'orders the shelters by name in reverse alphabetical order' do
          expect(Shelter.order_by_name_reverse)
            .to eq([shelter_2, shelter_3, shelter_1])
        end
      end

      describe '.with_pending_applications' do
        it 'returns the shelters that have pending applications' do
          bob.pets << pet_3 << pet_4
          scott.pets << pet_1 << pet_2

          expect(Shelter.with_pending_applications).to eq([shelter_1])
        end
      end

      describe '.sql_find_by_id' do
        it 'returns the shelter record' do
          expect(Shelter.sql_find_by_id(shelter_1.id)).to eq(shelter_1)
        end
      end
    end

    describe 'instance methods' do
      describe '#adoptable_pets' do
        it 'returns only pets that are adoptable' do
          expect(shelter_1.adoptable_pets).to eq([pet_2, pet_4])
        end
      end

      describe '#alphabetical_pets' do
        it 'returns pets associated with the given shelter in alphabetical '\
           'name order' do
          expect(shelter_1.alphabetical_pets).to eq([pet_4, pet_2])
        end
      end

      describe '#shelter_pets_filtered_by_age' do
        it 'filters the shelter pets based on given params' do
          expect(shelter_1.shelter_pets_filtered_by_age(5)).to eq([pet_4])
        end
      end

      describe '#pet_count' do
        it 'returns the number of pets at the given shelter' do
          expect(shelter_1.pet_count).to eq(3)
        end
      end

      describe '#average_age_of_adoptable_pets' do
        it 'returns the average age of the adoptable pets' do
          expect(shelter_1.average_age_of_adoptable_pets).to eq(4)
        end

        it 'returns zero if there are no adoptable pets' do
          expect(shelter_2.average_age_of_adoptable_pets).to eq(0)
        end
      end

      describe '#number_of_adoptable_pets' do
        it 'returns the number of adoptable pets' do
          expect(shelter_1.number_of_adoptable_pets).to eq(2)
        end
      end

      describe '#number_of_pets_adopted' do
        it 'returns the number of pets adopted' do
          scott.pets << pet_3 << pet_4

          bob.pets << pet_1 << pet_2
          bob.update!(status: 'Accepted')
          pet_2.update!(adoptable: false)

          expect(shelter_1.number_of_pets_adopted).to eq(2)
          expect(shelter_2.number_of_pets_adopted).to eq(0)
          expect(shelter_3.number_of_pets_adopted).to eq(0)
        end
      end

      describe '#action_required' do
        it 'returns pets where action is required' do
          scott.pets << pet_2 << pet_4
          bob.pets << pet_4
          sierra.pets << pet_4

          expect(shelter_1.action_required).to eq([pet_2, pet_4])
        end
      end
    end
  end
end
