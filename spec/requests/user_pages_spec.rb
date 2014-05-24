require 'spec_helper'

describe "User pages" do
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    specify { expect(page).to have_title('All users') }
    specify { expect(page).to have_content('All users') }
    
    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      specify { expect(page).to have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
      
    end # end describe "pagination"

    # it "should list each user" do
    #   User.all.each do |user|
    #     expect(page).to have_selector('li', text: user.name)
    #   end
    # end
    
    
    describe "delete links" do

      specify { expect(page).not_to have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        specify { expect(page).to have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        specify { expect(page).not_to have_link('delete', href: user_path(admin)) }
      end
    end # end describe "delete links"
        
  end # end index
  
######################################
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    specify { expect(page).to have_content(user.name) }
    specify { expect(page).to have_title(user.name) }

    describe "microposts" do
      specify { expect(page).to have_content(m1.content) }
      specify { expect(page).to have_content(m2.content) }
      specify { expect(page).to have_content(user.microposts.count) }
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          specify { expect(page).to have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          specify { expect(page).to have_xpath("//input[@value='Follow']") }
        end
      end
    end

  end # end describe "profile page"

######################################

  describe "signup page" do
    before { visit signup_path }

    specify { expect(page).to have_content('Sign up') }
    specify { expect(page).to have_title(full_title('Sign up')) }
  end
  
######################################
  
  describe "signup" do
  
    before { visit signup_path }
  
    let(:submit) { "Create my account" }
  
    describe "with invalid information" do
      it "should not create a user" do
        expect{ click_button submit }.not_to change(User, :count)
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
      
    end # end describe "with valid information"
    
  end # end describe "signup"
   
######################################
    
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "edit page" do
      specify { expect(page).to have_content("Update your profile") }
      specify { expect(page).to have_title("Edit user") }
      specify { expect(page).to have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "submit with invalid information" do
      before { click_button "Save changes" }
      specify { expect(page).to have_title("Edit user") }
      specify { expect(page).to have_error_message(/The form contains \d error/) }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      specify { expect(page).to have_title(new_name) }
      specify { expect(page).to have_selector('div.alert.alert-success') }
      specify { expect(page).to have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
      
    end # end describe "with valid information"
    
  end # end edit
  
######################################

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      specify { expect(page).to have_title(full_title('Following')) }
      specify { expect(page).to have_selector('h3', text: 'Following') }
      specify { expect(page).to have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      specify { expect(page).to have_title(full_title('Followers')) }
      specify { expect(page).to have_selector('h3', text: 'Followers') }
      specify { expect(page).to have_link(user.name, href: user_path(user)) }
    end
    
  end # end describe "following/followers"
  
end # end describe "User pages"