require "spec_helper"

describe NotificationMailer do
  describe "notification email" do
    context "when user has been registered" do
    	let(:user) { User.new(name:"username", email:"username@domain.sf", password:"12345678", password_confirmation:"12345678") }
    	let(:mail) { NotificationMailer.notify_user_registration(user) }

    	it 'renders the subject' do
    		mail.subject.should == 'Welcome to Punchclock'
    	end

      it 'renders the receiver email' do
        mail.to.should == [user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(user.password)
      end

      it 'assigns link to edit password path' do
        mail.body.encoded.should have_link('here', href: users_account_password_edit_path)
      end
    end

    context "when user change your own password" do
      let(:new_password) { Faker::Lorem.characters(8) }
      let(:user) { FactoryGirl.create(:user) }
      let(:mail) { NotificationMailer.notify_user_password_change(user, new_password) }

      it 'renders the subject' do
        mail.subject.should == 'Punchclock - Your password has been modified'
      end

      it 'renders the receiver email' do
        mail.to.should == [user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(new_password)
      end
    end
  end
end