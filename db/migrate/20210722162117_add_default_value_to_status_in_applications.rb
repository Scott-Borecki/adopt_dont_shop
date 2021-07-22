class AddDefaultValueToStatusInApplications < ActiveRecord::Migration[5.2]
  def change
    change_column_default :applications, :status, from: nil, to: 'In Progress'
  end
end
