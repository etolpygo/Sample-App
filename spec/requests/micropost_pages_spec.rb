require 'spec_helper'

describe "Micropost pages" do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with no post" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        specify { expect(page).to have_content('error') }
        specify { expect(page).to have_error_message(/The form contains \d error/) }
      end
    end
    
    describe "with post too long" do
      
      before { fill_in 'micropost_content', with: "z" * 141 }
      
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        specify { expect(page).to have_content('error') }
        specify { expect(page).to have_error_message(/The form contains \d error/) }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
end