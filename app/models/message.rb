class Message < ActiveRecord::Base
  # has_and_belongs_to_many :users
  # # belongs_to :sender, class_name: 'User'
  # # belongs_to :receiver, class_name: 'User'
has_many :activities
has_many :users, through: :activities
validates :body, presence: true
# validates :receiver_id, presence: true

end
