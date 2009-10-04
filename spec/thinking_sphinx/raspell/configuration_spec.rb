require 'spec/spec_helper'

describe ThinkingSphinx::Configuration do
  describe '#raspell' do
    before :each do
      @config = ThinkingSphinx::Configuration.instance
    end
    
    it "should return a raspell configuration instance" do
      @config.raspell.should be_a(ThinkingSphinx::Raspell::Configuration)
    end
  end
end

describe ThinkingSphinx::Raspell::Configuration do
  before :each do
    @config = ThinkingSphinx::Raspell::Configuration.instance
    @config.reset
  end
  
  describe '#dictionary' do
    it "should default to 'en'" do
      @config.dictionary.should == 'en'
    end
  end
  
  describe '#dictionary=' do
    it "should set the dictionary" do
      @config.dictionary = 'en_GB'
      @config.dictionary.should == 'en_GB'
    end
    
    it "should raise an argument error if the dictionary code is invalid" do
      lambda { @config.dictionary = 'zz' }.should raise_error(ArgumentError)
    end
  end
  
  describe '#dictionaries' do
    it "should return the names of all registered dictionaries" do
      @config.dictionaries.should == Aspell.list_dicts.collect { |dict|
        dict.code
      }
    end
  end
  
  describe '#suggestion_mode' do
    it "should default to normal" do
      @config.suggestion_mode.should == :normal
    end
  end
  
  describe '#suggestion_mode=' do
    it "should set the suggestion mode" do
      @config.suggestion_mode = :ultra
      @config.suggestion_mode.should == :ultra
    end
    
    it "should raise an argument error if the suggestion mode is invalid" do
      lambda { @config.suggestion_mode = :smart }.
        should raise_error(ArgumentError)
    end
    
    it "should translate Aspell constants" do
      @config.suggestion_mode = Aspell::BADSPELLERS
      @config.suggestion_mode.should == :badspellers
    end
  end
  
  describe '#options' do
    it "should return a Hash" do
      @config.options.should be_a(Hash)
    end
    
    it "should have ignore-case defaulting to true" do
      @config.options['ignore-case'].should == true
    end
  end
  
  describe '#suggestion_modes' do
    it "should return ultra, fast, normal and badspellers" do
      @config.suggestion_modes.should == [:ultra, :fast, :normal, :badspellers]
    end
  end
  
  describe '#speller' do
    it "should return an Aspell instance" do
      @config.speller.should be_an(Aspell)
    end
    
    it "should use the configured dictionary" do
      speller = Aspell.new('en_GB')
      Aspell.should_receive(:new).with('en_GB').and_return(speller)
      
      @config.dictionary = 'en_GB'
      @config.speller
    end
    
    it "should set the configured suggestion mode" do
      speller = Aspell.new('en')
      speller.should_receive(:suggestion_mode=).with('bad-spellers')
      Aspell.stub!(:new => speller)
      
      @config.suggestion_mode = :badspellers
      @config.speller
    end
    
    it "should set the configured options" do
      @config.options['ignore-case'] = false
      
      @config.speller.get_option('ignore-case').should == 'false'
    end
    
    it "should reuse the generated instance" do
      Aspell.should_receive(:new).once.and_return(
        stub('speller').as_null_object
      )
      
      @config.speller
      @config.speller
    end
  end
end