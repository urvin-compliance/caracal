require 'caracal/core/models/border_model'


module Caracal
  module Core
    module Models
      
      # This class handles block options passed to the page margins
      # method.
      #
      class RuleModel < BorderModel
        
        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------
        
        # aliases
        alias_method :rule_color,    :border_color
        alias_method :rule_size,     :border_size
        alias_method :rule_spacing,  :border_spacing
        alias_method :rule_line,     :border_line
        
      end
      
    end
  end
end