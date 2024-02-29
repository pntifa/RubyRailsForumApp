for (i = 0; i < gon.group_conversations.length; i++) {
    subToGroupConversationChannel(gon.group_conversations[i]);
}

function subToGroupConversationChannel(id) {
    App['group_conversation_' + id]  = App.cable.subscriptions.create(
        {
            channel: 'Group::ConversationChannel',
            id: id
        },
        {
            connected: function() {},
            disconnected: function() {},
            received: function(data) {
                console.log('sawp');
                modifyConversationsMenuList(data['conversation_id']);

                var conversation = findConv(data['conversation_id'], 'g');
                var conversation_rendered = ConvRendered(data['conversation_id'], 'g');
                var messages_visible = ConvMessagesVisiblity(conversation);

                MarkGroupConvAsUnseen(data['user_id'], data['conversation_id']);

                appendGroupMessage(conversation_rendered, 
                                   messages_visible, 
                                   conversation,
                                   data['message']);

                if (conversation_rendered) {

                    var messages_list = conversation.find('.messages-list');
                    var height = messages_list[0].scrollHeight;
                    messages_list.scrollTop(height);
                }
                
            },
            send_message: function(message) {
                return this.perform('send_message', {
                    message: message
                });
            },
            set_as_seen: function(conv_id) {
                return this.perform('set_as_seen', { conv_id: conv_id });
            }
        }
    );
}

$(document).on('submit', '.send-group-message', function(e) {
    e.preventDefault();
    var id = $(this).find('input[name=conversation_id]').val();
    var message_values = $(this).serializeArray();
    App['group_conversation_' + id].send_message(message_values);
});


$(document).on('click', '.conversation-window, .group-conversation', function(e) {
    var latest_message = $('.messages-list ul li:last .row', this);
    var unseen_by_user = latest_message.hasClass('unseen');

    if (unseen_by_user) {
        var conv_id = $(this).find('.panel').attr('data-gconversation-id');

        if (conv_id == null) {
            var conv_id = $(this).find('.messages-list').attr('data-gconversation-id');
        }

        $('#menu-gc' + conv_id).removeClass('unseen-conv');
        latest_message.removeClass('unseen');
        calculateUnseenConversations();
        App['group_conversation_' + conv_id].set_as_seen(conv_id);
    }
});

function MarkGroupConvAsUnseen(message_user_id, conversation_id) {
    if (message_user_id != gon.user_id) {
        newGroupConvMenuListLink(conversation_id);

        $('#menu-gc' + conversation_id).addClass('unseen-conv');
        calculateUnseenConversations();
    }
                  
}


function modifyConversationsMenuList(conversation_id) {
    var conversation_menu_link = $('#conversations-menu ul')
                                     .find('#menu-gc' + conversation_id);
    if (conversation_menu_link.length) {
        conversation_menu_link.prependTo('#conversations-menu ul');
    }
}


function appendGroupMessage(conversation_rendered, 
                            messages_visible, 
                            group_conversation,
                            message) {
    if (conversation_rendered) {
        if (!messages_visible) {
        }
        group_conversation
            .find('.messages-list')
            .find('ul')
            .append(message);
    }

}

function newGroupConvMenuListLink(conversation_id) {
    var id_attr = '#menu-gc' + conversation_id;
    var conversation_menu_link = $('#conversations-menu ul').find(id_attr);
    if (conversation_menu_link.length == 0) {
        var list_item = '<li class="conversation-window">\
                             <a data-remote="true"\
                                rel="nofollow"\
                                data-method="post"\
                                href="/group_conversations?group_conversation_id=' +  conversation_id + '">\
                                    group conversation\
                             </a>\
                         </li>';
        $('#conversations-menu ul').prepend(list_item);
    }
}