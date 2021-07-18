require 'rails_helper'

RSpec.describe 'the admin application show' do
  before :each do
    # SHELTERS
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'Littleton shelter', city: 'Littleton, CO', foster_program: true, rank: 7)
    @shelter_3 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Cenntenial, CO', foster_program: false, rank: 4)
    @shelter_5 = Shelter.create!(name: 'Englewood shelter', city: 'Englewood, CO', foster_program: true, rank: 2)

    # PETS - SHELTER 1
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: @shelter_1.id)

    # PETS - SHELTER 2
    @pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'hound', name: 'Dolly', shelter_id: @shelter_2.id)
    @pet_5 = Pet.create!(adoptable: true, age: 4, breed: 'lab', name: 'Yeller', shelter_id: @shelter_2.id)

    # PETS - SHELTER 3
    @pet_6 = Pet.create!(adoptable: true, age: 1, breed: 'pig', name: 'Babe', shelter_id: @shelter_3.id)
    @pet_7 = Pet.create!(adoptable: true, age: 2, breed: 'orange tabby', name: 'Milo', shelter_id: @shelter_3.id)
    @pet_8 = Pet.create!(adoptable: true, age: 2, breed: 'pug', name: 'Otis', shelter_id: @shelter_3.id)

    # PETS - SHELTER 4
    @pet_9 = Pet.create!(adoptable: true, age: 2, breed: 'st. bernard', name: 'Beethoven', shelter_id: @shelter_4.id)
    @pet_10 = Pet.create!(adoptable: true, age: 7, breed: 'bulldog', name: 'Chance', shelter_id: @shelter_4.id)
    @pet_11 = Pet.create!(adoptable: true, age: 6, breed: 'golden retriever', name: 'Shadow', shelter_id: @shelter_4.id)
    @pet_12 = Pet.create!(adoptable: true, age: 8, breed: 'himalayan cat', name: 'Sassy', shelter_id: @shelter_4.id)

    # PETS - SHELTER 5
    @pet_13 = Pet.create!(adoptable: false, age: 8, breed: 'capuchin monkey', name: 'Crystal', shelter_id: @shelter_5.id)

    # APPLICATIONS
    @bob = Application.create!(name: 'Bob', street_address: '456 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'In Progress')
    @scott = Application.create!(name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'Pending')
    @sierra = Application.create!(name: 'Sierra', street_address: '789 Main Street', city: 'Arvada', state: 'Colorado', zip_code: '80003', description: 'Great with animals!', status: 'Accepted')
    @laura = Application.create!(name: 'Laura', street_address: '1550 Main Street', city: 'Aurora', state: 'Colorado', zip_code: '80010', description: 'Great with animals!', status: 'Rejected')

    # APPLICATION PETS - BOB
    @bob.pets << @pet_3
    @bob.pets << @pet_6
    @bob.pets << @pet_7

    # APPLICATION PETS - SCOTT
    @scott.pets << @pet_1
    @scott.pets << @pet_2
    @scott.pets << @pet_4
    # @scott.pets << @pet_5 # Add back to individual test for pets on multiple applications
    # @scott.pets << @pet_8 # Add back to individual test for pets on multiple applications
    # @scott.pets << @pet_9 # Add back to individual test for pets on multiple applications

    # APPLICATION PETS - SIERRA
    @sierra.pets << @pet_5
    @sierra.pets << @pet_8
    @sierra.pets << @pet_9

    @pet_5.update(adoptable: false)
    @pet_8.update(adoptable: false)
    @pet_9.update(adoptable: false)

    # APPLICATION PETS - LAURA
    @laura.pets << @pet_10
    @laura.pets << @pet_11
    @laura.pets << @pet_12
  end

  describe ' As a visitor, when I visit an admin application show page' do
    it 'displays a button to approve the application for each pet' do
      @scott.pets.each do |pet|
        visit "/admin/applications/#{@scott.id}"

        within "#pet-#{pet.id}" do
          expect(page).to have_content(pet.name)
          expect(page).to have_button('Approve')
        end
      end
    end

    it 'displays a button to reject the application for each pet' do
      @scott.pets.each do |pet|
        visit "/admin/applications/#{@scott.id}"

        within "#pet-#{pet.id}" do
          expect(page).to have_content(pet.name)
          expect(page).to have_button('Reject')
        end
      end
    end

    describe 'When I click the Approve button' do
      it 'can approve a pet' do
        visit "/admin/applications/#{@scott.id}"

        within "#pet-#{@pet_1.id}" do
          click_button 'Approve'
          expect(current_path).to eq("/admin/applications/#{@scott.id}")
          expect(page).to have_content('Approved')
        end
      end
    end

    describe 'When I click the Reject button' do
      it 'can reject a pet' do
        visit "/admin/applications/#{@scott.id}"

        within "#pet-#{@pet_1.id}" do
          click_button 'Reject'
          expect(current_path).to eq("/admin/applications/#{@scott.id}")
          expect(page).to have_content('Rejected')
        end
      end
    end

    describe 'When I approve all the pets' do
      it 'updates the application status to approved' do
        @scott.pets.each do |pet|
          visit "/admin/applications/#{@scott.id}"

          within "#pet-#{pet.id}" do
            click_button 'Approve'
          end
        end

        expect(current_path).to eq("/admin/applications/#{@scott.id}")
        expect(page).to have_content('Application Status: Accepted')
        expect(Application.find(@scott.id).status).to eq('Accepted')
      end
    end

    describe 'When I reject at least one of the pets and approve the rest' do
      it 'updates the application status to rejected' do
        @application_pet_1 = ApplicationPet.find_by!(application_id: @scott.id, pet_id: @pet_1.id)
        @application_pet_2 = ApplicationPet.find_by!(application_id: @scott.id, pet_id: @pet_2.id)
        @application_pet_4 = ApplicationPet.find_by!(application_id: @scott.id, pet_id: @pet_4.id)

        visit "/admin/applications/#{@scott.id}"

        within "#pet-#{@pet_1.id}" do
          click_button 'Approve'
        end

        expect(current_path).to eq("/admin/applications/#{@scott.id}")
        expect(page).to have_content('Application Status: Pending')
        expect(Application.find(@scott.id).status).to eq('Pending')

        within "#pet-#{@pet_2.id}" do
          click_button 'Approve'
        end

        expect(current_path).to eq("/admin/applications/#{@scott.id}")
        expect(page).to have_content('Application Status: Pending')
        expect(Application.find(@scott.id).status).to eq('Pending')

        within "#pet-#{@pet_4.id}" do
          click_button 'Reject'
        end

        expect(current_path).to eq("/admin/applications/#{@scott.id}")
        expect(page).to have_content('Application Status: Rejected')
        expect(Application.find(@scott.id).status).to eq('Rejected')
      end
    end
  end
end
