$(document).on('turbolinks:load', function() {
    $('body').on('click', '.accept-request a', function() {
        var sender_user_fullname = $('nav #user-fullname').html();
        var receiver_user_fullname = $(this)
                                    .parents('[data-user-fullname]')
                                    .attr('data-user-fullname');
                                    
        var requests_menu_item = $('#contacts-requests ul');
        requests_menu_item = requests_menu_item
                                 .find('\
                                       [data-user-fullname="' + 
                                       receiver_user_fullname + 
                                       '"]');
        var conversation_window_request_status = $('.conversation-window')
                                                    .find('[data-user-fullname="' + 
                                                           receiver_user_fullname + 
                                                           '"]');
                                          
        if(conversation_window_request_status.length == 0) {
          conversation_window_request_status = $('.contact-request-status');
        }   
        requests_menu_item.find('.decline-request').remove();
        requests_menu_item
            .find('.accept-request')
            .replaceWith('<span class="accepted-request">Accepted</span>');
        requests_menu_item
            .removeClass('contact-request')
            .addClass('contact-request-responded');
        conversation_window_request_status
            .replaceWith('<div class="contact-request-status">\
                              Request has been accepted\
                          </div>');
        calculateContactRequests();

        App.notification.contact_request_response(sender_user_fullname, 
                                                  receiver_user_fullname, 
                                                  'accepted-contact-request');
    });
    

    $('body').on('click', '.decline-request a', function() {
        var sender_user_fullname = $('nav #user-fullname').html();
        var receiver_user_fullname = $(this)
                                    .parents('[data-user-fullname]')
                                    .attr('data-user-fullname');
        var requests_menu_item = $('#contacts-requests ul')
                                    .find('[data-user-fullname="' + 
                                           receiver_user_fullname + 
                                           '"]');
        var conversation_window_request_status = $('.conversation-window')
                                                    .find('[data-user-fullname="' + 
                                                           receiver_user_fullname + 
                                                           '"]');
                                          
        if(conversation_window_request_status.length == 0) {
          conversation_window_request_status = $('.contact-request-status');
        }   
        requests_menu_item.find('.accept-request').remove();
        requests_menu_item
            .find('.decline-request')
            .replaceWith('<span class="accepted-request">Declined</span>');
        requests_menu_item
            .removeClass('contact-request')
            .addClass('contact-request-responded');
        conversation_window_request_status
            .replaceWith('<div class="contact-request-status">\
                              Request has been declined\
                          </div>');
        calculateContactRequests();

        App.notification.contact_request_response(sender_user_fullname, 
                                                  receiver_user_fullname, 
                                                  'declined-contact-request');
    });

    $('body').on('click', '.add-user-to-contacts-notif', function() {
        var sender_user_fullname = $('nav #user-name').html();
        var receiver_user_fullname = $(this)
                                    .parents('.conversation-window')
                                    .find('.contact-name-notif')
                                    .html();
        App.notification.contact_request_response(sender_user_fullname, 
                                                  receiver_user_fullname, 
                                                  'contact-request-received');
    });

    calculateContactRequests();
});

function calculateContactRequests() {
  var unresponded_requests = $('#contacts-requests ul')
                                .find('.contact-request')
                                .length;
  if (unresponded_requests) {
    $('#unresponded-contact-requests').css('visibility', 'visible');
    $('#unresponded-contact-requests').text(unresponded_requests);
  } else {
    $('#unresponded-contact-requests').css('visibility', 'hidden');
    $('#unresponded-contact-requests').text('');
  }
}