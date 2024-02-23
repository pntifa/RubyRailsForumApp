module Shared::ConversationsHelper

    def private_conv_seen_status(conversation) 
      # if the latest message of a conversation is not created by a current_user
      # and it is unseen, return an unseen-conv value
      not_created_by_user = conversation.messages.last.user_id != current_user.id
      unseen = conversation.messages.last.seen == false
      not_created_by_user && unseen ? 'unseen-conv' : ''
    end

    def contacts_except_recipient(recipient)
        contacts = current_user.all_active_contacts
        # return all contacts, except the opposite user of the chat
        contacts.delete_if {|contact| contact.id == recipient.id }
    end
end