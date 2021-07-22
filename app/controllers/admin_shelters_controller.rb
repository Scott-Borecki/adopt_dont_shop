class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name_reverse
    @shelters_with_pending_applications = Shelter.with_pending_applications.order_by_name
  end

  def show
    # NOTE: Part of User Story was to write the query with raw SQL
    @shelter = Shelter.sql_find_by_id(params[:id])
  end
end
