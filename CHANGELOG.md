#### v1.4.1

* Bug Fixes
  * Corrected rowspan logic to handle all cases. (@martinsp)


#### v1.4.0

* Enhancements
  * Changed `file_name` method to accept absolute and relative paths. (@jdugan)
  * Added instance save method so documents can be created via commands instead of blocks, if desired. (@jdugan)
  * Removed extra paragraph tag inserted after tables; added logic to ensure final tag of table cells is always a paragraph. (@jdugan)


#### v1.3.0

* Enhancements
  * Added proper text highlighting. Colors are limited so we left :bgcolor option. (@rmarone)
  * Added bookmarks and internal links. (@rmarone)


#### v1.2.0

* Enhancements
  * Added colspan and rowspan functionality to table styling feature. (@ViktorKopychko)


#### v1.1.2

* Enhancements
  * Added font size options for page numbers. (@cfacello)


#### v1.1.1

* Enhancements
  * Added character styles. (@xerespm)


#### v1.1.0

* Enhancements
  * Corrected how renderers output namespaced nodes to ensure jruby compliance. (HUGE thank you to @henrychung for researching and implementing this).


#### v1.0.13

* Bug Fixes
  * Corrected bug where lists were no longer multi-line. (@jdugan h/t @StochasticSpring).


#### v1.0.12

* Bug Fixes
  * Removed unintended use of Active Support method in footer renderer. (@jdugan).


#### v1.0.11

* Bug Fixes
  * Cleaned up experimental feature for iframes. (@jdugan).


#### v1.0.10

* Enhancements
  * Added experimental feature for iframes. (@jdugan).


#### v1.0.8

* Enhancements
  * Added indentation controls to paragraph commands (@avolochnev).


#### v1.0.7

* Enhancements
  * Added an :orientation option to :page_size so print jobs work as expected (@jdugan h/t @swedishpotato).


#### v1.0.6

* Bug Fixes
  * Changed Paragraph and Table Cell Models slightly to allow syntax flexibility with respect to options (@jdugan).


#### v1.0.5

* Enhancements
  * Added vertical alignment (@ykonovets).


#### v1.0.4

* Enhancements
  * Changed tilt dependency to be less restrictive (@jdugan).


#### v1.0.3

* Enhancements
  * Added custom properties (@davidtolsma).
  * Added page breaks to paragraph model sub-functions (@jdugan).


#### v1.0.2

* Enhancements
  * Corrected image markup to support Word 2007 (@Alnoroid).


#### v0.3.0

* Deprecations
  * The :style attribute is no longer allowed on text and link commands. Use :font, :size, etc. instead (@jdugan).


#### v0.2.1

* Enhancements
  * Added :caps attribute to paragraph styles (@jensljungblad).
  * Change table model to allow TableCellModel to be subclassed (@gh4me).


#### v0.2.0

* Enhancements
	* Implemented true line breaks within paragraphs (@Linuus).
	* Converted paragraph command to accept/allow blank content (@Linuus).
	* Allowed :top and :bottom attributes to be set on default paragraph style (@jdugan).


* Deprecations
	* Line breaks are no longer allowed at the document level. Use blank paragraphs instead (@jdugan).


#### v0.1.x

* Enhancements
	* Initial commits. (@jdugan)
