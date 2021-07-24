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

# SHELTERS
shelter_1 = Shelter.create!(name: 'Aurora Shelter',
                            city: 'Aurora, CO',
                            foster_program: false,
                            rank: 9)
shelter_2 = Shelter.create!(name: 'Littleton Shelter',
                            city: 'Littleton, CO',
                            foster_program: true,
                            rank: 7)
shelter_3 = Shelter.create!(name: 'Denver Shelter',
                            city: 'Denver, CO',
                            foster_program: true,
                            rank: 10)
shelter_4 = Shelter.create!(name: 'Centennial Shelter',
                            city: 'Cenntenial, CO',
                            foster_program: false,
                            rank: 4)
shelter_5 = Shelter.create!(name: 'Englewood Shelter',
                            city: 'Englewood, CO',
                            foster_program: true,
                            rank: 2)

# PETS - SHELTER 1
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Sphynx',
            name: 'Lucille Bald',
            shelter_id: shelter_1.id)
Pet.create!(adoptable: true,
            age: 3,
            breed: 'Doberman',
            name: 'Lobster',
            shelter_id: shelter_1.id)
Pet.create!(adoptable: true,
            age: 8,
            breed: 'Spanial',
            name: 'Bear',
            shelter_id: shelter_1.id)
Pet.create!(adoptable: true,
            age: 2,
            breed: 'French Bulldog',
            name: 'Frenchie',
            shelter_id: shelter_1.id)
Pet.create!(adoptable: true,
            age: 4,
            breed: 'German Shepherd',
            name: 'Rick',
            shelter_id: shelter_1.id)
Pet.create!(adoptable: true,
            age: 2,
            breed: 'Spanial',
            name: 'Lucy',
            shelter_id: shelter_1.id)

# PETS - SHELTER 2
Pet.create!(adoptable: true,
            age: 2,
            breed: 'Lab',
            name: 'Yeller',
            shelter_id: shelter_2.id)
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Lab',
            name: 'Missy',
            shelter_id: shelter_2.id)
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Lab',
            name: 'Greece',
            shelter_id: shelter_2.id)
Pet.create!(adoptable: true,
            age: 3,
            breed: 'Lab',
            name: 'Polly',
            shelter_id: shelter_2.id)
Pet.create!(adoptable: true,
            age: 4,
            breed: 'Lab',
            name: 'Fella',
            shelter_id: shelter_2.id)
Pet.create!(adoptable: true,
            age: 4,
            breed: 'Lab',
            name: 'Sam',
            shelter_id: shelter_2.id)

# PETS - SHELTER 3
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Pig',
            name: 'Babe',
            shelter_id: shelter_3.id)
Pet.create!(adoptable: true,
            age: 2,
            breed: 'Pig',
            name: 'Milo',
            shelter_id: shelter_3.id)
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Pig',
            name: 'Bacon',
            shelter_id: shelter_3.id)
Pet.create!(adoptable: true,
            age: 5,
            breed: 'Pig',
            name: 'Ham',
            shelter_id: shelter_3.id)
Pet.create!(adoptable: true,
            age: 2,
            breed: 'Pig',
            name: 'Cheeky',
            shelter_id: shelter_3.id)
Pet.create!(adoptable: true,
            age: 3,
            breed: 'Pig',
            name: 'Oinker',
            shelter_id: shelter_3.id)

# PETS - SHELTER 4
Pet.create!(adoptable: true,
            age: 2,
            breed: 'St. Bernard',
            name: 'Beethoven',
            shelter_id: shelter_4.id)
Pet.create!(adoptable: true,
            age: 7,
            breed: 'Bulldog',
            name: 'Chance',
            shelter_id: shelter_4.id)
Pet.create!(adoptable: true,
            age: 6,
            breed: 'Golden Retriever',
            name: 'Shadow',
            shelter_id: shelter_4.id)
bob = Pet.create!(adoptable: true,
                  age: 12,
                  breed: 'Tabby',
                  name: 'Bob',
                  shelter_id: shelter_4.id)
linda = Pet.create!(adoptable: true,
                    age: 6,
                    breed: 'Tabby',
                    name: 'Linda',
                    shelter_id: shelter_4.id)
sophie = Pet.create!(adoptable: true,
                     age: 2,
                     breed: 'Tabby',
                     name: 'Sophie',
                     shelter_id: shelter_4.id)

# PETS - SHELTER 5
Pet.create!(adoptable: true,
            age: 2,
            breed: 'Capuchin Monkey',
            name: 'Crystal',
            shelter_id: shelter_5.id)
Pet.create!(adoptable: true,
            age: 4,
            breed: 'Capuchin Monkey',
            name: 'Bill',
            shelter_id: shelter_5.id)
Pet.create!(adoptable: true,
            age: 8,
            breed: 'Capuchin Monkey',
            name: 'Rahul',
            shelter_id: shelter_5.id)
Pet.create!(adoptable: true,
            age: 3,
            breed: 'Capuchin Monkey',
            name: 'Rafiki',
            shelter_id: shelter_5.id)
Pet.create!(adoptable: true,
            age: 6,
            breed: 'Capuchin Monkey',
            name: 'Spot',
            shelter_id: shelter_5.id)
Pet.create!(adoptable: true,
            age: 1,
            breed: 'Capuchin Monkey',
            name: 'Blue',
            shelter_id: shelter_5.id)

# APPLICATIONS
Application.create!(name: 'Scott',
                    street_address: '123 Main Street',
                    city: 'Denver',
                    state: 'Colorado',
                    zip_code: '80202')
Application.create!(name: 'Bob',
                    street_address: '234 Main Street',
                    city: 'Denver',
                    state: 'Colorado',
                    zip_code: '80202')
Application.create!(name: 'Sierra',
                    street_address: '345 Main Street',
                    city: 'Arvada',
                    state: 'Colorado',
                    zip_code: '80003')
Application.create!(name: 'Laura',
                    street_address: '456 Main Street',
                    city: 'Aurora',
                    state: 'Colorado',
                    zip_code: '80010')
john = Application.create!(name: 'John',
                           street_address: '567 Main Street',
                           city: 'Aurora',
                           state: 'Colorado',
                           zip_code: '80010',
                           description: 'I like cats',
                           status: 'Pending')

# ADD PETS TO APPLICATIONS
john.pets << bob << sophie << linda
