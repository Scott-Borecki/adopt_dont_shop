require 'rails_helper'

RSpec.describe 'applications/new.html.erb' do
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
        contents = {
          name:           'Scott',
          street_address: '123 Main Street',
          city:           'Denver',
          state:          'Colorado',
          zip_code:       '80202',
          status:         'In Progress'
        }

        visit '/applications/new'

        fill_in :name,           with: contents[:name]
        fill_in :street_address, with: contents[:street_address]
        fill_in :city,           with: contents[:city]
        fill_in :state,          with: contents[:state]
        fill_in :zip_code,       with: contents[:zip_code]
        click_button 'Submit'

        expect(current_path).to eq("/applications/#{Application.last.id}")

        contents.values.each do |content|
          expect(page).to have_content(content)
        end
      end

      describe 'And I fail to fill in any of the form fields' do
        it 'takes me back to the new applications page with an error message' do
          visit "/applications/new"

          click_button 'Submit'

          expect(page).to have_current_path("/applications/new")
          expect(page).to have_content("Error: Name can't be blank, Street "\
            "address can't be blank, City can't be blank, State can't be "\
            "blank, Zip code can't be blank, Zip code is not a number, Zip "\
            "code is the wrong length (should be 5 characters)")
        end
      end
    end
  end
end
