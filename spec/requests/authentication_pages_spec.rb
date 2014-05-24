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
      specify { expect(page).to have_link('Users',       href: users_path) }
      specify { expect(page).to have_link('Profile',     href: user_path(user)) }
      specify { expect(page).to have_link('Settings',    href: edit_user_path(user)) }
      specify { expect(page).to have_link('Sign out',    href: signout_path) }
      specify { expect(page).not_to have_link('Login', href: signin_path) }
      
      it "saves remember token cookie" do
     Capybara.current_session.driver.request.cookies.[]('remember_token').should_not be_nil
      end
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        specify { expect(page).to have_link('Login', href: signin_path) }
        specify { expect(page).not_to have_link('Settings',    href: edit_user_path(user)) }
      end
    end  
  end
  
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          specify { expect(page).to have_title('Login') }
          specify { expect(page).to have_notice_message(/Please sign in/) }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          specify { expect(page).to have_title('Login') }
          specify { expect(page).to have_notice_message(/Please sign in/) }
        end
        
      end
      
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
        
  end
end