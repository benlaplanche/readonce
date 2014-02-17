class AddPrimaryKeyToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :id, :primary_key
  end
end
