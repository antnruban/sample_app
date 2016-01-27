require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "profile page" do
    let(:user)       { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user) }
    let!(:mp)  { FactoryGirl.create(:micropost, user: user, content: "content") }
    let!(:mp1) { FactoryGirl.create(:micropost, user: user, content: "content") }
    before { visit user_path(user) }

    it { should have_content (user.name) }
    it { should have_title (user.name) }

    describe "microposts" do
      it { should have_content mp.content }
      it { should have_content mp1.content }
      it { should have_content user.microposts.count }

      describe "delete links" do
        before do
          FactoryGirl.create(:micropost, user: wrong_user, content: "content")
          sign_in user
        end
        it { should have_link "delete" }

        describe "wrong user" do
          before { visit user_path(wrong_user) }
          it { should_not have_link "delete" }
        end
      end
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_title(full_title('Sign Up')) }
    it { should have_selector('h1', text:'Sign Up') }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_content('error') }
        it { should have_title('Sign Up') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
        let(:flash_message) { "Email was send to #{user.email}, you need to confirm your account."}

        it { should have_title(full_title("")) }
        it { should have_selector( 'div.alert.alert-success', text: flash_message) }
      end
    end
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob",  email: "boby@post.dom")
      FactoryGirl.create(:user, name: "Ruph", email: "ruph@post.dom")
      FactoryGirl.create(:user, name: "Ray",  email: "rayh@post.dom")
      visit users_path
    end

    it { should have_title(full_title("All Users")) }
    it { should have_content "All Users" }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end

  describe "following/followers" do
    let(:user)       { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
