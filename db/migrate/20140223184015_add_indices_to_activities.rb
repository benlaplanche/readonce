class AddIndicesToActivities < ActiveRecord::Migration
  def change
  	add_index :activities, :message_id
  	add_index :activities, :sender_id
  	add_index :activities, :receiver_id
  	add_index :messages, :id
  end
end
