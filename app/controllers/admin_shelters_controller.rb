class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_reverse
    @shelters_with_pending_applications = Shelter.with_pending_applications
  end

  def show
    @shelter = Shelter.find(params[:id])
  end
end
