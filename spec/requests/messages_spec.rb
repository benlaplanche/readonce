require 'spec_helper'
require 'pp'

describe "Messages" do

  describe "creating a message", type: :feature do
    before do
      sign_up
    end

    it "redirects to the messages index" do
      visit new_message_path
      fill_in :message_body, with: 'Test'
      click_button 'Send'
      page.should have_content 'Test'
    end

    context 'without filling body field' do
      it 'displays an error' do
        visit new_message_path
        click_button 'Send'
        page.should have_content "Body can't be blank"
      end
    end

    context 'without specifying a receiver' do
      it 'displays an error' do
        visit new_message_path
        fill_in :message_body, with: 'Test'
        click_button 'Send'
        page.should have_content "Receiver can't be blank"
      end
    end

  end

  describe "viewing a list of messages", type: :feature do

    before do
      another_user = FactoryGirl.create(:user, email: 'another@example.com')
      create(:message, sender: another_user, body: 'I am not yours', receiver: another_user)
    end

    it "doesn't show other peoples messages" do
      visit messages_path
      page.should_not have_content "I am not yours"
    end
  end

  describe "view message status", type: :feature do

    let(:user) {FactoryGirl.create(:user)}
    let(:message) { FactoryGirl.create(:message, sender: user, body: 'New message from Rspec', receiver: user) }
    before { sign_in_devise user }

    it "messages count should be one" do
      expect(user.messages.count) == 1
    end

    it "marks message as unread when created" do
      visit messages_path
      expect(message.read) == false
    end

    it "displays message as read when viewed" do
      visit message_path(message)
      page.should have_selector('p', text: 'Message Read: true')
      expect(message.read) == true
    end

  end
end