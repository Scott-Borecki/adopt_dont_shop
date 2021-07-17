require 'rails_helper'

RSpec.describe 'the admin shelter index' do
  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'Littleton shelter', city: 'Littleton, CO', foster_program: true, rank: 7)
    @shelter_3 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Cenntenial, CO', foster_program: false, rank: 4)
  end

  it 'lists all the shelters in reverse alphabetical order by name' do
    visit '/admin/shelters'

    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_2.name)
    expect(page).to have_content(@shelter_3.name)
    expect(page).to have_content(@shelter_4.name)
    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_4.name)
    expect(@shelter_4.name).to appear_before(@shelter_1.name)
  end
end
