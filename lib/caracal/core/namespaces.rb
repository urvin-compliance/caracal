require 'caracal/core/models/namespace_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to registering and
    # retrieving namespaces.
    #
    module Namespaces
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------

          def self.default_namespaces
            [
              { prefix: 'xmlns:mc',   href: 'http://schemas.openxmlformats.org/markup-compatibility/2006'             },
              { prefix: 'xmlns:o',    href: 'urn:schemas-microsoft-com:office:office'                                 },
              { prefix: 'xmlns:r',    href: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'     },
              { prefix: 'xmlns:m',    href: 'http://schemas.openxmlformats.org/officeDocument/2006/math'              },
              { prefix: 'xmlns:v',    href: 'urn:schemas-microsoft-com:vml'                                           },
              { prefix: 'xmlns:wp',   href: 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing'  },
              { prefix: 'xmlns:w10',  href: 'urn:schemas-microsoft-com:office:word'                                   },
              { prefix: 'xmlns:w',    href: 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'            },
              { prefix: 'xmlns:wne',  href: 'http://schemas.microsoft.com/office/word/2006/wordml'                    },
              { prefix: 'xmlns:sl',   href: 'http://schemas.openxmlformats.org/schemaLibrary/2006/main'               },
              { prefix: 'xmlns:a',    href: 'http://schemas.openxmlformats.org/drawingml/2006/main'                   },
              { prefix: 'xmlns:pic',  href: 'http://schemas.openxmlformats.org/drawingml/2006/picture'                },
              { prefix: 'xmlns:c',    href: 'http://schemas.openxmlformats.org/drawingml/2006/chart'                  },
              { prefix: 'xmlns:lc',   href: 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas'           },
              { prefix: 'xmlns:dgm',  href: 'http://schemas.openxmlformats.org/drawingml/2006/diagram'                }
            ]
          end


          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          #============== ATTRIBUTES ==========================

          def namespace(options={}, &block)
            model = Caracal::Core::Models::NamespaceModel.new(options, &block)
            if model.valid?
              ns = register_namespace(model)
            else
              raise Caracal::Errors::InvalidModelError, 'namespace must specify the :prefix and :href attributes.'
            end
            ns
          end


          #============== GETTERS =============================

          def namespaces
            @namespaces ||= []
          end

          def find_namespace(prefix)
            namespaces.find { |ns| ns.matches?(prefix) }
          end


          #============== REGISTRATION ========================

          def register_namespace(model)
            unless (ns = find_namespace(model.namespace_prefix))
              namespaces << model
              ns = model
            end
            ns
          end

          def unregister_namespace(prefix)
            if (ns = find_namespace(prefix))
              namespaces.delete(ns)
            end
          end

        end
      end
    end

  end
end
