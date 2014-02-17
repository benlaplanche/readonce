class AddHasManyThroughMessages < ActiveRecord::Migration
  def change
  	create_table 'activities', id: false do |t|
  		t.column :user_id, :integer
  		t.column :message_id, :integer
  	end
  end
end
