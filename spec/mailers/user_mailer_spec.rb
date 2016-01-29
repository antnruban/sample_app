require "spec_helper"

describe UserMailer do
  before(:each) { ActionMailer::Base.delivery_method = :test }

  describe "should send an email after creating user profile" do
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

    it "with two valid confirmation links at multipart" do
      email_string = ActionMailer::Base.deliveries.first.to_s
      confirm_token = User.find_by_email(user_email).confirm_token
      link_regex = /http\:\/\/localhost\:3000\/users\/#{confirm_token}\/confirm_email/
      expect(email_string.scan(link_regex).length).to eq(2)
    end

    describe "with right titles" do
      before { @email = ActionMailer::Base.deliveries.first }

      it { @email.to.should == [user_email] }
      it { @email.from.should == ["sampleapp@post.dom"] }
      it { @email.subject.should == "Wellcome to Sample Application!!" }
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

      describe "with right titles" do
        before { @email = ActionMailer::Base.deliveries.first }

        it { @email.to.should == [followed.email] }
        it { @email.from.should == ["sampleapp@post.dom"] }
        it { @email.subject.should == "#{follower.name} is following you now in Sample Application." }
      end
    end

    describe "if followed is not subscribed" do
      before do
        # followed.unsubscribe
        followed.email_subscribed = false # not finish implementation.
        UserMailer.new_follower_mail(follower, followed).deliver
      end

      it { ActionMailer::Base.deliveries.count.should == 0 }
    end
  end
end
