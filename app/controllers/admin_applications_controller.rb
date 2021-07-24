class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @application.process
  end
end
