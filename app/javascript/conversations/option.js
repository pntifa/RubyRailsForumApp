$(document).on('turbo:load, function ()' {
    $('body').on('click', '.add-people-to-chat', function (){
        $(this).next().togg;e(100, 'swing');
    });
});


$(document).on('click', 
               '.add-user-to-contacts, .add-user-to-contacts-notif', 
               function(e) {
    var conversation_window = $(this).parents('.conversation-window,\
                                               .conversation');
    conversation_window
        .find('.add-user-to-contacts')
        .replaceWith('<div class="contact-request-sent"\
                           style="display: block;">\
                          <div>\
                              <i class="fa fa-question"\
                                 aria-hidden="true"\
                                 title="Contact request sent">\
                              </i>\
                          </div>\
                      </div>');
    conversation_window.find('.add-user-to-contacts-message').remove();
    conversation_window
        .find('.messages_list ul')
        .append('<div class="add-user-to-contacts-message">\
                     Contact request sent\
                 </div>');
});