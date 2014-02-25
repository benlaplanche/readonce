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
      # messages = Activity.where(sender_id: current_user)
      # received_messages = Activity.where(receiver_id: current_user)
      sent_messages = current_user.sent_messages
      # received_messages = current_user.received_messages

      puts sent_messages.to_yaml
      response_hash = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc)}

      sent_messages.each do |n|
        # @list_items << { message_id: n.id, {
        #                 sender: n.sender.email,
        #                 receivers: n.receivers.map(&:email).join(', '),
        #                 body: n.body,
        #                 sent: n.created_at,
        #                 status: n.read }}
        k = "message" + n.to_s
        response_hash[k]["message_id"] = n.id
        response_hash[k]["sender"] = n.sender.email
        response_hash[k]["receivers"] = n.receivers.map(&:email).join(', ')
        response_hash[k]["body"] = n.body
        response_hash[k]["sent"] = n.created_at
        response_hash[k]["status"] = n.read
      end

      # received_messages.each do |n|
      #   if n.sender != current_user
      #     # list_items << n
      #     # list_items[n.to_s.delete("@")] = n.instance_variable.get(n)
      #   end
      # end

      puts response_hash.to_yaml

      # activity_list.each do |n|
      #   n = { email: n.}
      # end
      # puts messages.to_yaml
      # return messages
  end
  helper_method :messages

  def receivers
    @receivers ||= User.all
  end
  helper_method :receivers

end
