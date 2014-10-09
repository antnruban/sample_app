require 'spec_helper'


describe "Static pages" do
  let(:app_name) { "Sample App" }

  	describe "Home page" do

      it "should have the content 'Sample App'" do
      	visit '/static_page/home'
      	expect(page).to have_content()
    	end


      it "should have the right title" do 
        visit '/static_page/home'
        expect(page).to have_title("#{app_name} | Home")
      end
  	end

	describe "Help page" do

      it "should have the content 'Help'" do
      	visit '/static_page/help'
      	expect(page).to have_content('Help')
    	end
      it "should have the right title" do 
        visit '/static_page/help'
        expect(page).to have_title("#{app_name} | Help")
      end
	end

	describe "Hell page" do

     it "should have the content 'Hell'" do
     	visit '/static_page/hell'
     	expect(page).to have_content('Hell')
   		end

      it "should have the right title" do 
        visit '/static_page/hell'
        expect(page).to have_title("#{app_name} | Hell")
      end
	end

	describe "About page" do

     it "should have the content 'About Us'" do
     	visit '/static_page/about'
     	expect(page).to have_content('About Us')
   		end

      it "should have the right title" do 
        visit '/static_page/about'
        expect(page).to have_title("#{app_name} | About")
      end
  end

  describe "Contacts page" do

     it "should have the content 'Contact to Us'" do
      visit '/static_page/contacts'
      expect(page).to have_content('Contact to Us')
      end

      it "should have the right title" do 
        visit '/static_page/contacts'
        expect(page).to have_title("#{app_name} | Contacts")
      end
  end
end