require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
    it "should be listed in the bottom nav bar" do
      within('nav#nav-bottom') do
        page.should have_content(page_title) 
      end
    end
  end
  
  describe "Welcome page" do
    before { visit root_path }
    let(:heading)    { 'Hello' }
    let(:page_title) { '' }
    
    it_should_behave_like "all static pages"
    it { should have_css('p.welcome') }
    it { should_not have_title("Hello") }
    it { should have_css("ul#nav_menu") }
    it { should have_css("nav#nav-bottom") }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Links page" do
    before { visit links_path }
    let(:heading)    { 'Links' }
    let(:page_title) { 'Links' }
    
    it_should_behave_like "all static pages"
    it "should have an unordered list of at least two links" do
      within('div#main') do
        page.should have_css('ul.links_list') 
        page.all("ul li a").count.should be >= 2
      end
    end
  end
  
  describe "Contact page" do
     before { visit contact_path } 
     let(:heading)    { 'CS 232 Contact' }
     let(:page_title) { 'Contact' }
     
     it_should_behave_like "all static pages"
     it { should have_content('CS 232 Contact') }
     it { should have_css('h1.page-title') }
     it { should have_css('section.main') }
     it { should have_selector('.main') }
     
     it "should contain a Definition List with a <dl>" do
       within('section.main') do
         page.should have_xpath('//dl')
       end
     end
     it "should contain an HTML element <dt> element" do
       within('section.main') do
         page.should have_xpath('//dt')
       end
     end
     it "should contain an HTML element <dd> element" do
       within('section.main') do
         page.should have_xpath('//dd')
       end
     end
   end
   
   it "should have the right links on the layout" do
       visit root_path
       click_link "About"
       expect(page).to have_title(full_title('About'))
       click_link "Links"
        expect(page).to have_title(full_title('Links'))
       click_link "Contact"
       expect(page).to have_title(full_title('Contact'))
       click_link "Help"
       expect(page).to have_title(full_title('Help'))
       click_link "Sign up"
       expect(page).to have_title(full_title('Sign up'))
       click_link "sample app"
       expect(page).to have_title(full_title(''))
     end
 
end
