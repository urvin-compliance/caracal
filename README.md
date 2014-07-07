# Caracal

Caracal is a ruby library for dynamically creating professional-quality Microsoft Word documents (.docx) using an HTML-style syntax.


## Installation

Add this line to your application's Gemfile:

    gem 'caracal'

Then execute:

    $ bundle install


## Overview

Many people don't know that .docx files are little more than a zipped collection of XML documents that follow the OfficeOpen XML (OpenXML or OOXML) standard.  This means constructing a .docx file from scratch actually requires the creation of several files.  Caracal abstracts users from this process by providing a simple set of Ruby commands and HTML-style syntax for generating Word content.

For each Caracal request, the following document structure will be created and zipped into the final output file:

    example.docx
      |- _rels
      |- docProps
        |- app.xml
        |- core.xml
      |- word
        |- _rels
          |- document.xml.rels
        |- media
          |- image001.png
          |- image002.png
          ...
        |- document.xml
        |- fontTable.xml
        |- footer.xml
        |- numbering.xml
        |- settings.xml
        |- styles.xml
      |- [Content_Types].xml

### File Descriptions

The following provides a brief description for each component of the final document:

**_rels/**  
Not populated. Required to comply with OpenXML schema.

**docProps/app.xml**  
Specifies the name of the application that generated the document.

**docProps/core.xml**  
Specifies the title of the document.

**word/_rels/document.xml.rels**  
Defines an internal identifier and type with all external content items (images, links, etc). This file is generated automatically by the library based on other user directives.

**word/media/**  
A collection of media assets (each of which should have an entry in document.xml.rels).

**word/document.xml**  
The main content file for the document.

**word/fontTable.xml**  
Specifies the fonts used in the document.

**word/footer.xml**  
Defines the formatting of the document footer.

**word/numbering.xml**  
Defines ordered and unordered list styles.

**word/settings.xml**  
Defines global directives for the document (e.g., whether to show background images, tab widths, etc). Also, establishes compatibility with older versions on Word.

**word/styles.xml**  
Defines all paragraph and table styles used through the document.  Caracal adds a default set of styles to match its HTML-like content syntax.  These defaults can be overridden.
 
**[Content_Types].xml**  
Pairs extensions and XML files with schema content types so Word can parse them correctly. This file is generated automatically by the library based on other user directives.


## Contributing

1. Fork it ( https://github.com/ibpinc/caracal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Inspiration

A tip of the hat to the wonderful PDF generation library [Prawn](https://github.com/prawnpdf/prawn).


## License

Copyright (c) 2014 Plia Systems, Inc

[MIT License](https://github.com/ibpinc/caracal/blob/master/LICENSE.txt)
