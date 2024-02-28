module Shared::ConversationsHelper

  def private_conv_seen_status(conversation) 
    not_created_by_user = conversation.messages.last.user_id != current_user.id
    unseen = conversation.messages.last.seen == false
    not_created_by_user && unseen ? 'unseen-conv' : ''
  end

  def group_conv_seen_status(conversation) 
    if current_user == nil
      ''
    else
      not_created_by_user = conversation.messages.last.user_id != current_user.id
      unseen = conversation.messages.last.seen == false
      not_created_by_user && unseen ? 'unseen-conv' : ''
    end
  end

end