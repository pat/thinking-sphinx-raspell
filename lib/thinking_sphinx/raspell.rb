require 'raspell'
require 'thinking_sphinx'
require 'thinking_sphinx/raspell/configuration'

module ThinkingSphinx
  # Module for adding suggestion support into Thinking Sphinx. This gets
  # included into ThinkingSphinx::Search.
  # 
  # @author Pat Allan
  # 
  module Raspell
    # The original query, with words considered mispelt replaced with the first
    # suggestion from Aspell/Raspell.
    # 
    # @return [String] the suggested query
    # 
    def suggestion
      @suggestion ||= all_args.gsub(/[\w\']+/) { |word| corrected_word(word) }
    end
    
    # An indication of whether there are any spelling corrections for the
    # original query.
    # 
    # @return [Boolean] true if the suggested query is different from the
    #   original
    # 
    def suggestion?
      if query_only_digits?
        return false
      end
      suggestion != all_args
    end

    # When you pass digits only to aspell it will always return a false positive 
    # suggestion 'W'.
    # Not sure if aspell is meant to ignore digits, or it's the C API that raspell
    # is using.
    # I've asked clarification in the aspell ML:
    # http://lists.gnu.org/archive/html/aspell-user/2011-10/msg00003.html
    def query_only_digits?
      all_args =~ /^\d+$/
    end
    
    # Modifies the current search object, switching queries and removing any
    # previously stored results.
    # 
    def redo_with_suggestion
      @query      = nil
      @args       = [suggestion]
      @populated  = false
    end
    
    private
    
    # The search query as a single string, excluding any field-focused values
    # provided using the :conditions option.
    # 
    # @return [String] all query arguments joined together by spaces.
    # 
    def all_args
      args.join(' ')
    end
    
    # The first spelling suggestion, if the given word is considered incorrect,
    # otherwise the word is returned unchanged.
    # 
    # @param [String] word The word to check.
    # @return [String] Spelling correction for the given word.
    # 
    def corrected_word(word)
      speller.check(word) ? word : speller.suggest(word).first
    end
    
    # Aspell instance with all appropriate settings defined.
    # 
    # @return [Aspell] the prepared Aspell instance
    # 
    def speller
      ThinkingSphinx::Configuration.instance.raspell.speller
    end
  end
end

ThinkingSphinx::Search.send(:include, ThinkingSphinx::Raspell)
