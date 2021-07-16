class ChangeAdoptionApplicationsToApplications < ActiveRecord::Migration[5.2]
  def change
    rename_table :adoption_applications, :applications
  end
end
