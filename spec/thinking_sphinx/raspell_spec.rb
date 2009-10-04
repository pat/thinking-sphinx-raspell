require 'spec/spec_helper'

describe ThinkingSphinx::Search do
  before :each do
    ThinkingSphinx::Configuration.instance.raspell.reset
  end
  
  describe '#suggestion' do
    it "should return a spelling suggestion, if there is one" do
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.suggestion.should == 'words incorrect on purpose'
    end
    
    it "should be actual query if there is no suggestion" do
      search = ThinkingSphinx::Search.new('words all correct here')
      search.suggestion.should == 'words all correct here'
    end
  end
  
  describe '#suggestion?' do
    it "should return true if there is a spelling suggestion" do
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.suggestion?.should be_true
    end
    
    it "should return false if there is no spelling suggestion" do
      search = ThinkingSphinx::Search.new('words all correct here')
      search.suggestion?.should be_false
    end
  end
  
  describe '#redo_with_suggestion' do
    before :each do
      @config = ThinkingSphinx::Configuration.instance
      @client = Riddle::Client.new

      @config.stub!(:client => @client)
      @client.stub!(:query => {:matches => [], :total_found => 0, :total => 0})
    end
    
    it "should repeat the query with the spelling suggestion" do
      @client.should_receive(:query) do |query, index, comment|
        query.should == 'words incorrect on purpose'
      end
      
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.redo_with_suggestion
      search.first
    end
    
    it "should redo the query if it's already been populated" do
      @client.should_receive(:query).twice
      
      search = ThinkingSphinx::Search.new('wodrs incorret on purpose')
      search.first
      search.redo_with_suggestion
      search.first
    end
  end
end
