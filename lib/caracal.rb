#------------------------------------------------
# Requirements
#------------------------------------------------

# external dependencies
require 'tilt'

# odds & ends
require 'caracal/errors'
require 'caracal/utilities'
require 'caracal/version'

# document
require 'caracal/document'


#------------------------------------------------
# Extra Setup
#------------------------------------------------

# Convenience method for finding root directory.
#
module Caracal
  def self.root
    File.dirname __dir__
  end
end


# Add functions to table cell model. we do this here to
# avoid a circular require between Caracal::Core::Tables
# and Caracal::Core::Models::TableCellModel.
#
Caracal::Core::Models::TableCellModel.class_eval do
  include Caracal::Core::Images
  include Caracal::Core::Lists
  include Caracal::Core::Rules
  include Caracal::Core::Tables
  include Caracal::Core::Text
end

Caracal::Core::Models::FooterModel.class_eval do
  include Caracal::Core::Images
  include Caracal::Core::Lists
  include Caracal::Core::Rules
  include Caracal::Core::Tables
  include Caracal::Core::Text
end

Caracal::Core::Models::HeaderModel.class_eval do
  include Caracal::Core::Images
  include Caracal::Core::Lists
  include Caracal::Core::Rules
  include Caracal::Core::Tables
  include Caracal::Core::Text
end
