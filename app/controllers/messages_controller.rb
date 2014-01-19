class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @message = current_user.messages.new(message_params)
    if message.valid?
      message.save
      redirect_to messages_url
    else
      render 'new'
    end
  end
  
  def new
  end
  
  def index
  end
  
  private
  def message_params
    params[:message].permit :body
  end
  
  def message
    @message ||= Message.new
  end
  helper_method :message
  
  def messages
    @messages ||= current_user.messages
  end
  helper_method :messages
  
end
