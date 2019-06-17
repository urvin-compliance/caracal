require 'nokogiri'


module Caracal
  module Renderers
    class XmlRenderer

      #-------------------------------------------------------------
      # Configuration
      #-------------------------------------------------------------

      attr_reader :document


      #-------------------------------------------------------------
      # Class Methods
      #-------------------------------------------------------------

      # This method produces xml output for the given document
      # according to the rules of this renderer object.
      #
      def self.render(doc)
        renderer = new(doc)
        renderer.to_xml
      end


      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method instantiates a new verison of this renderer.
      #
      def initialize(doc)
        unless doc.is_a?(Caracal::Document) or doc.is_a?(Caracal::Header)
          raise NoDocumentError, 'renderers must receive a reference to a valid Caracal document object.'
        end

        @document = doc
      end

      # This method converts data in the specified document to XML.
      # A concrete implementation must be provided by the subclass.
      #
      def to_xml
        raise NotImplementedError, 'renderers must implement the method :to_xml.'
      end


      #-------------------------------------------------------------
      # Private Methods
      #-------------------------------------------------------------
      private

      # This method returns a Nokogiri::XML object that contains the
      # specific declaration we want.
      #
      def declaration_xml
        ::Nokogiri::XML('<?xml version = "1.0" encoding = "UTF-8" standalone ="yes"?>')
      end

      # This method returns a commonly used set of attributes for paragraph nodes.
      #
      def paragraph_options
        { 'w:rsidP' => '00000000', 'w:rsidRDefault' => '00000000' }.merge(run_options)
      end

      # This method returns a commonly used set of attributes for text run nodes.
      #
      def run_options
        { 'w:rsidR' => '00000000', 'w:rsidRPr' => '00000000', 'w:rsidDel' => '00000000' }
      end

      # These save options force Nokogiri to remove indentation and
      # line feeds from the output.
      #
      def save_options
        { save_with: Nokogiri::XML::Node::SaveOptions::AS_XML }
      end

    end
  end
end
