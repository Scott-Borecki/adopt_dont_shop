require 'rails_helper'

RSpec.describe ' applications show' do
  describe 'as a visitor' do
    describe 'when I visit an applications show page' do
      before :each do
        @shelter = Shelter.create!(name: 'Aurora shelter',
                                   city: 'Aurora, CO',
                                   foster_program: false,
                                   rank: 9)

        @pet_1 = Pet.create!(adoptable: true,
                             age: 1,
                             breed: 'sphynx',
                             name: 'Lucille Bald',
                             shelter_id: @shelter.id)

        @pet_2 = Pet.create!(adoptable: true,
                             age: 3,
                             breed: 'doberman',
                             name: 'Lobster',
                             shelter_id: @shelter.id)

        @pet_3 = Pet.create!(adoptable: true,
                             age: 8,
                             breed: 'spanial',
                             name: 'Bear',
                             shelter_id: @shelter.id)

        @pet_6 = Pet.create!(adoptable: true,
                            age: 1,
                            breed: 'pig',
                            name: 'Babe',
                            shelter_id: @shelter.id)

        @pet_7 = Pet.create!(adoptable: true,
                            age: 2,
                            breed: 'orange tabby',
                            name: 'Milo',
                            shelter_id: @shelter.id)

        @scott = Application.create!(name: 'Scott',
                                     street_address: '123 Main Street',
                                     city: 'Denver',
                                     state: 'Colorado',
                                     zip_code: '80202',
                                     description: 'Great with animals!',
                                     status: 'Pending')

        @bob = Application.create!(name: 'Bob',
                                  street_address: '456 Main Street',
                                  city: 'Denver',
                                  state: 'Colorado',
                                  zip_code: '80202',
                                  description: 'Great with animals!',
                                  status: 'In Progress')
      end

      it 'can show the applications attributes' do
        @scott.pets << @pet_1
        @scott.pets << @pet_2

        visit "/applications/#{@scott.id}"

        expect(page).to have_content(@scott.name)
        expect(page).to have_content(@scott.street_address)
        expect(page).to have_content(@scott.city)
        expect(page).to have_content(@scott.state)
        expect(page).to have_content(@scott.zip_code)
        expect(page).to have_content(@scott.description)
        expect(page).to have_link(@pet_1.name)
        expect(page).to have_link(@pet_2.name)
        expect(page).to have_content(@scott.status)
      end

      it 'can link to the pet pages' do
        @scott.pets.each do |pet|
          visit "/applications/#{@scott.id}"
          click_on "#{pet.name}"
          expect(current_path).to eq("/pets/#{pet.id}")
        end
      end

      describe 'And that application has been submitted' do
        it 'does not show the "Add a Pet to this Application" section' do
          visit "/applications/#{@scott.id}"
          expect(page).to_not have_content("Add a Pet to this Application")
        end
      end

      describe 'And that application has not been submitted' do
        it 'shows the "Add a Pet to this Application" section' do
          visit "/applications/#{@bob.id}"
          expect(page).to have_content("Add a Pet to this Application")
        end

        it 'can search for Pets by name' do
          visit "/applications/#{@bob.id}"

          fill_in :search_name, with: 'Babe'
          click_button 'Submit'
          
          expect(current_path).to eq("/applications/#{@bob.id}")
          expect(page).to have_link('Babe')
        end
      end
    end
  end
end
