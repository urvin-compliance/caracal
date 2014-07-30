module Caracal
  module Errors
    # This error is raised whenever a font method is called with 
    # invalid argument values.
    #
    InvalidFontError = Class.new(StandardError)
    
    # This error is raised whenever a page number method is called with 
    # an invalid argument value.
    #
    InvalidPageNumberError = Class.new(StandardError)
    
    # This error is raised whenever a page setting method is called with 
    # an invalid argument value.
    #
    InvalidPageSettingError = Class.new(StandardError)
    
    # This error is raised whenever a style method is called with 
    # invalid argument values.
    #
    InvalidStyleError = Class.new(StandardError)
    
    # This error is raised when a class lacks a valid reference to a 
    # Caracal document object.
    #
    NoDocumentError = Class.new(StandardError)
  end
end