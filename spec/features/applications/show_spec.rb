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

        @scott = Application.create!(name: 'Scott',
                                     street_address: '123 Main Street',
                                     city: 'Denver',
                                     state: 'Colorado',
                                     zip_code: '80202',
                                     description: 'Great with animals!',
                                     status: 'pending')
        @scott.pets << @pet_1
        @scott.pets << @pet_2
      end

      it 'can show the applications attributes' do
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
    end
  end
end
