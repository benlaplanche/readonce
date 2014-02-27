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
    # build our feed, showing sent & received messages
    # where the user has sent & received the message, only show against them as a sender
    # Improvement 1: Use eager loading on the objects when getting the receivers & sender?
    # Improvement 2: any way of stripping out the received messages from the sender earlier?
    # Improvement 3: reduce the amount of "response_hash" lines to make it tidier
      sent_messages = current_user.sent_messages
      received_messages = current_user.received_messages

      puts sent_messages.to_yaml
      puts received_messages.to_yaml

      response_hash = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc)}

      sent_messages.each_with_index do |n,i|
        k = "message" + i.to_s
        response_hash[k]["message_id"] = n.id
        response_hash[k]["sender"] = n.sender.email
        response_hash[k]["receivers"] = n.receivers.map(&:email).join(', ')
        response_hash[k]["body"] = n.body
        response_hash[k]["sent"] = n.created_at
        response_hash[k]["status"] = n.read
      end

      received_messages.each_with_index do |n, i|
        if n.sender != current_user
          k = "message" + (i +10).to_s
          response_hash[k]["message_id"] = n.id
          response_hash[k]["sender"] = n.sender.email
          response_hash[k]["receivers"] = n.receivers.map(&:email).join(', ')
          response_hash[k]["body"] = n.body
          response_hash[k]["sent"] = n.created_at
          response_hash[k]["status"] = n.read
        end
      end

      puts response_hash.to_yaml
      return response_hash
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
