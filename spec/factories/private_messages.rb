FactoryBot.define do 
  factory :private_message, class: 'Private::Message' do
    body { 'a' * 20 }
    association :conversation, factory: :private_conversation
    association :user, factory: :user
  end
end
