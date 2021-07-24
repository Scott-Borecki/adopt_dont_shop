require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets) }
    it { should validate_inclusion_of(:status).in_array(['In Progress',
                                                         'Pending', 'Accepted',
                                                         'Rejected']) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_numericality_of(:zip_code) }
    it { should validate_length_of(:zip_code).is_equal_to(5) }
    it { should validate_presence_of(:description).on(:update) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(['In Progress',
                                                         'Pending',
                                                         'Accepted',
                                                         'Rejected']) }
  end

  describe 'instance methods' do
    before :each do
      @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO',
                                   foster_program: false, rank: 9)

      @lucille = Pet.create!(adoptable: true, age: 1, breed: 'sphynx',
                             name: 'Lucille Bald', shelter_id: @shelter_1.id)
      @lobster = Pet.create!(adoptable: true, age: 3, breed: 'doberman',
                             name: 'Lobster', shelter_id: @shelter_1.id)
      @bear = Pet.create!(adoptable: true, age: 8, breed: 'spanial',
                          name: 'Bear', shelter_id: @shelter_1.id)
      @dolly = Pet.create!(adoptable: true, age: 2, breed: 'hound',
                           name: 'Dolly', shelter_id: @shelter_1.id)

      @scott = Application.create!(name: 'Scott',
                                   street_address: '123 Main Street',
                                   city: 'Denver', state: 'Colorado',
                                   zip_code: '80202', status: 'In Progress')
      @bob = Application.create!(name: 'Bob', street_address: '456 Main Street',
                                 city: 'Arvada', state: 'Colorado',
                                 zip_code: '80003',
                                 description: 'Great with animals!',
                                 status: 'Pending')
      @sierra = Application.create!(name: 'Sierra',
                                    street_address: '789 Main Street',
                                    city: 'Arvada', state: 'Colorado',
                                    zip_code: '80003',
                                    description: 'Great with animals!',
                                    status: 'In Progress')

      @scott.pets << @lucille << @lobster << @bear

      @bob.pets << @lucille << @lobster << @bear

      @application_pet_1 = ApplicationPet.find_by!(application_id: @bob.id,
                                                   pet_id: @lucille.id)
      @application_pet_2 = ApplicationPet.find_by!(application_id: @bob.id,
                                                   pet_id: @lobster.id)
      @application_pet_3 = ApplicationPet.find_by!(application_id: @bob.id,
                                                   pet_id: @bear.id)

      @params_scott = @dolly.id
      @params_bob = { application_id: @bob.id, pet_id: @dolly.id}
    end

    describe '.add_pet' do
      it 'adds pet to application' do
        @scott.add_pet(@dolly.id)

        expected = [@lucille, @lobster, @bear, @dolly]
        expect(@scott.pets).to eq(expected)
      end
    end

    describe '.approve_pet' do
      it 'updates application pet status to approved' do
        @bob.pets << @dolly

        @bob.approve_pet(@dolly.id)

        actual = ApplicationPet.find_by(@params_bob).status
        expect(actual).to eq('Approved')
      end
    end

    describe '.reject_pet' do
      it 'updates application pet status to rejected' do
        @bob.pets << @dolly

        @bob.reject_pet(@dolly.id)

        # @bob.reload
        actual = ApplicationPet.find_by(@params_bob).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '.pet_approved?' do
      it 'returns whether the bob pet has been approved' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.pet_approved?(@lucille.id)).to eq(true)
        expect(@bob.pet_approved?(@lobster.id)).to eq(false)
        expect(@bob.pet_approved?(@bear.id)).to eq(false)
      end
    end

    describe '.pet_rejected?' do
      it 'returns whether the bob pet has been rejected' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.pet_rejected?(@lucille.id)).to eq(false)
        expect(@bob.pet_rejected?(@lobster.id)).to eq(true)
        expect(@bob.pet_rejected?(@bear.id)).to eq(false)
      end
    end

    describe '.number_of_approved_pets' do
      it 'returns the number of pets approved on the application' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@bob.number_of_approved_pets).to eq(3)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Rejected')

        expect(@bob.number_of_approved_pets).to eq(2)
      end
    end

    describe '.number_of_rejected_pets' do
      it 'returns the number of pets rejected on the application' do
        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Approved')

        expect(@bob.number_of_rejected_pets).to eq(0)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Rejected')

        expect(@bob.number_of_rejected_pets).to eq(1)
      end
    end

    describe '.number_of_pets' do
      it 'returns the number of pets on the application' do
        expect(@bob.number_of_pets).to eq(3)

        @bob.pets << @dolly

        expect(@bob.number_of_pets).to eq(4)
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

    describe '.adopt_all_pets' do
      it 'updates the pets to not be adoptable' do
        @bob.pets.each do |pet|
          expect(pet.adoptable).to eq(true)
        end

        @bob.adopt_all_pets

        @bob.pets.each do |pet|
          expect(pet.adoptable).to eq(false)
        end
      end
    end

    describe '.application_pet_by_pet_id' do
      it 'returns the application pet record by pet id' do
        actual   = @bob.application_pet_by_pet_id(@lucille.id)
        expected = @application_pet_1
        expect(actual).to eq(expected)
      end
    end

    describe '.in_progress?' do
      it 'returns whether the application is in progress' do
        expect(@scott.in_progress?).to eq(true)
        expect(@bob.in_progress?).to eq(false)
      end
    end

    describe '.accept' do
      it 'can update the application status to accepted' do
        @bob.accept
        actual = Application.find(@bob.id).status
        expect(actual).to eq('Accepted')
      end
    end

    describe '.reject' do
      it 'can update the application status to rejected' do
        @bob.reject
        actual = Application.find(@bob.id).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '.process' do
      it 'can not do anything when all reviews are remaining' do
        expected = 'Fail'
        allow(@bob).to receive(:adopt_all_pets).and_return(expected)
        allow(@bob).to receive(:reject).and_return(expected)

        expect(@bob.process).to eq(nil)
        expect(@bob.process).to_not eq(expected)
        expect(@bob.process).to_not eq(expected)
      end

      it 'can not do anything when some reviews are remaining' do
        expected = 'Fail'
        allow(@bob).to receive(:adopt_all_pets).and_return(expected)
        allow(@bob).to receive(:reject).and_return(expected)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')

        expect(@bob.process).to eq(nil)
        expect(@bob.process).to_not eq(expected)
        expect(@bob.process).to_not eq(expected)

        @application_pet_1.update(status: 'Rejected')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.process).to eq(nil)
        expect(@bob.process).to_not eq(expected)
        expect(@bob.process).to_not eq(expected)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Rejected')

        expect(@bob.process).to eq(nil)
        expect(@bob.process).to_not eq(expected)
        expect(@bob.process).to_not eq(expected)
      end

      it 'can accept the application and adopt all pets when all pets are'\
         ' approved' do
        expected = 'Success'
        allow(@bob).to receive(:adopt_all_pets).and_return(expected)

        @bob.application_pets.each do |application_pet|
          application_pet.approve
        end

        expect(@bob.process).to eq(expected)
      end

      it 'can reject the application when all reviews are complete and all '\
         'pets are rejected' do
        expected = 'Success'
        allow(@bob).to receive(:reject).and_return(expected)

        @bob.application_pets.each do |application_pet|
         application_pet.reject
        end

        expect(@bob.process).to eq(expected)
      end

      it 'can reject the application when all reviews are complete and at '\
         'least one pet is rejected' do
        expected = 'Success'
        allow(@bob).to receive(:reject).and_return(expected)

        @application_pet_1.update(status: 'Approved')
        @application_pet_2.update(status: 'Approved')
        @application_pet_3.update(status: 'Rejected')

        expect(@bob.process).to eq(expected)
      end
    end
  end
end
