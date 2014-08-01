# external dependencies
require 'nokogiri'
require 'tilt'
require 'zip'

# odds & ends
require 'caracal/errors'
require 'caracal/version'

# core
require 'caracal/core/models/font_model'
require 'caracal/core/models/list_style_model'
require 'caracal/core/models/page_number_model'
require 'caracal/core/models/page_margin_model'
require 'caracal/core/models/page_size_model'
require 'caracal/core/models/relationship_model'
require 'caracal/core/models/style_model'
require 'caracal/core/file_name'
require 'caracal/core/fonts'
require 'caracal/core/list_styles'
require 'caracal/core/page_numbers'
require 'caracal/core/page_settings'
require 'caracal/core/relationships'
require 'caracal/core/styles'
require 'caracal/core/text'

# renderers
require 'caracal/renderers/xml_renderer'
require 'caracal/renderers/app_renderer'
require 'caracal/renderers/content_types_renderer'
require 'caracal/renderers/core_renderer'
require 'caracal/renderers/document_renderer'
require 'caracal/renderers/fonts_renderer'
require 'caracal/renderers/footer_renderer'
require 'caracal/renderers/numbering_renderer'
require 'caracal/renderers/relationships_renderer'
require 'caracal/renderers/settings_renderer'
require 'caracal/renderers/styles_renderer'

# document
require 'caracal/document'
