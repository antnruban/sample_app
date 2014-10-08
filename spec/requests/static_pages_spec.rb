require 'spec_helper'

describe "Static pages" do

  	describe "Home page" do

      it "should have the content 'Sample App'" do
      	visit '/static_page/home'
      	expect(page).to have_content('Sample App')
    	end


      it "should have the right title" do 
        visit '/static_page/home'
        expect(page).to have_title("Sample App | Home")
      end
  	end

	describe "Help page" do

      it "should have the content 'Help'" do
      	visit '/static_page/help'
      	expect(page).to have_content('Help')
    	end
      it "should have the right title" do 
        visit '/static_page/help'
        expect(page).to have_title("Sample App | Help")
      end
	end

	describe "Hell page" do

     it "should have the content 'Hell'" do
     	visit '/static_page/hell'
     	expect(page).to have_content('Hell')
   		end

      it "should have the right title" do 
        visit '/static_page/hell'
        expect(page).to have_title("Sample App | Hell")
      end
	end

	describe "About page" do

     it "should have the content 'About Us'" do
     	visit '/static_page/about'
     	expect(page).to have_content('About Us')
   		end

      it "should have the right title" do 
        visit '/static_page/about'
        expect(page).to have_title("Sample App | About")
      end
  end
end