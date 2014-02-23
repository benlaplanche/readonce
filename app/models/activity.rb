class Activity < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'
# belongs_to :user
belongs_to :message
	# belongs_to :receiver, class_name: 'Message'
	# belongs_to :sender, class_name: 'Message'

	validates :sender_id, presence: true
	validates :receiver_id, presence: true
	validates :message_id, presence: true
end
