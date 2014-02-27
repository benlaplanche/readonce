class ActivityAggregator
# based upon http://blog.givegab.com/post/75043413459/using-enumerations-to-make-a-faster-activity-feed-in
# TODO pass in the received_messages stream senders, so we can eager load with find_each, instead of individual queries below
# TODO add a unique check on messages (e.g. sender & receiver are not the same person)
# TODO return the receiver id's & message read status nested so can be hyperlinked and coloured
  def initialize(current_user, streams)
    @streams = streams.flatten
    @userid = current_user
  end

  def next_activities(limit)
    activities = []
    while (activities.size < limit) && more_activities? do
      activities << next_activity
    end
    activities
  end

private
  def next_activity
    msg = select_next_activity
    response = Struct.new(:id, :sender, :receivers, :created_at, :read, :body, :sender_id)
    output = response.new(msg.id,
                  msg.sender.email,
                  msg.receivers.map(&:email).join(', '),
                  msg.created_at,
                  msg.read,
                  msg.body,
                  msg.sender.id)
    return output
  end

  def select_next_activity
    # subtle bug with the sorting, due to the create action the microseconds on the inserts for multiple
    # receivers means they are sorted incorrectly, removing duplicate message ids should safely ignore this
    @streams.select{ |s| has_next?(s) }.
      sort_by{ |s| s.peek.created_at }.
      last.next
  end

  def more_activities?
    @streams.any?{ |s| has_next?(s) }
  end

  def has_next?(stream)
    stream.peek
    true
  rescue
    false
  end
end