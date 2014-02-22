class Activity < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'
	belongs_to :receiver, class_name: 'Message'
	belongs_to :sender, class_name: 'Message'
end
