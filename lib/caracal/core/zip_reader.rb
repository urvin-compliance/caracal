require 'zip_tricks'

module Caracal
  module Core

    # Functions as a small reader adapter for the other models that read ZIPs
    class ZipReader
      def self.open(file_path)
        File.open(file_path, 'rb') do |f|
          yield(new(f))
        end
      end

      def initialize(seekable_io)
        reader = ZipTricks::FileReader.new
        entries = reader.read_zip_structure(io: seekable_io, read_local_headers: true)
        @seekable_io = seekable_io
        @entries_hash = entries.each_with_object({}) do |entry, h|
          h[entry.filename] = entry
        end
      end

      def read_full(file_name_in_archive)
        entry = @entries_hash.fetch(file_name_in_archive)
        reader = entry.extractor_from(@seekable_io)
        out = StringIO.new
        out << reader.extract(65*1024) until reader.eof?
        out.string
      end
    end
  end
end
