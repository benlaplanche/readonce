class MessagesController < ApplicationController
  before_action :authenticate_user!
  helper_method :mark_as_read
  respond_to :html

  def create
    # message_params[:receiver_id].each do |message|
    #   if !message.empty?
        # @message = current_user.messages.create(body: message_params[:body], receiver_id: message)
    #   end
    # end
    puts message_params.inspect
    # @message = current_user.messages.create(message_params)
    Message.create(message_params)
    respond_with message, location: messages_url
  end

  def new
  end

  def index
  end

  def show
    @message = current_user.messages.find_by(id: params[:id])
  end

  private

  def mark_as_read(message)
    message.update_attribute(:read, true)
  end

  def message_params
    params[:message].permit(:body, { user_ids: [] })
  end

  def message
    @message ||= Message.new
  end
  helper_method :message

  def messages
    @messages ||= current_user.messages.order(created_at: :desc)
    # @messages ||= Message.activities.find_by(user_id: current_user)
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
