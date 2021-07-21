require 'rails_helper'

RSpec.describe 'the admin shelter index' do
  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter',
                                 city: 'Aurora, CO',
                                 foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'Littleton shelter',
                                 city: 'Littleton, CO',
                                 foster_program: true, rank: 7)
    @shelter_3 = Shelter.create!(name: 'Denver shelter',
                                 city: 'Denver, CO',
                                 foster_program: true, rank: 10)
    @shelter_4 = Shelter.create!(name: 'Centennial shelter',
                                 city: 'Cenntenial, CO',
                                 foster_program: false, rank: 4)

    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx',
                         name: 'Lucille Bald', shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman',
                         name: 'Lobster', shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial',
                         name: 'Bear', shelter_id: @shelter_1.id)

    @pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'hound',
                         name: 'Dolly', shelter_id: @shelter_2.id)
    @pet_5 = Pet.create!(adoptable: true, age: 4, breed: 'lab',
                         name: 'Yeller', shelter_id: @shelter_2.id)

    @pet_6 = Pet.create!(adoptable: true, age: 1, breed: 'pig',
                         name: 'Babe', shelter_id: @shelter_3.id)
    @pet_7 = Pet.create!(adoptable: true, age: 2, breed: 'orange tabby',
                         name: 'Milo', shelter_id: @shelter_3.id)

    @scott = Application.create!(name: 'Scott',
                                 street_address: '123 Main Street',
                                 city: 'Denver', state: 'Colorado',
                                 zip_code: '80202',
                                 description: 'Great with animals!',
                                 status: 'Pending')
    @bob = Application.create!(name: 'Bob',
                               street_address: '456 Main Street',
                               city: 'Denver', state: 'Colorado',
                               zip_code: '80202', status: 'In Progress')

    @scott.pets << @pet_1
    @scott.pets << @pet_2
    @scott.pets << @pet_4
    @bob.pets << @pet_3
    @bob.pets << @pet_6
    @bob.pets << @pet_7
  end

  describe 'As a visitor, when I visit the admin shelter index' do
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

    it 'links to each admin shelters show page' do
      shelters = [@shelter_1, @shelter_2, @shelter_3, @shelter_4]
      shelters.each do |shelter|
        visit '/admin/shelters'
        within '#shelters' do
          expect(page).to have_link(shelter.name)

          click_link shelter.name
          expect(current_path).to eq("/admin/shelters/#{shelter.id}")
        end
      end

      shelters_with_pending_applications = [@shelter_1, @shelter_2]
      shelters_with_pending_applications.each do |shelter|
        visit '/admin/shelters'
        within '#pending-applications' do
          expect(page).to have_link(shelter.name)

          click_link shelter.name
          expect(current_path).to eq("/admin/shelters/#{shelter.id}")
        end
      end
    end

    it "displays a section for 'Shelter's with Pending Applications' with "\
       "shelter names" do
      visit '/admin/shelters'

      within '#pending-applications' do
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_2.name)
        expect(page).to_not have_content(@shelter_3.name)
        expect(page).to_not have_content(@shelter_4.name)
      end
    end

    it "displays shelter names alphabetically in 'Shelter's with Pending "\
       "Applications'" do
      @bob.update(description: 'Great with animals!', status: 'Pending')

      visit '/admin/shelters'

      within '#pending-applications' do
        expect(@shelter_1.name).to appear_before(@shelter_3.name)
        expect(@shelter_3.name).to appear_before(@shelter_2.name)
      end
    end
  end
end
