module ThinkingSphinx
  module Raspell
    # Configuration settings for spelling suggestions in Thinking Sphinx. You
    # can access these either by the singleton instance
    # (ThinkingSphinx::Raspell::Configuration.instance), or through Thinking 
    # Sphinx's existing configuration instance
    # (ThinkingSphinx::Configuration.instance.raspell).
    # 
    # @author Pat Allan
    # 
    class Configuration
      include Singleton
      
      attr_reader :dictionary, :suggestion_mode, :options
      
      # Creates the instance of the singleton with the following defaults:
      # Dictionary is English (en), suggestion mode is normal, and the
      # ignore-case option is enabled.
      # 
      def initialize
        reset
      end
      
      # Resets the instance to the default settings. Probably not necessary in
      # general usage, but makes specs easier to run.
      # 
      def reset
        @dictionary      = 'en'
        @suggestion_mode = :normal
        @options         = {'ignore-case' => true}
        @speller         = nil
      end
      
      # Sets the dictionary for the spelling suggestions. Make sure you have the
      # dictionary installed on your system first.
      # 
      # @example
      #   config.dictionary = 'en_GB'
      # 
      # @param [String] dict dictionary code
      # @raise [ArgumentError] if the dictionary code is not known by Aspell
      # 
      def dictionary=(dict)
        unless dictionaries.include?(dict)
          raise ArgumentError, 'unknown dictionary'
        end
        
        @dictionary = dict
      end
      
      # The list of dictionaries Aspell has on offer.
      # 
      # @return [Array] collection of dictionary codes
      # 
      def dictionaries
        @dictionaries ||= Aspell.list_dicts.collect { |dict| dict.code }
      end
      
      # Set the suggestion mode. Accepts symbols, strings and Aspell constants.
      # The known values are ultra, fast, normal and badspellers/bad-spellers.
      # 
      # @param [Symbol, String] mode suggestion mode
      # @raise [ArgumentError] if the suggestion mode is not known by Aspell
      # 
      def suggestion_mode=(mode)
        mode = mode.gsub(/-/, '').to_sym if mode.is_a?(String)
        
        unless suggestion_modes.include?(mode)
          raise ArgumentError, 'unknown suggestion mode'
        end
        
        @suggestion_mode = mode
      end
      
      # The allowed suggestion modes.
      # 
      # @return [Array] available suggestion modes, as symbols.
      # 
      def suggestion_modes
        [:ultra, :fast, :normal, :badspellers]
      end
      
      # Aspell instance with all appropriate settings defined.
      # 
      # @return [Aspell] the prepared Aspell instance
      # 
      def speller
        @speller ||= build_speller
      end
      
      private
      
      # Convert the suggestion mode symbol to a string, and ensures the dash
      # is added to the bad-spellers mode.
      # 
      # @return [String] Aspell-friendly suggestion mode
      # 
      def actual_suggestion_mode
        suggestion_mode.to_s.gsub(/badspellers/, 'bad-spellers')
      end
      
      # Converts user-defined options to have string keys, as that's what Aspell
      # requires.
      # 
      # @return [Hash] options with string keys
      # 
      def actual_options
        options.keys.inject({}) do |hash, key|
          hash[key] = options[key].to_s
          hash
        end
      end
      
      # Generate the Aspell instance, setting the dictionary, suggestion mode
      # and options as defined in the configuration instance.
      # 
      # @return [Aspell] a new prepared Aspell instance
      # 
      def build_speller
        speller = Aspell.new(dictionary)
        speller.suggestion_mode = actual_suggestion_mode
        actual_options.each do |key, value|
          speller.set_option key, value
        end
        
        speller
      end
    end
    
    module Hooks
      # The singleton ThinkingSphinx::Raspell::Configuration instance.
      # 
      # @return [ThinkingSphinx::Raspell::Configuration] config instance
      # 
      def raspell
        ThinkingSphinx::Raspell::Configuration.instance
      end
    end
  end
end

ThinkingSphinx::Configuration.send(:include, ThinkingSphinx::Raspell::Hooks)
