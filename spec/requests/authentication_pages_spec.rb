require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign In" }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

      it { should have_title('Sign In') }
      it { should have_selector('div.alert.alert-error') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Sign Out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }
      it { User.find(user.id).remember_token.should_not be_blank }

      describe "followed by signout" do
        before { click_link "Sign Out" }
        it { should have_link "Sign In" }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content "Update your profile" }
      it { should have_title ("Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }

      describe "with valid information" do
        let(:new_name) { "New Name" }
        let(:new_email) { "new@post.dom" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign Out', href: signout_path) }
        specify { expect(user.reload.name).to  eq new_name }
        specify { expect(user.reload.email).to eq new_email }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content "error" }
      end
    end
  end

  describe "search" do
    let(:user) { FactoryGirl.create(:user) }

    describe "not logged in" do
      before { get search_path }
      specify { expect(response).to redirect_to(signin_path) }
    end

    describe "logged in" do
    before do
      sign_in user
      visit search_path
    end

      describe "page" do
        it { should have_selector('h1', text: "Find your friends") }
        it { should have_selector('h1', text: "Search") }
        it { should have_title   "Search" }
        it { should have_button  "Search" }

        describe "with existed query" do
          before do
            sign_in user
            visit search_path
            fill_in "search_query", with: user.name
            click_button "Search"
          end

          it { should have_content(user.name) }
        end

        describe "with empty query" do
          before { click_button "Search" }

          it { should have_content "Found #{User.count} user" }
        end

        describe "with not existed informations" do
          before do
            fill_in "search_query", with: "not_existed"
            click_button "Search"
          end

          it { should have_content "No matches found"}
        end
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      it { should_not have_link(full_title("Users")) }
      it { should_not have_link(full_title("Sign Out")) }


      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "users page is hide for not registered users" do
          before { visit users_path }

          it { should have_title(full_title("Sign In")) }
        end

        describe "visiting following page" do
          before { visit following_user_path(user) }

          it { should have_title(full_title("Sign In")) }
        end

        describe "visiting followers page" do
          before { visit followers_user_path(user) }

          it { should have_title(full_title("Sign In")) }
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Relationships controller" do

        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@post.dom") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit User')
          end

          describe "when signing in again" do
            before do
              click_link 'Sign Out'
              visit signin_path
              sign_in user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in user, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to root_path }
      end
    end

    describe "user already has account" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        visit signup_path
      end

      it { should have_selector('div.alert.alert-notice') }
    end

    describe "in PasswordReset controller" do

      describe 'sign in page have reset link' do
        before { visit signin_path }

        it { should have_link 'forgotten password?' }
      end

      describe "password reset page" do
        before { visit new_password_reset_path }

        it { should have_title(full_title('Reset Password')) }

        describe "with invalid email" do
          let(:wrong_email) { "not.existed.email@post.dom" }
          before do
            fill_in 'email', with: wrong_email
            click_button 'Reset Password'
          end

          it { should have_selector('div.alert.alert-error') }
        end

        describe "with valid email" do
          let(:user) { FactoryGirl.create(:user) }
          before do
            fill_in 'email', with: user.email
            click_button 'Reset Password'
          end

          it { should have_title(full_title('')) }
          it { should have_selector('div.alert.alert-notice') }
          it { should have_content "Email sent with password reset instructions." }

          describe "link redirects to recovery password form" do
            before do
              user.send_password_reset
              @edit_pass_form_path = "http://www.example.com/password_resets/#{user.password_reset_token}/edit"
              visit @edit_pass_form_path
            end

            it { should have_title(full_title('Recovery Password')) }

            describe "with invalid password" do
              let(:wrong_pass) { "pas" }
              before do
                fill_in 'user_password', with: wrong_pass
                click_button 'Update Password'
              end

              it { should have_selector('div.alert.alert-error')}
            end

            describe "with valid password" do
              let(:valid_password) { "password" }
              before do
                fill_in 'user_password', with: valid_password
                fill_in 'user_password_confirmation', with: valid_password
                click_button 'Update Password'
              end

              it { should have_content "Password has been update!" }
              it { should have_title(full_title('')) }

              describe "when user signed in" do
                before do
                  sign_in user
                  visit @edit_pass_form_path
                end

                it { should have_title(full_title('Edit User')) }
              end
            end

            describe "with expired token" do
              before do
                user.update_attribute(:password_reset_sent_at, 31.minutes.ago)
                get @edit_pass_form_path
              end

              specify { expect(response).to redirect_to new_password_reset_path }
            end
          end
        end
      end
    end
  end
end
