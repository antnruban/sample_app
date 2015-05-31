require 'spec_helper'

describe "Search Page" do
  describe 'Raising right paragraph in case empty search request'
    it "Should not render <p> 'Search Results' if search text field is empty" do
      visit search_path
      should_not have_selector('h1', text: 'Search Results by')
    end

  describe 'Adding tags at search results' do
    it "Should add images list" do
      visit search_path
      find(:xpath, ".//input[@id='search_query']").set "foo bar"
      find(:xpath, ".//input[@name='commit']").click
      expect all(:xpath, ".//div/img").to_a.length == true
    end
  end
end
