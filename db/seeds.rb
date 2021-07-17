# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Pet.destroy_all
Application.destroy_all
Shelter.destroy_all

shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
shelter_2 = Shelter.create!(name: 'Littleton shelter', city: 'Littleton, CO', foster_program: true, rank: 7)
shelter_3 = Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
shelter_4 = Shelter.create!(name: 'Centennial shelter', city: 'Cenntenial, CO', foster_program: false, rank: 4)

pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter_1.id)
pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter_1.id)
pet_3 = Pet.create!(adoptable: true, age: 8, breed: 'spanial', name: 'Bear', shelter_id: shelter_1.id)

pet_4 = Pet.create!(adoptable: true, age: 2, breed: 'hound', name: 'Dolly', shelter_id: shelter_2.id)
pet_5 = Pet.create!(adoptable: true, age: 4, breed: 'lab', name: 'Yeller', shelter_id: shelter_2.id)

pet_6 = Pet.create!(adoptable: true, age: 1, breed: 'pig', name: 'Babe', shelter_id: shelter_3.id)
pet_7 = Pet.create!(adoptable: true, age: 2, breed: 'orange tabby', name: 'Milo', shelter_id: shelter_3.id)
pet_8 = Pet.create!(adoptable: true, age: 2, breed: 'pug', name: 'Otis', shelter_id: shelter_3.id)

pet_9 = Pet.create!(adoptable: true, age: 2, breed: 'st. bernard', name: 'Beethoven', shelter_id: shelter_4.id)
pet_10 = Pet.create!(adoptable: true, age: 7, breed: 'bulldog', name: 'Chance', shelter_id: shelter_4.id)
pet_11 = Pet.create!(adoptable: true, age: 6, breed: 'golden retriever', name: 'Shadow', shelter_id: shelter_4.id)
pet_12 = Pet.create!(adoptable: true, age: 8, breed: 'himalayan cat', name: 'Sassy', shelter_id: shelter_4.id)

scott = Application.create!( name: 'Scott', street_address: '123 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'Pending')

scott.pets << pet_1
scott.pets << pet_2
scott.pets << pet_4

bob = Application.create!( name: 'Bob', street_address: '456 Main Street', city: 'Denver', state: 'Colorado', zip_code: '80202', description: 'Great with animals!', status: 'In Progress')

bob.pets << pet_3
bob.pets << pet_6
bob.pets << pet_7

sierra = Application.create!( name: 'Sierra', street_address: '789 Main Street', city: 'Arvada', state: 'Colorado', zip_code: '80003', description: 'Great with animals!', status: 'Pending')

sierra.pets << pet_5
sierra.pets << pet_8
sierra.pets << pet_9

laura = Application.create!( name: 'Laura', street_address: '1550 Main Street', city: 'Aurora', state: 'Colorado', zip_code: '80010', description: 'Great with animals!', status: 'Pending')

laura.pets << pet_10
laura.pets << pet_11
laura.pets << pet_12
