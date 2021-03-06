require 'spec_helper'
require 'support/utilities'

describe "Static pages" do
  subject { page }

  it "should have the right links on the layout" do
    visit root_path
    have_rigth_links("About", "About Us")
    have_rigth_links("Help", "Help")
    have_rigth_links("Contact", "Contacts")
    have_rigth_links("Home", "")
    have_rigth_links("Sign up now", "Sign Up")
    have_rigth_links("sample app", "")
  end

  describe "Home page" do
    before { visit root_path }

    have_heading_and_title('Sample App', title: '')

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "following/followed count" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "'microposts' pluralizing correctly" do

        describe "one 'micropost'" do
          it { should have_content("1 micropost") }

          it "few 'microposts'" do
            FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
            visit root_path
            expect(page).to have_content ("#{user.microposts.count} microposts")
          end
        end
      end

      describe "feed pagination" do
        before(:all) { 30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") } }
        after(:all) { user.microposts.delete_all }

        it { should have_selector('div.pagination') }

        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |micropost|
            expect(page).to have_selector('li', text: micropost.content)
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    have_heading_and_title('Help')
  end

  describe "About page" do
    before { visit about_path }

    have_heading_and_title('About', title: 'About Us')
  end

  describe "Contact page" do
    before { visit contact_path }

    have_heading_and_title('Contact', title: 'Contacts')
  end
end
