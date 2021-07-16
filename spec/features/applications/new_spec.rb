require 'rails_helper'

RSpec.describe 'applications new' do
  describe 'as a visitor' do
    describe 'when I visit the pet index page' do
      it 'can see a link to start an application' do
        visit "/pets"

        expect(page).to have_link('Start an Application')

        click_link('Start an Application')

        expect(current_path).to eq('/applications/new')
      end
    end

    describe 'I am taken to the new application page' do
      it 'can fill in the new application form' do
        name           = 'Scott'
        street_address = '123 Main Street'
        city           = 'Denver'
        state          = 'Colorado'
        zip_code       = '80202'
        description    = 'Good with animals'

        visit '/applications/new'

        fill_in :name, with: name
        fill_in :street_address, with: street_address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip_code, with: zip_code
        fill_in :description, with: description
        click_button 'Submit'

        expect(current_path).to eq("/applications/#{Application.last.id}")
        expect(page).to have_content(name)
        expect(page).to have_content(street_address)
        expect(page).to have_content(city)
        expect(page).to have_content(state)
        expect(page).to have_content(zip_code)
        expect(page).to have_content(description)
        expect(page).to have_content("In Progress")
      end
    end

  end
end
