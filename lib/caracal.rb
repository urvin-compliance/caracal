#------------------------------------------------
# Requirements
#------------------------------------------------

# external dependencies
require 'tilt'

# odds & ends
require 'caracal/errors'
require 'caracal/version'

# document
require 'caracal/document'


#------------------------------------------------
# Extra Setup
#------------------------------------------------

# Add functions to table cell model. we do this here to 
# avoid a circular require between Caracal::Core::Tables 
# and Caracal::Core::Models::TableCellModel.
#
Caracal::Core::Models::TableCellModel.class_eval do
  include Caracal::Core::Breaks
  include Caracal::Core::Images
  include Caracal::Core::Lists
  include Caracal::Core::Rules
  include Caracal::Core::Tables
  include Caracal::Core::Text
end