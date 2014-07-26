# external dependencies
require 'nokogiri'
require 'tilt'
require 'zip'

# odds & ends
require 'caracal/errors'
require 'caracal/version'

# core
require 'caracal/core/file_name'
require 'caracal/core/page_numbers/page_numbers_block_handler'
require 'caracal/core/page_numbers'
require 'caracal/core/page_settings/page_margins_block_handler'
require 'caracal/core/page_settings/page_size_block_handler'
require 'caracal/core/page_settings'
require 'caracal/core/relationships/relationship_model'
require 'caracal/core/relationships'

# renderers
require 'caracal/renderers/xml_renderer'
require 'caracal/renderers/app_renderer'
require 'caracal/renderers/content_types_renderer'
require 'caracal/renderers/core_renderer'
require 'caracal/renderers/document_renderer'
require 'caracal/renderers/footer_renderer'
require 'caracal/renderers/settings_renderer'

# document
require 'caracal/document'
