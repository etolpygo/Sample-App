require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "CS 232 Rails Development"
  end
  
  
  class StaticPagesIndexText < StaticPagesTest
    
    def setup
      get root_path
      super
    end
  
    test "page has Hello header" do
      assert_tag :tag => 'h1', :content => 'Hello'
      # OR: assert_tag :h1, :content => 'Hello'
    end
    test "page has a welcome paragraph" do
      assert_tag :p, attributes: { class: "welcome" }
    end
    test "page has the base title" do
      assert_tag :title, :content => @base_title
    end
    test "page has no custom title" do
      assert_no_tag :title, :content => 'Hello'
    end
    test "page has the nav bar" do
      assert_tag :ul, attributes: { id: 'nav_menu' }
    end
    
  end
  
  
  class AboutPageTest < StaticPagesTest
    
    def setup
      get about_path
      super
    end
    
    test "page has content 'About'" do  
      assert response.body.include?('About')
    end
    test "page is listed in the nav bar" do
      assert_tag :li, :content => 'About',
        :ancestor => { :tag => "ul", :attributes => { :id => "nav_menu" } }
    end
  end
  
  
  class HelpPageTest < StaticPagesTest
    
    def setup
      get help_path
      super
    end
    
    test "page has content 'Help'" do  
      assert response.body.include?('Help')
    end
    test "page is listed in the nav bar" do
      assert_tag :li, :content => 'Help',
        :ancestor => { :tag => "ul", :attributes => { :id => "nav_menu" } }
    end
  end
  
  
  class LinksPageTest < StaticPagesTest
    
    def setup
      get links_path
      super
    end
    
    test "page has content 'Links'" do  
      assert response.body.include?('Links')
    end
    test "page is listed in the nav bar" do
      assert_tag :li, :content => 'Links',
        :ancestor => { :tag => "ul", :attributes => { :id => "nav_menu" } }
    end
    test "page has an unordered list of at least two links" do
      assert_tag :tag => "ul", 
        :attributes => { :class => "links_list" },
        :ancestor => {  :tag => "div",
                      :attributes => { :id => "main" } },
        :children => {  :greater_than => 1, 
                       :only => { :tag => "li", :child => { :tag => "a" } } }
    end
  end
  
  
  class ContactPageTest < StaticPagesTest
    
     def setup
       get contact_path
       super
     end
     
     test "page is listed in the nav bar" do
       assert_tag :li, :content => 'Contact',
         :ancestor => { :tag => "ul", :attributes => { :id => "nav_menu" } }
     end
     test "page has the base title" do
       assert_tag :title, :content => "#{@base_title} | Contact"
     end
     test "page has content 'CS 232 Contact'" do  
       assert response.body.include?('CS 232 Contact')
     end
     test "page has an h1 heading of class page-title" do
       assert_tag :h1, :attributes => { :class => "page-title" }
     end
     test 'page has an HTML element named section of class="main"' do
       assert_tag :section, :attributes => { :class => "main" }
     end
     test 'page has an HTML element of class "main"' do
       assert_tag :attributes => { :class => "main" }
     end
     test "page contains a Definition List with a dl" do
       assert_tag :dl, :ancestor => { :tag => "section", :attributes => { :class => "main" } }
     end
     test "page contains an HTML element dt element" do
        assert_tag :dt, 
          :parent => { :tag => "dl", :ancestor => { :tag => "section", :attributes => { :class => "main" } } }
      end
      test "page contains an HTML element dd element" do
          assert_tag :dd, 
            :parent => { :tag => "dl", :ancestor => { :tag => "section", :attributes => { :class => "main" } } }
      end
   end
end
