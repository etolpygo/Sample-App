require 'spec_helper'

describe "StaticPages" do
  describe "GET /ccsf_rails/index" do
    
    it "should have the content 'Index'" do
      visit '/ccsf_rails/index'
      # puts page.html
      expect(page).to have_content('Index')
    end
    
    
  end
end
