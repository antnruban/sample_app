require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example Name", email: "unit@post.dom",
               password: "password", password_confirmation: "password") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:created_at) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:follow!) }
  it { should respond_to(:following?) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }




  it { should be_valid }
  it { should_not be_admin }

  describe  "with admin attribute set to 'true'" do
    before do
      @user.save
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email with mixed case" do
    let(:mixed_email) { "bArFOO@pOst.doM" }

    it "should be saved in lowercase" do
      @user.email = mixed_email
      @user.save
      expect(@user.email) == mixed_email.downcase
    end
  end

  describe "when name is to long" do
    before { @user.name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user@foocom user@foo..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.email = "use r@foo,com"
      end
    end
  end

  describe "when email address is valid," do
    it "should be valid" do
      addresses = %w[user@foo.com a1us1qw.r@fb.org frst.lst@foo.jp ab@baz.cn example-1@foo.bar ]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      @user.email = @user.email.upcase
      @user.save
    end

    it { should_not be_valid }
  end

  describe "when user password is present" do
    before { @user.password = @user.password_confirmation = "" }

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "not_password" }

    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" *5 }

      it { should be_invalid }
    end
  end

  describe "remember token can't be blank" do
    before { @user.save }
    its (:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.week.ago) }
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.month.ago) }

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }
      let(:followed_user) { FactoryGirl.create(:user) }
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "lorem Ipsum") }
      end


      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each { |micropost| should include(micropost) }
      end
    end
  end

  describe "relationship associations" do
    let(:follower) { FactoryGirl.create(:user) }
    let(:followed) { FactoryGirl.create(:user) }
    before { follower.relationships.create(followed_id: followed.id) }

    it "should destroy associated relationship" do
      relationships = follower.relationships.to_a
      follower.destroy
      expect(relationships).not_to be_empty
      relationships.each do |relationship|
        expect(Relationship.where(followed_id: followed.id )).to be_empty
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end
end
