require 'rails_helper'

RSpec.describe 'the admin shelter show' do
  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'Littleton shelter', city: 'Littleton, CO', foster_program: true, rank: 7)
    @shelter_3 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Cenntenial, CO', foster_program: false, rank: 4)
  end

  describe 'As a visitor, when I visit an admin shelter show page' do
    it 'displays the shelters name and full address' do
      shelters = [@shelter_1, @shelter_2, @shelter_3, @shelter_4]
      shelters.each do |shelter|
        visit "/admin/shelters/#{shelter.id}"
        expect(page).to have_content(shelter.name)
        expect(page).to have_content(shelter.city)
      end
    end
  end
end
