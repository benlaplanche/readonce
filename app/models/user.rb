class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

has_many :activities, class_name: 'Activity', foreign_key: 'sender_id'
# has_many :sent_messages, through: :activities, foreign_key: 'message_id', class_name: 'Message', source: :sender
has_many :sent_messages, -> { distinct }, through: :activities, foreign_key: 'sender_id', class_name: 'Message', source: :message

has_many :reverse_activities, class_name: 'Activity', foreign_key: 'receiver_id'
has_many :received_messages, through: :reverse_activities, foreign_key: 'receiver_id', class_name: 'Message', source: :message
end
