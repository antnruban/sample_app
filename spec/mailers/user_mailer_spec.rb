require "spec_helper"

describe UserMailer do
  before(:each) { ActionMailer::Base.delivery_method = :test }

  describe "email after creating user profile" do
    let(:user_email) { "user@example.com" }
    before do
      visit signup_path
      fill_in "Name",             with: "Example User"
      fill_in "Email",            with:  user_email
      fill_in "Password",         with: "foobar"
      fill_in "Confirm Password", with: "foobar"
      click_button "Create my account"
    end

    it { ActionMailer::Base.deliveries.count.should == 1 }

    describe "right titles" do
      let(:email) { ActionMailer::Base.deliveries.first }

      it { email.to.should == [user_email] }
      it { email.from.should == ["sampleapp@post.dom"] }
      it { email.subject.should == "Wellcome to Sample Application!!" }

      it "with valid confirmation link" do
        email_string = email.to_s
        confirm_token = User.find_by_email(user_email).confirm_token
        href = "http://localhost:3000/users/#{confirm_token}/confirm_email"
        expect(email_string.should have_link('Confirmation link.', href: href))
      end
    end
  end

  describe "email about new follower" do
    let(:follower) { FactoryGirl.create(:user) }
    let(:followed) { FactoryGirl.create(:user) }

    describe "if followed is subscribed" do
      before do
        sign_in follower
        visit user_path(followed)
        click_button "Follow"
      end

      it { ActionMailer::Base.deliveries.count.should == 1 }

      describe "right titles" do
        let(:email) { ActionMailer::Base.deliveries.first }

        it { email.to.should == [followed.email] }
        it { email.from.should == ["sampleapp@post.dom"] }
        it { email.subject.should == "#{follower.name} is following you now in Sample Application." }
      end

      describe "with unsubscribe link" do
        let(:email_string) { ActionMailer::Base.deliveries.first.to_s }

        it { email_string.should have_link 'unsubscribe' }
      end
    end

    describe "if followed is not subscribed" do
      before do
        followed.unsubscribe_user
        UserMailer.new_follower_mail(follower, followed).deliver
      end

      it { ActionMailer::Base.deliveries.count.should == 0 }
    end
  end

  describe "email password reset" do
    let(:user) { FactoryGirl.create(:user) }
    before { user.send_password_reset }

    it { ActionMailer::Base.deliveries.count.should == 1 }

    describe "right titles" do
      let(:email) { ActionMailer::Base.deliveries.first }

      it { email.to.should == [user.email] }
      it { email.from.should == ["sampleapp@post.dom"] }
      it { email.subject.should == "Recovery your password" }

      it "with password reset link" do
        token = user.password_reset_token
        href = "http://localhost:3000/password_resets/#{token}/edit"
        expect(email.to_s.should have_link('Reset password.', href: href))
      end
    end
  end
end
