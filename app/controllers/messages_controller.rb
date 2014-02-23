class MessagesController < ApplicationController
  before_action :authenticate_user!
  helper_method :mark_as_read
  respond_to :html

  def create
    puts message_params.inspect
    # message_params[:id].map! { |i| i.to_i }
    # puts message_params.inspect

        @message = Message.create(message_params)
    message_params[:id].each do |receiver|
      if !receiver.empty?
        # @message = current_user.messages.create(body: message_params[:body], receiver_id: message)
        # @message = Message.create(body: message_params[:body], receivers: receiver)
        # @message = current_user.sent_messages.create(message_params)
        # @message = current_user.sent_messages.create(body: message_params[:body])

        @activity = Activity.create(sender_id: current_user.id, receiver_id: receiver, message_id: @message.id)
      end
    end
# @message = Message.create(message_params)
# @message = current_user.activities.create(message_params)
# @message = current_user.sent_messages.create(message_params)

    # @message = current_user.messages.create(message_params)
    # Message.create(message_params)
    respond_with message, location: messages_url
  end

  def new
  end

  def index
  end

  def show
    # @message = current_user.messages.find_by(id: params[:id])
    @message = current_user.received_messages.find_by(id: params[:id])
  end

  private

  def mark_as_read(message)
    message.update_attribute(:read, true)
  end

  def message_params
    params[:message].permit(:body, { id: [] } )
  end

  def message
    @message ||= Message.new
  end
  helper_method :message

  def messages
    # @messages ||= current_user.messages.order(created_at: :desc)
    # @messages ||= Message.activities.find_by(user_id: current_user)
    # @messages ||= current_user.sent_messages(created_at: :asc)
    sent_messages = Activity.where(sender_id: current_user)
    received_messages = Activity.where(received_id: current_user)

    
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
