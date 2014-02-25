class Activity < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'
	belongs_to :message

	validates :sender_id, presence: true
	validates :receiver_id, presence: true
	validates :message_id, presence: true
end
