module Caracal
  module Errors
    # This error is raised whenever a page setting method is called with 
    # an invalid argument value.
    #
    InvalidPageSetting = Class.new(StandardError)
    
    # This error is raised when a class lacks a valid reference to a 
    # Caracal document object.
    #
    NoDocumentError = Class.new(StandardError)
  end
end