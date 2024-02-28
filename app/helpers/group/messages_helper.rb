module Group::MessagesHelper
    require_relative '../shared/messages_helper'
    include Shared::MessagesHelper
    
    def replace_link_to_group_messages_partial_path
        'group/messages/load_more_messages/window/replace_link_to_messages'   
    end 

    def group_message_date_check_partial_path(new_message, previous_message)
        if defined?(previous_message) && previous_message.present?
            if previous_message.created_at.to_date != new_message.created_at.to_date
                'group/messages/message/new date'
            else
                'shared/empty_partial'
            end
        else
            'shared/empty_partial'
        end
    end

    def group_message_seen_by(message)
        seen_by_names = []
        if message.seen_by.present?
            message.seen_by.each do |user_id|
                seen_by-names << User.find(user_id).fullname
            end
        end
        seen_by_names
    end

    def message_content_partial_path(user, message, previous_message)
        if defined?(previous_message) && previous_message.present?
            if previous_message.user_id == user.id
                'group/messages/message/same_user_content'
            else
                'group/messages/message/different_user_content'
            end
        else
            'group/messages/message/different_user_content'
        end
    end

    def seen_by_user?
        @seen_by_user ? '' : 'unseen'
    end
            
end