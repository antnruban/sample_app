require 'spec_helper'


describe "Static pages" do
  let(:app_name) { "Sample App" }

describe "Home page" do

      it "should have the content 'Sample App'" do
      	visit root_path
      	expect(page).to have_content("#{app_name}")
    	end


      it "should have the right title" do 
        visit root_path
        expect(page).to have_title("#{app_name}")
      end

      it "should not have a custom title" do
        visit root_path
        expect(page).not_to have_title('| Home') 
      end
  	end

describe "Help page" do

      it "should have the content 'Help'" do
      	visit help_path
      	expect(page).to have_content('Help')
    	end
      it "should have the right title" do 
        visit help_path
        expect(page).to have_title("#{app_name} | Help")
      end
	end

describe "Hell page" do

     it "should have the content 'Hell'" do
     	visit hell_path
     	expect(page).to have_content('Hell')
   		end

      it "should have the right title" do 
        visit hell_path
        expect(page).to have_title("#{app_name} | Hell")
      end
	end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit about_path
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      expect(page).to have_title("#{app_name} | About Us")
      end
  end

describe "Contact page" do

     it "should have the content 'Contact to Us'" do
      visit contact_path
      expect(page).to have_content('Contact to Us')
      end

      it "should have the right title" do 
        visit contact_path
        expect(page).to have_title("#{app_name} | Contacts")
      end
  end
end