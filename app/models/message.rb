class Message < ActiveRecord::Base
	has_one :sent_activities, class_name: 'Activity', foreign_key: 'message_id'
	has_one :sender, through: :sent_activities, foreign_key: 'sender_id', class_name: 'User'

	has_many :receiver_activities, class_name: 'Activity', foreign_key: 'message_id'
	has_many :receivers, through: :receiver_activities, foreign_key: 'receiver_id', class_name: 'User'

	validates :body, presence: true
end
