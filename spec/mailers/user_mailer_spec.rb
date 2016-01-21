require "spec_helper"

describe UserMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe "should send an email after creating user profile" do
    before { @user = User.create(name: "username", email: "username@post.dom", password: "password",
                                                             password_confirmation: "password") }

    it { ActionMailer::Base.deliveries.count.should == 1 }

    describe "with right titles" do
      before { @email = ActionMailer::Base.deliveries.first }

      it { @email.to.should == [@user.email] }
      it { @email.from.should == ["sampleapp@post.dom"] }
      it { @email.subject.should == "Wellcome to Sample Application!!" }
    end
  end
end
