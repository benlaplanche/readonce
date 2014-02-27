class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

has_many :activities, class_name: 'Activity', foreign_key: 'sender_id'
has_many :sent_messages, -> { distinct }, through: :activities, foreign_key: 'sender_id', class_name: 'Message', source: :message

has_many :reverse_activities, class_name: 'Activity', foreign_key: 'receiver_id'
has_many :received_messages, through: :reverse_activities, foreign_key: 'receiver_id', class_name: 'Message', source: :message
# has_many :received_messages, ->(current_user) { where Activity.sender_id: current_user.id }, through: :reverse_activities, foreign_key: 'receiver_id', class_name: 'Message', source: :message
# scope :foreign, -> { joins(:reverse_activities).where('reverse.activities.sender_id != ?', current_user.id )}

def recent_activities(limit)
	sent_stream = User.first.sent_messages.order(:created_at).to_enum :find_each
	received_stream = User.first.received_messages.order(:created_at).to_enum :find_each
	ActivityAggregator.new([sent_stream, received_stream]).next_activities(limit)
end

end
