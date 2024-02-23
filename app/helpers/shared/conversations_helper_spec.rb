require 'rails_helper'

RSpec.describe Shared::ConversationsHelper, :type => :helper do

  context '#private_conv_seen_status' do
    it 'returns an empty string' do
      current_user = create(:user)
      conversation = create(:private_conversation)
      create(:private_message, 
              conversation_id: conversation.id,
              seen: false, 
              user_id: current_user.id)
      view.stub(:current_user).and_return(current_user)
      expect(helper.private_conv_seen_status(conversation)).to eq ''
    end

    it 'returns an empty string' do
      current_user = create(:user)
      recipient = create(:user)
      conversation = create(:private_conversation)
      create(:private_message, 
              conversation_id: conversation.id,
              seen: true, 
              user_id: recipient.id)
      view.stub(:current_user).and_return(current_user)
      expect(helper.private_conv_seen_status(conversation)).to eq ''
    end

    it 'returns unseen-conv status' do
      current_user = create(:user)
      recipient = create(:user)
      conversation = create(:private_conversation)
      create(:private_message, 
              conversation_id: conversation.id,
              seen: false, 
              user_id: recipient.id)
      view.stub(:current_user).and_return(current_user)
      expect(helper.private_conv_seen_status(conversation)).to eq(
        'unseen-conv'
      )
    end

    context '#get_contact_record' do
        it 'returns a Contact record' do
            contact = create(:contact, user_id: current_user.id, contact_id: recipient.id)
            helper.stub(:current_user).and_return(current_user)
            expect(helper.get_contact_record(recipient)).to eq contact
        end
    end

    def group_conv_seen_status(conversation, current_user)
      # if the current_user is nil, it means that the helper is called from the service
      # return an empty string
      if current_user == nil
        ''
      else
        # if the last message of the conversation is not created by this user
        # and is unseen, return an unseen-conv value
        not_created_by_user = conversation.messages.last.user_id != current_user.id
        seen_by_user = conversation.messages.last.seen_by.include? current_user.id
        not_created_by_user && seen_by_user == false ? 'unseen-conv' : ''
      end
    end
    
    context '#group_conv_seen_status' do
    it 'returns unseen-conv status' do
      conversation = create(:group_conversation)
      create(:group_message, conversation_id: conversation.id)
      current_user = create(:user)
      view.stub(:current_user).and_return(current_user)
      expect(helper.group_conv_seen_status(conversation)).to eq(
        'unseen-conv'
      )
    end

    it 'returns an empty string' do
      user = create(:user)
      conversation = create(:group_conversation)
      create(:group_message, conversation_id: conversation.id, user_id: user.id)
      view.stub(:current_user).and_return(user)
      expect(helper.group_conv_seen_status(conversation)).to eq ''
    end

    it 'returns an empty string' do
      user = create(:user)
      conversation = create(:group_conversation)
      message = build(:group_message, conversation_id: conversation.id)
      message.seen_by << user.id
      message.save
      view.stub(:current_user).and_return(user)
      expect(helper.group_conv_seen_status(conversation)).to eq ''
    end
  end

end