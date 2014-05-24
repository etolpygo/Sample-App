require 'spec_helper'

describe User do

  before do 
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
  
  describe "when name is not present" do
    before { @user.name = ' ' }
    specify { expect(@user).not_to be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "b" * 51 }
    specify { expect(@user).not_to be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = ' ' }
    specify { expect(@user).not_to be_valid }
  end
  
  describe "when email format is invalid" do
    it "should  be invalid" do
      addresses = %w[user@bar,com user_at_bar.biz some.user@bar. derp@bang+buck.ly foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[UsER@fOO.CoM Why_M-E@bang.buck.ly first.last@bar.ru]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
    end
    specify { expect(@user).not_to be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    specify { expect(@user).not_to be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "b" * 5 }
    specify { expect(@user).not_to be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "with valid password" do
      it "finds the correct user" do
        expect(@user).to eq(found_user.authenticate(@user.password))
      end
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it "does not find the user" do
        expect(@user).not_to eq(user_for_invalid_password)
        expect(user_for_invalid_password).to be_false
      end
    end
  end
  
  describe "when the email is in mixed case" do
    let(:mixed_case_email) { "uSeR@ExAmPlE.CoM" }
    it "should be saved in lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
  describe "micropost associations" do

    before { @user.save }
    let!(:oldest_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.week.ago)
    end
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    let!(:newest_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.minute.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newest_micropost, newer_micropost, older_micropost, oldest_micropost]
    end
    
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
  end
  
end