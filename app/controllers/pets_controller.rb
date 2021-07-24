class PetsController < ApplicationController
  before_action :fetch_current_pet, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search].present?
      @pets = Pet.search(params[:search])
    else
      @pets = Pet.adoptable
    end
  end

  def show
  end

  def new
    @shelter = Shelter.find(params[:shelter_id])
  end

  def create
    pet = Pet.new(pet_params)

    if pet.save
      redirect_to "/shelters/#{pet_params[:shelter_id]}/pets"
    else
      redirect_to "/shelters/#{pet_params[:shelter_id]}/pets/new"
      flash[:alert] = "Error: #{error_message(pet.errors)}"
    end
  end

  def edit
  end

  def update
    if @pet.update(pet_params)
      redirect_to "/pets/#{@pet.id}"
    else
      redirect_to "/pets/#{@pet.id}/edit"
      flash[:alert] = "Error: #{error_message(@pet.errors)}"
    end
  end

  def destroy
    @pet.destroy
    redirect_to '/pets'
  end

  private

  def pet_params
    params.permit(:id, :name, :age, :breed, :adoptable, :shelter_id)
  end

  def fetch_current_pet
    @pet = Pet.find(params[:id])
  end
end
