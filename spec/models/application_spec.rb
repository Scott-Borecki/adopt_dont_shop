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
    it { should validate_presence_of(:description).on(:update) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(['In Progress',
                                                         'Pending',
                                                         'Accepted',
                                                         'Rejected']) }
  end

  let!(:scott) do
    Application.create!(name: 'Scott',
      street_address: '123 Main Street',
      city: 'Denver', state: 'Colorado',
      zip_code: '80202', status: 'In Progress'
    )
  end

  let!(:bob) do
    Application.create!(
      name: 'Bob',
      street_address: '456 Main Street',
      city: 'Arvada', state: 'Colorado',
      zip_code: '80003',
      description: 'Great with animals!',
      status: 'Pending'
    )
  end

  let!(:sierra) do
    Application.create!(
      name: 'Sierra',
      street_address: '789 Main Street',
      city: 'Arvada', state: 'Colorado',
      zip_code: '80003',
      description: 'Great with animals!',
      status: 'In Progress'
    )
  end

  describe 'class methods' do
    describe '.pending' do
      it 'returns all pending applications' do
        expect(Application.pending).to eq([bob])
        expect(Application.pending).to_not include(scott)
        expect(Application.pending).to_not include(sierra)
      end
    end

    describe '.in_progress' do
      it 'returns all in progress applications' do
        expect(Application.in_progress).to eq([scott, sierra])
        expect(Application.in_progress).to_not include(bob)
      end
    end
  end

  describe 'instance methods' do
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

    let!(:lobster) do
      Pet.create!(
        adoptable: true,
        age: 3,
        breed: 'doberman',
        name: 'Lobster',
        shelter_id: shelter_1.id
      )
    end

    let!(:bear) do
      Pet.create!(
        adoptable: true,
        age: 8,
        breed: 'spanial',
        name: 'Bear',
        shelter_id: shelter_1.id
      )
    end

    let!(:dolly) do
      Pet.create!(
        adoptable: true,
        age: 2,
        breed: 'hound',
        name: 'Dolly',
        shelter_id: shelter_1.id
      )
    end

    let!(:application_pet_1) do
      ApplicationPet.create!(application: bob, pet: lucille)
    end

    let!(:application_pet_2) do
      ApplicationPet.create!(application: bob, pet: lobster)
    end

    let!(:application_pet_3) do
      ApplicationPet.create!(application: bob, pet: bear)
    end

    let!(:application_pet_4) do
      ApplicationPet.create!(application: scott, pet: lucille)
    end

    let!(:application_pet_5) do
      ApplicationPet.create!(application: scott, pet: lobster)
    end

    let!(:application_pet_6) do
      ApplicationPet.create!(application: scott, pet: bear)
    end

    let(:params_scott) { dolly.id }
    let(:params_bob) { { application_id: bob.id, pet_id: dolly.id } }

    describe '#add_pet' do
      it 'adds pet to application' do
        scott.add_pet(dolly.id)

        expected = [lucille, lobster, bear, dolly]
        expect(scott.pets).to eq(expected)
      end
    end

    describe '#approve_pet' do
      it 'updates application pet status to approved' do
        bob.pets << dolly

        bob.approve_pet(dolly.id)

        actual = ApplicationPet.find_by(params_bob).status
        expect(actual).to eq('Approved')
      end
    end

    describe '#reject_pet' do
      it 'updates application pet status to rejected' do
        bob.pets << dolly

        bob.reject_pet(dolly.id)

        actual = ApplicationPet.find_by(params_bob).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '#pet_approved?' do
      before do
        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Rejected')
      end

      context 'when pet is approved' do
        specify { expect(bob.pet_approved?(lucille.id)).to eq(true) }
      end

      context 'when pet is rejected' do
        specify { expect(bob.pet_approved?(lobster.id)).to eq(false) }
      end
    end

    describe '#pet_rejected?' do
      before do
        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Rejected')
      end

      context 'when pet is approved' do
        specify { expect(bob.pet_rejected?(lucille.id)).to eq(false) }
      end

      context 'when pet is rejected' do
        specify { expect(bob.pet_rejected?(lobster.id)).to eq(true) }
      end
    end

    describe '#number_of_approved_pets' do
      it 'returns the number of pets approved on the application' do
        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Approved')
        application_pet_3.update(status: 'Approved')

        expect(bob.number_of_approved_pets).to eq(3)

        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Approved')
        application_pet_3.update(status: 'Rejected')

        expect(bob.number_of_approved_pets).to eq(2)
      end
    end

    describe '#number_of_rejected_pets' do
      it 'returns the number of pets rejected on the application' do
        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Approved')
        application_pet_3.update(status: 'Approved')

        expect(bob.number_of_rejected_pets).to eq(0)

        application_pet_1.update(status: 'Approved')
        application_pet_2.update(status: 'Approved')
        application_pet_3.update(status: 'Rejected')

        expect(bob.number_of_rejected_pets).to eq(1)
      end
    end

    describe '#number_of_pets' do
      it 'returns the number of pets on the application' do
        expect(bob.number_of_pets).to eq(3)

        bob.pets << dolly

        expect(bob.number_of_pets).to eq(4)
      end
    end

    describe '#all_pets_approved?' do
      context 'when all pets are approved' do
        specify do
          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Approved')
          application_pet_3.update(status: 'Approved')

          expect(bob).to be_all_pets_approved
        end
      end

      context 'when not all pets are approved' do
        specify do
          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Approved')
          application_pet_3.update(status: 'Rejected')

          expect(bob).to_not be_all_pets_approved
        end
      end
    end

    describe '#any_pets_rejected?' do
      context 'when all pets are approved' do
        specify do
          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Approved')
          application_pet_3.update(status: 'Approved')

          expect(bob).to_not be_any_pets_rejected
        end
      end

      context 'when not all pets are approved' do
        specify do
          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Approved')
          application_pet_3.update(status: 'Rejected')

          expect(bob).to be_any_pets_rejected
        end
      end
    end

    describe '#adopt_all_pets' do
      it 'updates the pets to not be adoptable' do
        bob.pets.each do |pet|
          expect(pet.adoptable).to eq(true)
        end

        bob.adopt_all_pets

        bob.pets.each do |pet|
          expect(pet.adoptable).to eq(false)
        end
      end
    end

    describe '#application_pet_by_pet_id' do
      it 'returns the application pet record by pet id' do
        actual   = bob.application_pet_by_pet_id(lucille.id)
        expected = application_pet_1
        expect(actual).to eq(expected)
      end
    end

    describe '#in_progress?' do
      context 'when application status is "In Progress"' do
        specify { expect(scott).to be_in_progress }
      end

      context 'when application status is not "In Progress"' do
        specify { expect(bob).to_not be_in_progress }
      end
    end

    describe '#pending?' do
      context 'when application status is "Pending"' do
        specify { expect(bob).to be_pending }
      end

      context 'when application status is not "Pending"' do
        specify { expect(scott).to_not be_pending }
      end
    end

    describe '#accept' do
      it 'updates the application status to accepted' do
        bob.accept
        actual = Application.find(bob.id).status
        expect(actual).to eq('Accepted')
      end
    end

    describe '#reject' do
      it 'updates the application status to rejected' do
        bob.reject
        actual = Application.find(bob.id).status
        expect(actual).to eq('Rejected')
      end
    end

    describe '#process' do
      context 'when all reviews are remaining' do
        it 'does nothing' do
          expected = 'Fail'
          allow(bob).to receive(:adopt_all_pets).and_return(expected)
          allow(bob).to receive(:reject).and_return(expected)

          expect(bob.process).to eq(nil)
          expect(bob.process).to_not eq(expected)
          expect(bob.process).to_not eq(expected)
        end
      end

      context 'when some reviews are remaining' do
        it 'does nothing' do
          expected = 'Fail'
          allow(bob).to receive(:adopt_all_pets).and_return(expected)
          allow(bob).to receive(:reject).and_return(expected)

          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Approved')

          expect(bob.process).to eq(nil)
          expect(bob.process).to_not eq(expected)
          expect(bob.process).to_not eq(expected)

          application_pet_1.update(status: 'Rejected')
          application_pet_2.update(status: 'Rejected')

          expect(bob.process).to eq(nil)
          expect(bob.process).to_not eq(expected)
          expect(bob.process).to_not eq(expected)

          application_pet_1.update(status: 'Approved')
          application_pet_2.update(status: 'Rejected')

          expect(bob.process).to eq(nil)
          expect(bob.process).to_not eq(expected)
          expect(bob.process).to_not eq(expected)
        end
      end

      context 'when all reviews are complete' do
        context 'when all pets are approved' do
          it 'accepts the application and adopt all pets' do
            expected = 'Success'
            allow(bob).to receive(:adopt_all_pets).and_return(expected)

            bob.application_pets.each do |application_pet|
              application_pet.approve
            end

            expect(bob.process).to eq(expected)
          end
        end

        context 'when all pets are rejected' do
          it 'rejects the application' do
            expected = 'Success'
            allow(bob).to receive(:reject).and_return(expected)

            bob.application_pets.each do |application_pet|
             application_pet.reject
            end

            expect(bob.process).to eq(expected)
          end
        end

        context 'when at least one pet is rejected' do
          it 'rejects the application' do
            expected = 'Success'
            allow(bob).to receive(:reject).and_return(expected)

            application_pet_1.update(status: 'Approved')
            application_pet_2.update(status: 'Approved')
            application_pet_3.update(status: 'Rejected')

            expect(bob.process).to eq(expected)
          end
        end
      end
    end
  end
end
