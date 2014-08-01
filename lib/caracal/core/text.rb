module Caracal
  module Core
    
    # This module encapsulates all the functionality related to adding text
    # to the document.
    #
    module Text
      def self.included(base)
        base.class_eval do
          
          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------
          
          #============== PARAGRAPHS ==========================
          
          def p(*text, **options, &block)
            puts '='*80
            puts text.inspect
            puts options.inspect
            puts block_given?
            puts '='*80
          end
          
          
          #============== HEADINGS ============================
          
          # All heading methods simply delegate to the paragraph
          # method with an explicitly set style class.
          #
          [:h1, :h2, :h3, :h4, :h5, :h6].each do |method|
            define_method "#{ method }" do |*text, **options, &block|
              options.merge!({ class: style_id_for_header("#{ method }") })
              p(*text, **options, &block)
            end
          end
          
          
          #-------------------------------------------------------------
          # Private Methods
          #-------------------------------------------------------------
          private
          
          # This method translates the html-like command to the 
          # corresponding style id.
          #
          def style_id_for_header(command)
            case command
              when 'h1' then 'Heading1'
              when 'h2' then 'Heading2'
              when 'h3' then 'Heading3'
              when 'h4' then 'Heading4'
              when 'h5' then 'Heading5'
              when 'h6' then 'Heading6'
              else 'Normal'
            end
          end
          
        end
      end
    end
    
  end
end