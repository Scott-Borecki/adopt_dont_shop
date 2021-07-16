class ApplicationsController < ApplicationController
  def new
  end

  def show
    @applicant = Application.find(params[:id])
  end
end
