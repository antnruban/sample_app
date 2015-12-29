require 'spec_helper'

describe "Micropost Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with not valid information" do

      it "it should not create micropost" do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe "error message" do
        before { click_button 'Post'}
        it { should have_content 'error' }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem Ipsum" }
      it "should create micropost" do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
    end
  end
end
