require 'rails_helper'

RSpec.describe 'application' do
  it 'can link to the index pages' do
    pages = [['Home', '/'],
             ['Pets', '/pets'],
             ['Shelters', '/shelters'],
             ['Veterinary Offices', '/veterinary_offices'],
             ['Veterinarians', '/veterinarians']]
    pages.each do |link_text, path|
      visit '/'
      click_link "#{link_text}"
      expect(current_path).to eq("#{path}")
    end
  end
end
