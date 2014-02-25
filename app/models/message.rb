class Message < ActiveRecord::Base
	has_one :sent_activities, class_name: 'Activity', foreign_key: 'message_id'
	has_one :sender, through: :sent_activities, class_name: 'User', foreign_key: 'message_id'

	has_many :receiver_activities, class_name: 'Activity', foreign_key: 'message_id'
	has_many :receivers, through: :receiver_activities, foreign_key: 'message_id', class_name: 'User', source: :receiver

	validates :body, presence: true

	private

	def feed
		# build our feed, showing sent & received messages
	  	# where the user has sent & received the message, only show against them as a sender
	    # messages = Activity.where(sender_id: current_user)
	    # received_messages = Activity.where(receiver_id: current_user)
	    sent_messages = current_user.sent_messages
	    # received_messages = current_user.received_messages

	    puts sent_messages.to_yaml

	    sent_messages.each do |n|
	      @list_items = { message_id: n.id,
	                      sender: n.sender.email,
	                      receivers: n.receivers.map(&:email).join(', '),
	                      body: n.body,
	                      sent: n.created_at,
	                      status: n.read }
	    end

	    # received_messages.each do |n|
	    #   if n.sender != current_user
	    #     # list_items << n
	    #     # list_items[n.to_s.delete("@")] = n.instance_variable.get(n)
	    #   end
	    # end

	    puts @list_items

	    # activity_list.each do |n|
	    #   n = { email: n.}
	    # end
	    # puts messages.to_yaml
	    # return messages
	end
end
