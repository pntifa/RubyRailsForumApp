class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end

  def contact_request_response(data)
    receiver_user_fullname = data['receiver_user_fullname']
    sender_user_fullname = data['sender_user_fullname']
    notification = data['notification']
    receiver = User.find_by(fullname: receiver_user_fullname)

    ActionCable.server.broadcast(
      "notifications_#{receiver.id}",
      notification: notification,
      sender_user_name: sender_user_fullname,
    )

  end
end