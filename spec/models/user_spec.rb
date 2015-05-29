require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example Name", email: "unit@post.dom",
                        password: "password", password_confirmation: "password")}

	subject { @user }

	it { should respond_to(:name)}
	it { should respond_to(:email)}
	it { should respond_to(:created_at)}
  it { should respond_to(:password_digest) }
  it { should respond_to (:password)}
  it { should respond_to (:password_confirmation)}
  it { should respond_to (:authenticate)}

	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = " "}
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " "}
		it { should_not be_valid }
	end

	describe "when name is to long" do
		before { @user.name = "a" * 31}
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
    	it "should be invalid" do
    	  	addresses = %w[user@foo,com user_at_foo.org example.user@foo.
    	  	 		foo@bar_baz.com foo@bar+baz.com user@foocom]
    	  	addresses.each do |invalid_address|
    	    @user.email = invalid_address
    	    @user.email = "use r@foo,com"
      		end
    	end
  	end

  	describe "when email address is valid," do
  		it "should be valid" do 
  			addresses = %w[user@foo.com a1us1qw.r@fb.org frst.lst@foo.jp ab@baz.cn]
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
      before { @user.password = @user.password_confirmation = " " }

      it { should_not be_valid}
    end

    describe "when passowrd dosen't match confirmation" do
      before { @user.password_confirmation = "not_password" }

      it { should_not be_valid}
    end

    describe "return value of authenticate method" do
      before {@user.save}
      let(:found_user) { User.find_by(email: @user.email)}

      describe "with valid password" do
        it { should eq found_user.authenticate(@user.password) }
      end

      describe "whith invalid password" do 
        let(:user_for_invalid_password) { found_user.authenticate("invalid")}

        it { should_not eq user_for_invalid_password }
        specify { expect(user_for_invalid_password).to be_false }
      end

      describe "with a password that's too short" do
        before { @user.password = @user.password_confirmation = "a" *5 }

        it { should be_invalid }
      end
    end
end
