require 'open-uri'

# We're using this strategy borrowed from ActiveSupport to
# make command syntax a little more flexible. In a perfect 
# world we'd just use the double splat feature of Ruby, but 
# support for that is pretty limited at this point, so we're 
# going the extra mile to be cool.
#
module Caracal
  class Utilities
    
    #-------------------------------------------------------------
    # Public Class Methods
    #-------------------------------------------------------------
    
    def self.extract_options!(args)
      if args.last.is_a?(Hash)
        args.pop
      else
        {}
      end
    end

    # Reads binary content from an http(s) URL or a local file path.
    # Avoids Kernel#open, which no longer fetches URLs on Ruby 3+,
    # reads in text mode on Windows, and runs a leading "|" as a
    # shell command.
    def self.read_resource(location)
      location = location.to_s
      if location =~ /\Ahttps?:\/\//i
        URI.open(location, 'rb', &:read)
      else
        File.binread(location)
      end
    end

  end
end