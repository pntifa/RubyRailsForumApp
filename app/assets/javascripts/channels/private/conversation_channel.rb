def set_as_seen(data)
    # find a conversation and set its all unseen messages as seen
    conversation = Private::Conversation.find(data["conv_id"].to_i)
    messages = conversation.messages.where(seen: false)
    messages.each do |message|
      message.update(seen: true)
    end
  end