class MessagesController < ApplicationController
  before_action :authenticate_user!
  helper_method :mark_as_read
  respond_to :html

  def create
    @message = current_user.messages.create(message_params)
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
    params[:message].permit :body, :receiver_id
  end

  def message
    @message ||= Message.new
  end
  helper_method :message

  def messages
    @messages ||= current_user.messages.order(created_at: :desc)
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
