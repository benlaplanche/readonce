class ActivitiesUserSenderId < ActiveRecord::Migration
  def change
  	add_column :activities, :receiver_id, :integer
  	rename_column :activities, :user_id, :sender_id
  end
end
