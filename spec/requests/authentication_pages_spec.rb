require 'spec_helper'

describe "Authentication Pages" do

  describe "signin page" do
    before { visit signin_path }

    specify { expect(page).to have_content('Login') }
    specify { expect(page).to have_title('Login') }
    
    let(:submit) { "Sign in" }
    
    describe "with invalid information" do
      describe "after submission" do
        before { click_button submit }
        specify { expect(page).to have_title('Login') }
        specify { expect(page).to have_error_message('Invalid') }
        specify { expect(page).not_to have_link('Sign out',    href: signout_path) }
        specify { expect(page).to have_link('Login', href: signin_path) }
        it "should not save remember token cookie" do
          Capybara.current_session.driver.request.cookies.[]('remember_token').should be_nil
        end
        describe "after visiting another page" do
          before { click_link "sample app" }
          specify { expect(page).not_to have_error_message('') }
        end
      end
    end
    
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      specify { expect(page).to have_title(user.name) }
      specify { expect(page).to have_link('Profile',     href: user_path(user)) }
      specify { expect(page).to have_link('Sign out',    href: signout_path) }
      specify { expect(page).not_to have_link('Login', href: signin_path) }
      
      it "should save remember token cookie" do
        Capybara.current_session.driver.request.cookies.[]('remember_token').should_not be_nil
      end
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        specify { expect(page).to have_link('Login', href: signin_path) }
      end
    end  
  end
end