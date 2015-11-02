require 'spec_helper'
require 'support/utilities'

describe "Static pages" do
  subject { page }

  # Checking links at home page
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contacts'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign Up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(page_title) }
  end

  describe "Home page" do
    before { visit root_path }

    it_should_behave_like "all static pages"
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
  end

  describe "Help page" do
    before { visit help_path }

    it_should_behave_like "all static pages"
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
  end

  describe "Hell page" do
    before { visit hell_path }

    it_should_behave_like "all static pages"
    let(:heading) { 'Hell' }
    let(:page_title) { 'Hell' }
  end

  describe "About page" do
    before { visit about_path }

    it_should_behave_like "all static pages"
    let(:heading) { 'About' }
    let(:page_title) { 'About Us' }
  end

  describe "Contact page" do
    before { visit contact_path }

    it_should_behave_like "all static pages"
    let(:heading) { 'Contact to Us' }
    let(:page_title) { 'Contacts' }
  end
end
