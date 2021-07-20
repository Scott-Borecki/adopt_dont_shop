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
    it { should validate_length_of(:zip_code).is_equal_to(5) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      @lucille = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
      @lobster = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
      @bear = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: @shelter_1.id)
      @dolly = Pet.create!(adoptable: true, age: 2, breed: 'hound', name: 'Dolly', shelter_id: @shelter_1.id)

      @scott = Application.create!(name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'In Progress')
      @bob = Application.create!(name: 'Bob', street_address: '456 Main Street', city: 'Arvada', state: 'Colorado', zip_code: '80003', description: 'Great with animals!', status: 'Pending')

      @scott.pets << @lucille
      @scott.pets << @lobster
      @scott.pets << @bear

      @bob.pets << @lucille
      @bob.pets << @lobster
      @bob.pets << @bear

      @application_pet_1 = ApplicationPet.find_by!(application_id: @bob.id, pet_id: @lucille.id)
      @application_pet_2 = ApplicationPet.find_by!(application_id: @bob.id, pet_id: @lobster.id)
      @application_pet_3 = ApplicationPet.find_by!(application_id: @bob.id, pet_id: @bear.id)

      @params_scott = { pet_id: @dolly.id}
      @params_bob = { application_id: @bob.id, pet_id: @dolly.id}
    end

    describe '.add_pet' do
      it 'adds pet to application' do
        @scott.add_pet(@params_scott)

        expected = [@lucille, @lobster, @bear, @dolly]
        expect(@scott.pets).to eq(expected)
      end
    end

    describe '.approve_pet' do
      it 'updates application pet status to approved' do
        @bob.pets << @dolly

        @bob.approve_pet(@params_bob)

        actual = ApplicationPet.find_by(@params_bob).status
        expect(actual).to eq('Approved')
      end
    end

    describe '.reject_pet' do
      it 'updates application pet status to rejected' do
        @bob.pets << @dolly

        @bob.reject_pet(@params_bob)

        actual = ApplicationPet.find_by(@params_bob).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '.pet_approved?' do
      it 'returns whether the bob pet has been approved' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.pet_approved?(@lucille)).to eq(true)
        expect(@bob.pet_approved?(@lobster)).to eq(false)
        expect(@bob.pet_approved?(@bear)).to eq(false)
      end
    end

    describe '.pet_rejected?' do
      it 'returns whether the bob pet has been rejected' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.pet_rejected?(@lucille)).to eq(false)
        expect(@bob.pet_rejected?(@lobster)).to eq(true)
        expect(@bob.pet_rejected?(@bear)).to eq(false)
      end
    end

    describe '.all_pets_approved?' do
      it 'returns whether all the pets have been approved' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@bob.all_pets_approved?).to eq(true)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Rejected')

        expect(@bob.all_pets_approved?).to eq(false)
      end
    end

    describe '.any_pets_rejected?' do
      it 'returns whether any pets were rejected' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@bob.any_pets_rejected?).to eq(false)

        @application_pet_1.update(status: 'Rejected')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@bob.any_pets_rejected?).to eq(true)
      end
    end

    describe '.reviews_remaining?' do
      it 'returns whether any reviews are remaining' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.reviews_remaining?).to eq(true)

        @application_pet_3.update(status: 'Approved')

        expect(@bob.reviews_remaining?).to eq(false)
      end
    end
  end
end
