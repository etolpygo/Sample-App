require 'spec_helper'

describe "StaticPages" do
  
  let(:base_title) { "Cs232demo" }
  
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
    it "should have the title 'Hello'" do
      expect(page).to have_title("#{base_title} | Hello")
    end
  end
  
  describe "CCSF Rails Index page" do
    it "should have the content 'Index'" do
      visit '/ccsf_rails/index'
      # puts page.html
      expect(page).to have_content('Index')
    end
  end
  
  describe "About page" do
    it "should have the content 'About'" do
      visit '/ccsf_rails/about'
      expect(page).to have_content('About')
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/ccsf_rails/help'
      expect(page).to have_content('Help')
    end
  end
  
  describe "Links page" do
    before do 
      visit '/ccsf_rails/links'
    end
    
    it "should have the content 'Links'" do
      expect(page).to have_content('Links')
    end
    
    it "should have an unordered list of at least two links" do
      within('div#main') do
        expect(page).to have_css('ul.links_list') 
        page.all("ul li a").count.should be >= 2
      end
    end
  end

  
  
end
