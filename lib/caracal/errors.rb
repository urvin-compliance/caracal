module Caracal
  module Errors
    # This error is raised whenever a model is created with 
    # invalid options.
    #
    InvalidModelError = Class.new(StandardError)
    
    # This error is raised whenever a table model is passed an
    # invalid data structure.
    #
    InvalidTableDataError = Class.new(StandardError)
    
    # This error is raised if the document does not have a default 
    # style declared.
    #
    NoDefaultStyleError = Class.new(StandardError)
    
    # This error is raised when a class lacks a valid reference to a 
    # Caracal document object.
    #
    NoDocumentError = Class.new(StandardError)
  end
end