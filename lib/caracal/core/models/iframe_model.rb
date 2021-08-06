require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models

      # This class handles block options passed to the iframe method.
      #
      class IFrameModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors
        attr_reader :iframe_url
        attr_reader :iframe_data
        attr_reader :iframe_ignorables
        attr_reader :iframe_namespaces
        attr_reader :iframe_relationships

        # initialization
        def initialize(options={}, &block)
          super options, &block
        end


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #=============== PROCESSING =======================

        def preprocess!
          ::Zip::File.open(file) do |zip|
            # locate relationships xml
            entry      = zip.glob('word/_rels/document.xml.rels').first
            content    = entry.get_input_stream.read
            rel_xml    = Nokogiri::XML(content)

            # locate document xml
            entry      = zip.glob('word/document.xml').first
            content    = entry.get_input_stream.read
            doc_xml    = Nokogiri::XML(content)

            # master nodesets
            rel_nodes = rel_xml.children.first.children
            doc_root  = doc_xml.at_xpath('//w:document')
            pic_nodes = doc_xml.xpath('//pic:pic', { pic: 'http://schemas.openxmlformats.org/drawingml/2006/picture' })

            # namespaces
            @iframe_namespaces = doc_root.namespaces

            # ignorable namespaces
            if a = doc_root.attributes['Ignorable']
              @iframe_ignorables = a.value.split(/\s+/)
            end

            # relationships
            media_map = rel_nodes.reduce({}) do |hash, node|
              type = node.at_xpath('@Type').value
              if type.slice(-5, 5) == 'image'
                id   = node.at_xpath('@Id').value
                path = "word/#{ node.at_xpath('@Target').value }"
                hash[id] = path
              end
              hash
            end
            @iframe_relationships = pic_nodes.reduce([]) do |array, node|
              r_node  = node.children[1].children[0]
              r_id    = r_node.attributes['embed'].value.to_s
              r_media = media_map[r_id]

              p_node  = node.children[0].children[0]
              p_id    = p_node.attributes['id'].to_s.to_i
              p_name  = p_node.attributes['name'].to_s
              p_data  = zip.glob(r_media).first.get_input_stream.read

              # register relationship
              array << { id: r_id, type: 'image', target: p_name, data: p_data }
              array
            end
          end
        end


        #=============== GETTERS ==========================

        def file
          @file ||= begin
            if iframe_url.nil?
              file = Tempfile.new('iframe')
              file.write iframe_data
              file.rewind
            else
              file = open(iframe_url)
            end
            file
          end
        end

        def ignorables
          @iframe_ignorables || []
        end

        def namespaces
          @iframe_namespaces || {}
        end

        def relationships
          @iframe_relationships || []
        end


        #=============== SETTERS ==========================

        # strings
        [:data, :url].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@iframe_#{ m }", value.to_s)
          end
        end


        #=============== VALIDATION =======================

        def valid?
          vals = option_keys.map { |m| send("iframe_#{ m }") }.compact
          vals = vals.reject { |v| v.size == 0 }
          vals.size > 0
        end



        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:url, :data]
        end

      end

    end
  end
end
