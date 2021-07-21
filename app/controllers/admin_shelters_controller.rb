class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_reverse
    @shelters_with_pending_applications = Shelter.with_pending_applications.order_by_name
  end

  def show
    # NOTE: Part of User Story was to write these queries with raw SQL
    @shelter = Shelter.find_by_sql("SELECT * FROM shelters WHERE (id=#{params[:id]}) LIMIT 1").first
    @shelter_name = Shelter.find_by_sql("SELECT name FROM shelters WHERE id=#{params[:id]}").pluck(:name).first
    @shelter_city = Shelter.find_by_sql("SELECT city FROM shelters WHERE id=#{params[:id]}").pluck(:city).first
  end
end
