class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_reverse
    @shelters_with_pending_applications = Shelter.with_pending_applications
  end

  def show
    @shelter = Shelter.find_by_sql("SELECT * FROM shelters WHERE id=#{params[:id]}")
    @shelter_name = Shelter.find_by_sql("SELECT name FROM shelters WHERE id=#{params[:id]}")
    @shelter_city = Shelter.find_by_sql("SELECT city FROM shelters WHERE id=#{params[:id]}")
  end
end
