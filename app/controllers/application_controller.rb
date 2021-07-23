class ApplicationController < ActionController::Base
  def welcome
    @shelters_with_pending_applications = Shelter.with_pending_applications
                                                 .order_by_name
  end

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
