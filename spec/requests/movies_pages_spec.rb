require 'spec_helper'

describe "MoviesPages" do
  describe "Index page" do
    
    before { visit root_path }
    
    it "should have the h1 'Movie index'" do
      page.should have_selector('h1', :text => 'Movie index')
    end
    
  end
end
