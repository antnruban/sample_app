require 'spec_helper'

describe "Static pages" do

  	describe "Home page" do

      it "should have the content 'Sample App'" do
      	visit '/static_page/home'
      	expect(page).to have_content('Sample App')
    	end
  	end

	describe "Help page" do

      it "should have the content 'Help'" do
      	visit '/static_page/help'
      	expect(page).to have_content('Help')
    	end
	end
	describe "Hell page" do

     it "should have the content 'Hell'" do
     	visit '/static_page/hell'
     	expect(page).to have_content('Hell')
   		end
	end
	describe "About page" do

     it "should have the content 'About Us'" do
     	visit '/static_page/about'
     	expect(page).to have_content('About Us')
   		end
	end
end

