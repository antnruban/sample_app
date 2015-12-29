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

    have_heading_title('Sample App', title: '')

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        sign_in user
        visit root_path
      end

      it "should render user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    have_heading_title('Help')
  end

  describe "Hell page" do
    before { visit hell_path }

    have_heading_title('Hell')
  end

  describe "About page" do
    before { visit about_path }

    have_heading_title('About', title: 'About Us')
  end

  describe "Contact page" do
    before { visit contact_path }

    have_heading_title('Contact', title: 'Contacts')
  end
end
