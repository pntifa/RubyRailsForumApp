module Private::ConversationsHelper
    include Shared::ConversationsHelper
    # get the opposite user of the conversation
    def private_conv_recipient(conversation)
        conversation.opposed_user(current_user)
    end

    # if the conversation has unshown messages, show a button to get them
    def load_private_messages(conversation)
        if conversation.messages.count > 0 
        'private/conversations/conversation/messages_list/link_to_previous_messages'
        else
        'shared/empty_partial'
        end 
    end

    context '#add_to_contacts_partial_path' do
    let(:contact) { create(:contact) }

        it "returns an empty partial's path" do
            helper.stub(:recipient_is_contact?).and_return(true)
            expect(helper.add_to_contacts_partial_path(contact)).to eq(
            'shared/empty_partial'
            )
        end

        it "returns add_user_to_contacts partial's path" do
            helper.stub(:recipient_is_contact?).and_return(false)
            helper.stub(:unaccepted_contact_exists).and_return(false)
            expect(helper.add_to_contacts_partial_path(contact)).to eq(
            'private/conversations/conversation/heading/add_user_to_contacts' 
            )
        end
    end

    context 'private scope' do
    let(:current_user) { create(:user) }
    let(:recipient) { create(:user) }

        context '#unaccepted_contact_exists' do
            it 'returns false' do
            contact = create(:contact, accepted: true)
            expect(helper.instance_eval {
                unaccepted_contact_exists(contact)
            }).to eq false
            end

            it 'returns false' do
            contact = nil
            expect(helper.instance_eval {
                unaccepted_contact_exists(contact)
            }).to eq false
            end

            it 'returns true' do
            contact = create(:contact, accepted: false)
            expect(helper.instance_eval {
                unaccepted_contact_exists(contact)
            }).to eq true
            end
        end

        context '#recipient_is_contact?' do
            it 'returns false' do
            helper.stub(:current_user).and_return(current_user)
            assign(:recipient, recipient)
            create_list(:contact, 2, user_id: current_user.id, accepted: true)
            expect(helper.instance_eval { recipient_is_contact? }).to eq false
            end

            it 'returns true' do
            helper.stub(:current_user).and_return(current_user)
            assign(:recipient, recipient)
            create_list(:contact, 2, user_id: current_user.id, accepted: true)
            create(:contact, 
                    user_id: current_user.id, 
                    contact_id: recipient.id, 
                    accepted: true)
            expect(helper.instance_eval { recipient_is_contact? }).to eq true
            end
        end

        # decide which conversation heading style to show
        def conv_heading_class(contact)
            # show a conversation heading without or with options
            if unaccepted_contact_exists(contact)
            'conversation-heading-full'
            else
            'conversation-heading'
            end
        end

        def get_contact_record(recipient)
            contact = Contact.find_by_users(current_user.id, recipient.id)
        end

        # show an unaccepted contact request's status if any
        def unaccepted_contact_request_partial_path(contact)
            if unaccepted_contact_exists(contact) 
            if request_sent_by_user(contact)
                "private/conversations/conversation/request_status/sent_by_current_user"  
            else
                "private/conversations/conversation/request_status/sent_by_recipient" 
            end
            else
            'shared/empty_partial'
            end
        end
        
        # show a link to send a contact request
        # if an opposite user is not in contacts and no requests exist
        def not_contact_no_request_partial_path(contact)
            if recipient_is_contact? == false && unaccepted_contact_exists(contact) == false
            "private/conversations/conversation/request_status/send_request"
            else
            'shared/empty_partial'
            end
        end
        
        private
        
        def request_sent_by_user(contact)
            # true if contact request was sent by the current_user 
            # false if it was sent by a recipient
            contact['user_id'] == current_user.id
        end
    end
end
