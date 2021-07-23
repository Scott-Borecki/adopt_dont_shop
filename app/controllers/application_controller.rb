class ApplicationController < ActionController::Base
  def welcome
    @shelters = Shelter.order_by_name
  end

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
