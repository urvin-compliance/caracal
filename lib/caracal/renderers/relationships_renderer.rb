require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class RelationshipsRenderer < XmlRenderer
      
      #-------------------------------------------------------------
      # Class Methods
      #-------------------------------------------------------------

      # The relationships default to the document's. Headers and footers
      # pass their own.
      #
      def self.render(doc, relationships = nil)
        renderer = new(doc, relationships)
        renderer.to_xml
      end


      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      def initialize(doc, relationships = nil)
        super(doc)
        @relationships = relationships || document.relationships
      end

      # This method produces the xml required for a relationships
      # sub-document, such as `word/_rels/document.xml.rels`.
      #
      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml.send 'Relationships', root_options do
            @relationships.each do |rel|
              xml.send 'Relationship', rel_options(rel)
            end
          end
        end
        builder.to_xml(save_options)
      end
      
      
      #-------------------------------------------------------------
      # Private Methods
      #------------------------------------------------------------- 
      private
      
      def rel_options(rel)
        opts = { 'Target' => rel.formatted_target, 'Type' => rel.formatted_type, 'Id' => rel.formatted_id}
        opts['TargetMode'] = 'External' if rel.target_mode?
        opts
      end
      
      def root_options
        {
          'xmlns' => 'http://schemas.openxmlformats.org/package/2006/relationships'
        }
      end
   
    end
  end
end