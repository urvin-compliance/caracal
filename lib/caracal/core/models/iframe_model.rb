require 'tempfile'
require 'caracal/core/models/base_model'
require 'caracal/errors'

module Caracal
  module Core
    module Models

      # This class handles block options passed to the img method.
      #
      class IFrameModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # constants
        const_set(:DEFAULT_MAX_ENTRY_SIZE, 50 * 1024 * 1024)   # 50MB

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
        # Class Methods
        #--------------------------------------------------

        # The largest single entry Caracal will read out of an embedded
        # document. Zip entries expand to many times their stored size, so
        # without a limit a small file can exhaust memory. Set to nil to
        # disable the check.
        #
        def self.max_entry_size
          defined?(@max_entry_size) ? @max_entry_size : DEFAULT_MAX_ENTRY_SIZE
        end

        def self.max_entry_size=(value)
          @max_entry_size = value
        end

        # This method reads a single entry from an embedded document,
        # refusing anything larger than :max_entry_size.
        #
        def self.read_entry(entry)
          limit = max_entry_size

          if limit && entry.size > limit
            raise Caracal::Errors::InvalidModelError, "iframe entry #{ entry.name } is #{ entry.size } bytes, over the #{ limit } byte limit."
          end

          entry.get_input_stream.read
        end


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #=============== PROCESSING =======================

        def preprocess!
          ::Zip::File.open(file) do |zip|
            # locate relationships xml
            entry      = zip.glob('word/_rels/document.xml.rels').first
            content    = self.class.read_entry(entry)
            rel_xml    = Nokogiri::XML(content)

            # locate document xml
            entry      = zip.glob('word/document.xml').first
            content    = self.class.read_entry(entry)
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
              p_data  = self.class.read_entry(zip.glob(r_media).first)

              # register relationship
              array << { id: r_id, type: 'image', target: p_name, data: p_data }
              array
            end
          end
        end


        #=============== GETTERS ==========================

        def file
          @file ||= begin
            content = iframe_url.to_s.empty? ? iframe_data : ::Caracal::Utilities.read_resource(iframe_url)
            file    = Tempfile.new(['iframe', '.docx'])
            file.binmode
            file.write content
            file.close    # flushes the write; rubyzip reopens by path
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
