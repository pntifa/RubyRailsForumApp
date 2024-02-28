class Private::ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "private_conversations_#{current_user.id}"
  end
  
  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el['fullname']] = el['value']
    end
    Private::Message.create(message_params)
  end

  def set_as_seen(data)
    conversation = Private::Conversation.find(data["conv_id"].to_i)
    message = conversation.messages.where(seen: false)
    messages.each do |message|
      message.update(seen: true)
    end
  end
end
