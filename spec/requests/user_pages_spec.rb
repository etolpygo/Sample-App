require 'spec_helper'

describe "User pages" do
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    specify { expect(page).to have_content(user.name) }
    specify { expect(page).to have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    specify { expect(page).to have_content('Sign up') }
    specify { expect(page).to have_title(full_title('Sign up')) }
  end
  
  describe "signup" do

      before { visit signup_path }

      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
        describe "after submission" do
          before { click_button submit }
          specify { expect(page).to have_title('Sign up') }
          specify { expect(page).to have_error_message(/The form contains \d error/) }
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end
        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by(email: 'user@example.com') }
          
          specify { expect(page).to have_link('Sign out') }
          specify { expect(page).to have_title(user.name) }
          specify { expect(page).to have_selector('div.alert.alert-success', text: 'Welcome') }
        end
      end
    end

  
end