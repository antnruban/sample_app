require 'spec_helper'
require 'support/utilities'

describe "Static pages" do
  subject { page }

describe "Home page" do
  before { visit root_path }
      it { should have_content(full_title('')) }
      it { should have_title(full_title('')) }
      it { should_not have_title("| Home") }
    end

describe "Help page" do
  before { visit help_path }
    it { should have_content ('Help') }
    it { should have_title (full_title(' Help')) }
	end

describe "Hell page" do
  before { visit hell_path }
    it { should have_content ("Hell") }
    it { should have_title (full_title('Hell')) }
	end

  describe "About page" do
    before { visit about_path }
      it { should have_content ("About")}
      it { should have_title (full_title('About Us'))}
  end

describe "Contact page" do
  before { visit contact_path }
    it { should have_content ("Contact to Us") }
    it { should have_title (full_title('Contacts')) }
  end
end