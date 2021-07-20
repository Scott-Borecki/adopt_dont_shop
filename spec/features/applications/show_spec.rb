require 'rails_helper'

RSpec.describe 'applications show' do
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
        @scott.pets << @pet_1
        @scott.pets << @pet_2

        @scott.pets.each do |pet|
          visit "/applications/#{@scott.id}"
          click_on "#{pet.name}"
          expect(current_path).to eq("/pets/#{pet.id}")
        end
      end

      describe 'And I have not added any pets to the application' do
        it 'does not show the section to submit my application' do
          visit "/applications/#{@scott.id}"
          expect(page).to_not have_button('Submit Application')
        end
      end

      describe 'And that application has been submitted' do
        it 'does not show the "Add a Pet to this Application" section' do
          visit "/applications/#{@scott.id}"
          expect(page).to_not have_content('Add a Pet to this Application')
        end
      end

      describe 'And that application has not been submitted' do
        it 'shows the "Add a Pet to this Application" section' do
          visit "/applications/#{@bob.id}"
          expect(page).to have_content('Add a Pet to this Application')
        end

        it 'can search for Pets by name' do
          visit "/applications/#{@bob.id}"

          fill_in :search_name, with: 'Babe'
          click_button 'Submit'

          expect(current_path).to eq("/applications/#{@bob.id}")
          expect(page).to have_link('Babe')
        end

        it 'can search for Pets by name (partial matches)' do
          visit "/applications/#{@bob.id}"

          fill_in :search_name, with: 'Bab'
          click_button 'Submit'

          expect(current_path).to eq("/applications/#{@bob.id}")
          expect(page).to have_link('Babe')
        end

        it 'can search for Pets by name (case insenstive matches)' do
          visit "/applications/#{@bob.id}"

          fill_in :search_name, with: 'babe'
          click_button 'Submit'

          expect(current_path).to eq("/applications/#{@bob.id}")
          expect(page).to have_link('Babe')
        end

        it 'can add Pet to adopt list on Application show page' do
          visit "/applications/#{@bob.id}"

          fill_in :search_name, with: 'Babe'
          click_button 'Submit'

          within("#pet-#{@pet_6.id}") do
            click_button 'Adopt this Pet'
          end

          expect(current_path).to eq("/applications/#{@bob.id}")
          expect(@bob.pets).to eq([@pet_6])
          within('#application') do
            expect(page).to have_content('Babe')
          end
        end

        describe 'And I have added one or more pets to the application' do
          before :each do
            @bob.pets << @pet_3
            @bob.pets << @pet_6
          end

          it 'displays a section to submit my appliction' do
            visit "/applications/#{@bob.id}"

            within('#submit-application') do
              expect(page).to have_field(:description)
            end
            expect(@bob.status).to eq('In Progress')
          end

          it 'I can submit the application' do
            visit "/applications/#{@bob.id}"

            fill_in :description, with: 'Great with animals!!'
            click_button 'Submit Application'

            expect(current_path).to eq("/applications/#{@bob.id}")
            expect(page).to have_content('Application Status: Pending')
            expect(page).to have_content('Description: Great with animals!!')
            expect(page).to have_content(@pet_3.name)
            expect(page).to have_content(@pet_6.name)

            expect(page).to_not have_content('Add a Pet to this Application')
            expect(page).to_not have_content('Describe why you would make a good owner for these pet(s):')
          end

          describe 'And I fail to fill in the description form field' do
            it 'takes me back to the application show page with an error message' do
              visit "/applications/#{@bob.id}"

              click_button 'Submit Application'

              expect(current_path).to eq("/applications/#{@bob.id}")
              expect(page).to have_content("Error: Description can't be blank")
            end
          end
        end
      end
    end
  end
end
