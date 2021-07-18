require 'rails_helper'

RSpec.describe 'the admin shelter show' do
  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'Littleton shelter', city: 'Littleton, CO', foster_program: true, rank: 7)
    @shelter_3 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Cenntenial, CO', foster_program: false, rank: 4)

    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: @shelter_1.id)

    @pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'hound', name: 'Dolly', shelter_id: @shelter_2.id)
    @pet_5 = Pet.create!(adoptable: true, age: 4, breed: 'lab', name: 'Yeller', shelter_id: @shelter_2.id)

    @pet_6 = Pet.create!(adoptable: true, age: 1, breed: 'pig', name: 'Babe', shelter_id: @shelter_3.id)
    @pet_7 = Pet.create!(adoptable: true, age: 2, breed: 'orange tabby', name: 'Milo', shelter_id: @shelter_3.id)
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

    describe 'Then I see a section for statistics' do
      it 'has a section for statistics' do
        shelters = [@shelter_1, @shelter_2, @shelter_3, @shelter_4]
        shelters.each do |shelter|
          visit "/admin/shelters/#{shelter.id}"
          expect(page).to have_content("Statistics")
        end
      end

      it 'displays the average age of the adoptable pets' do
        shelters = [@shelter_1, @shelter_2, @shelter_3, @shelter_4]
        shelters.each do |shelter|
          visit "/admin/shelters/#{shelter.id}"

          within '#statistics' do
            expect(page).to have_content("Average Age of Adoptable Pets: #{shelter.average_age_of_adoptable_pets}")
          end
        end
      end
    end
  end
end
