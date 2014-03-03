require 'spec_helper'

describe "StaticPages" do
  
  let(:base_title) { "CS 232 Rails Development" }
  
  describe "Welcome page" do
    before do 
      visit '/welcome/index'
    end
    
    it "should have Hello header" do
      expect(page).to have_css('h1', text: 'Hello')
    end
    it "should have a welcome paragraph" do
       expect(page).to have_css('p.welcome') 
    end
    it "should have the base title" do
      expect(page).to have_title("#{base_title}")
    end
    it "should not have a custom title" do
      expect(page).not_to have_title("Hello")
    end
    it "should have the nav bar" do
      expect(page).to have_css("ul#nav_menu")
    end
  end
  
  describe "Static Pages Index page" do
    before do 
      visit '/static_pages/index'
    end
    it "should have the content 'Static Pages Index'" do
      expect(page).to have_content('Static Pages Index')
    end
    it "should be listed in the nav bar" do
      within('ul#nav_menu') do
        page.should have_content('Static Pages Index') 
      end
    end
  end
  
  describe "About page" do
    before do 
      visit '/static_pages/about'
    end
    it "should have the content 'About'" do
      expect(page).to have_content('About')
    end
    it "should be listed in the nav bar" do
      within('ul#nav_menu') do
        page.should have_content('About') 
      end
    end
  end
  
  describe "Help page" do
    before do 
      visit '/static_pages/help'
    end
    it "should have the content 'Help'" do
      expect(page).to have_content('Help')
    end
    it "should be listed in the nav bar" do
      within('ul#nav_menu') do
        page.should have_content('Help') 
      end
    end
  end
  
  describe "Links page" do
    before do 
      visit '/static_pages/links'
    end
    it "should have the content 'Links'" do
      expect(page).to have_content('Links')
    end
    it "should be listed in the nav bar" do
      within('ul#nav_menu') do
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
       visit '/static_pages/contact'
     end
     it "should be listed in the nav bar" do
       within('ul#nav_menu') do
         page.should have_content('Contact') 
       end
     end
     it "should have the base title and 'Contact' as the page title" do
       page.should have_title("#{base_title} | Contact")
     end
     it "should have the content 'CS 232 Contact'" do
       page.should have_content('CS 232 Contact')
     end
     it "should have an h1 heading of class page-title" do
       page.should have_css('h1.page-title') 
     end
     it 'should contain an HTML element named <section class="main">' do
       page.should have_css('section.main')
     end
     it "should contain a .main selector" do
       page.should have_selector('.main')
     end
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
