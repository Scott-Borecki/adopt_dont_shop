require 'rails_helper'

RSpec.describe ' applications show' do
  describe 'as a visitor' do
    describe 'when I visit an applications show page' do
      it 'can see the applications attributes' do
        applicant = Application.create!(
          name: 'Scott',
          street_address: '123 Main Street',
          city: 'Denver',
          state: 'Colorado',
          zip_code: '80202',
          description: 'Great with animals!',
          status: 'pending'
        )

        visit "/applications/#{applicant.id}"

        expect(page).to have_content(applicant.name)
        expect(page).to have_content(applicant.street_address)
        expect(page).to have_content(applicant.city)
        expect(page).to have_content(applicant.state)
        expect(page).to have_content(applicant.zip_code)
        expect(page).to have_content(applicant.description)
        expect(page).to have_content(applicant.status)
        # Add tests for name of all pets with links to pets show pages
      end
    end
  end
end
