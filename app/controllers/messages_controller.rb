class MessagesController < ApplicationController
  before_action :authenticate_user!
  helper_method :mark_as_read
  respond_to :html

  def create
    @message = Message.create(message_params)
    message_params[:id].each do |receiver|
      if !receiver.empty?
        @activity = Activity.create(sender_id: current_user.id, receiver_id: receiver, message_id: @message.id)
      end
    end

    respond_with message, location: messages_url
  end

  def new
  end

  def index
  end

  def show
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
  # TODO pass in the limit value & use will_paginate gem
    sent_stream = current_user.sent_messages.order(created_at: :asc).to_enum :find_each
    received_stream = current_user.received_messages.order(created_at: :asc).to_enum :find_each

    ActivityAggregator.new(current_user.id, [sent_stream, received_stream]).next_activities(1000)
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
