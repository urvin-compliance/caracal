# external dependencies
require 'nokogiri'
require 'tilt'
require 'zip'

# odds & ends
require 'caracal/errors'
require 'caracal/version'

# core
require 'caracal/core/file_name'
require 'caracal/core/page_settings/page_margins_block_handler'
require 'caracal/core/page_settings/page_size_block_handler'
require 'caracal/core/page_settings'

# renderers
require 'caracal/renderers/xml_renderer'
require 'caracal/renderers/app_renderer'
require 'caracal/renderers/core_renderer'

# document
require 'caracal/document'
