require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  describe "Welcome page" do
    before do 
      visit root_path
    end
    
    it { should have_css('h1', text: 'Hello') }
    it { should have_css('p.welcome') }
    it { should have_title(full_title('')) }
    it { should_not have_title("Hello") }
    it { should have_css("ul#nav_menu") }
    it { should have_css("nav#nav-bottom") }
    
  end
  
  describe "About page" do
    before do 
      visit about_path
    end
    
    it { should have_content('About') }
    it { should have_title(full_title('About')) }
    
    it "should be listed in the bottom nav bar" do
      within('nav#nav-bottom') do
        page.should have_content('About') 
      end
    end
  end
  
  describe "Help page" do
    before do 
      visit help_path
    end
    
    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
    
    it "should be listed in the bottom nav bar" do
      within('nav#nav-bottom') do
        page.should have_content('Help') 
      end
    end
  end
  
  describe "Links page" do
    before do 
      visit links_path
    end
    
    it { should have_content('Links') }
    it { should have_title(full_title('Links')) }
    
    it "should be listed in the bottom nav bar" do
      within('nav#nav-bottom') do
        page.should have_content('Links') 
      end
    end
    it "should have an unordered list of at least two links" do
      within('div#main') do
        page.should have_css('ul.links_list') 
        page.all("ul li a").count.should be >= 2
      end
    end
  end
  
  describe "Contact page" do
     before do 
       visit contact_path
     end
     it "should be listed in the bottom nav bar" do
       within('nav#nav-bottom') do
         page.should have_content('Contact') 
       end
     end
     
     it { should have_title(full_title('Contact')) }
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
 
end
