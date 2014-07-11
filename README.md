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
Specifies the name of the application that generated the document. *This file is generated automatically by the library based on other user directives.*

**docProps/core.xml**  
Specifies the title of the document. *This file is generated automatically by the library based on other user directives.*

**word/_rels/document.xml.rels**  
Defines an internal identifier and type with all external content items (images, links, etc). *This file is generated automatically by the library based on other user directives.*

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
Pairs extensions and XML files with schema content types so Word can parse them correctly. *This file is generated automatically by the library based on other user directives.*


## Syntax

In the following examples, the variable `docx` is assumed to be an instance of Caracal::Package.

    docx = Caracal::Package.new('Example Document')

### File Name

The final output document's title can be set at initialization or via the `name=` method.

    docx = Caracal::Document.new('Example Document')
    
    docx.name = 'Different Name'
    
### Fonts

Fonts are added to the font table file by calling the `font` method and passing the name of the font.  At present, Caracal only supports declaring the primary font name.

    docx.font 'Arial'
    docx.font 'Droid Serif'
    
These commands will produce the following `fontTable.xml` file contents:

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <w:fonts xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:sl="http://schemas.openxmlformats.org/schemaLibrary/2006/main" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart" xmlns:lc="http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas" xmlns:dgm="http://schemas.openxmlformats.org/drawingml/2006/diagram">
      <w:font w:name="Arial"/>
      <w:font w:name="Droid Serif"/>
    </w:fonts> 
    
### Styles

### Text

### Links

Links can be added inside paragraphs by using the `link` method.  The method accepts several optional parameters for controlling the style and behavior of the rule.

    # no options
    docx.p do
      link 'Example Text', 'https://wwww.example.com'
    end
    
    # options via block
    p do
      link 'Example Text', 'https://wwww.example.com' do
        color   '0000ff'        # controls the color of the text. defaults to 1155cc.
        line    :none           # controls the style of the underline. defaults to :single.
        target  :external       # controls the context of the link. defaults to :external.
      end
    end
    
    # options via hash
    p do
      link 'Example Text With Class', 'https://wwww.example.com', color: '0000ff', line: :none, target: :external
    end

The `link` command with default properties will produce the following XML output:

    <w:hyperlink r:id="rId1">
      <w:r w:rsidRPr="00000000" w:rsidR="00000000" w:rsidDel="00000000">
        <w:rPr>
          <w:color w:val="1155cc"/>
          <w:u w:val="single"/>
          <w:rtl w:val="0"/>
        </w:rPr>
        <w:t xml:space="preserve">Example Text</w:t>
      </w:r>
    </w:hyperlink>

*Caracal will automatically generate the relationship entries required by the OpenXML standard.*

    <Relationship Target="https://www.example.com" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" TargetMode="External" Id="rId1"/>
    
### Images

### Rules

Horizontal rules can be added using the `hr` method.  The method accepts several optional parameters for controlling the style of the rule.  

    # no options
    docx.hr                 # defaults to a thin, single line.
    
    # options via block
    docx.hr do
      color   '333333'      # controls the color of the line. defaults to auto.
      line    :double       # controls the line style (single or double). defaults to single.
      size    16            # controls the thickness of the line. defaults to 4.
      spacing 4             # controls the spacing around the line. defaults to 1.
    end
    
    # options via hash
    docx.hr color: '333333', size: 8, spacing: 2, style: :double   
    
The `hr` command with default properties will produce the following XML output:

    <w:p w:rsidP="00000000" w:rsidRPr="00000000" w:rsidR="00000000" w:rsidDel="00000000" w:rsidRDefault="00000000">
      <w:pPr>
        <w:pBdr>
          <w:top w:color="auto" w:space="1" w:val="single" w:sz="4"/>
        </w:pBdr>
      </w:pPr>
    </w:p>

### Lists

### Tables


## Defaults


## Contributing

1. Fork it ( https://github.com/ibpinc/caracal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Why is It Called Caracal?

Because my son likes caracals. :)


## Inspiration

A tip of the hat to the wonderful PDF generation library [Prawn](https://github.com/prawnpdf/prawn).


## License

Copyright (c) 2014 Plia Systems, Inc

[MIT License](https://github.com/ibpinc/caracal/blob/master/LICENSE.txt)
