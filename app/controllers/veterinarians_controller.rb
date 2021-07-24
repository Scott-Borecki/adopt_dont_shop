class VeterinariansController < ApplicationController
  before_action :fetch_current_veterinarian, only: [:show,
                                                    :edit,
                                                    :update,
                                                    :destroy]

  def index
    @veterinarians = Veterinarian.on_call
  end

  def show
  end

  def new
    @vet_office = VeterinaryOffice.find_by(id: vet_params[:veterinary_office_id])
  end

  def create
    @vet_office = VeterinaryOffice.find(vet_params[:veterinary_office_id])
    veterinarian = Veterinarian.new(vet_params)

    if veterinarian.save
      redirect_to "/veterinary_offices/#{@vet_office.id}/veterinarians"
    else
      redirect_to "/veterinary_offices/#{@vet_office.id}/veterinarians/new"
      flash[:alert] = "Error: #{error_message(veterinarian.errors)}"
    end
  end

  def edit
  end

  def update
    if @veterinarian.update(vet_params)
      redirect_to "/veterinarians/#{@veterinarian.id}"
    else
      redirect_to "/veterinarians/#{@veterinarian.id}/edit"
      flash[:alert] = "Error: #{error_message(@veterinarian.errors)}"
    end
  end

  def destroy
    @veterinarian.destroy
    redirect_to '/veterinarians'
  end

  private

  def vet_params
    params.permit(
      :id,
      :name,
      :on_call,
      :review_rating,
      :veterinary_office_id
    )
  end

  def fetch_current_veterinarian
    @veterinarian = Veterinarian.find(params[:id])
  end
end
