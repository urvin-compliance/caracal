# Caracal

[![Gem Version](http://img.shields.io/gem/v/caracal.svg?style=flat)](https://rubygems.org/gems/caracal)


## Overview

Caracal is a ruby library for dynamically creating professional-quality Microsoft Word documents using an HTML-style syntax.

Caracal is not a magical HTML to Word translator. Instead, it is a markup language for generating Office Open XML (OOXML). Programmers create Word documents by issuing a series of simple commands against a document object. When the document is rendered, Caracal takes care of translating those Ruby commands into the requisite OOXML. At its core, the library is essentially a templating engine for the `:docx` format.

Or, said differently, if you use [Prawn](https://github.com/prawnpdf/prawn) for PDF generation, you'll probably like Caracal. Only you'll probably like it better. :)

Please see the [caracal-example](https://github.com/trade-informatics/caracal-example) repository for
a working demonstration of the library's capabilities.


## Teaser

How would you like to make a Word document like this?

```ruby
Caracal::Document.save 'example.docx' do |docx|
  # page 1
  docx.h1 'Page 1 Header'
  docx.hr
  docx.p
  docx.h2 'Section 1'
  docx.p  'Lorem ipsum dolor....'
  docx.p
  docx.table @my_data, border_size: 4 do
    cell_style rows[0], background: 'cccccc', bold: true
  end

  # page 2
  docx.page
  docx.h1 'Page 2 Header'
  docx.hr
  docx.p
  docx.h2 'Section 2'
  docx.p  'Lorem ipsum dolor....'
  docx.ul do
    li 'Item 1'
    li 'Item 2'
  end
  docx.p
  docx.img 'https://www.example.com/logo.png', width: 500, height: 300
end
```

**You can!** Read on.


## Why is Caracal Needed?

We created Caracal to satisfy a genuine business requirement.  We were working on a system that produced a periodic PDF report and our clients asked if the report could instead be generated as a Word document, which would allow them to perform edits before passing the report along to their clients.

Now, as you may have noticed, the Ruby community has never exactly been known for its enthusiastic support of Microsoft standards. So it might not surprise you to learn that the existing options on Rubygems for Word document generation were limited.  Those libraries, by and large, fell into a couple of categories:

* **HTML to Word Convertors**
We understand the motivating idea here (two output streams from one set of instructions), but the reality is the number of possible permutations of nested HTML tags is simply too great for this strategy to ever work for anything other than the simplest kinds of documents. Most of these libraries rely on a number of undocumented assumptions about the structure of your HTML (which undermines the whole value proposition of a convertor) and fail to support basic features of a professional-quality Word document (e.g., images, lists, tables, etc). The remaining libraries simply did not work at all.

* **Weekend Projects**
We also found a number of inactive projects that appeared to be experiments in the space. Obviously, these libraries were out of the question for a commercial product.

What we wanted was a Prawn-style library for the `:docx` format. In the absence of an active project organized along those lines, we decided to write one.


## Design

Caracal is designed to separate the process of parsing and collecting rendering instructions from the process of rendering itself.

First, the library consumes all programmer instructions and organizes several collections of data models that capture those instructions. These collections are ordered and nested exactly as the instructions we given. Each model contains all the data required to render it and is responsible for declaring itself valid or invalid.

*Note: Some instructions create more than one model. For example, the `img` method both appends an `ImageModel` to the main contents collection and determines whether or not a new `RelationshipModel` should be added to the relationships collection.*

Only after all the programmer instructions have been parsed does the document attempt to render the data to XML. This strategy gives the rendering process a tremendous amount of flexibility in the rare cases where renderers combine data from more than one collection.


## File Structure

You may not know that .docx files are simply a zipped collection of XML documents that follow the OOXML standard. (We didn't, in any event.) This means constructing a .docx file from scratch actually requires the creation of several files.  Caracal abstracts users from this process entirely.

For each Caracal request, the following document structure will be created and zipped into the final output file:

```
    example.docx
      |- _rels
      	|- .rels
      |- docProps
        |- app.xml
        |- core.xml
        |- custom.xml
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
```


## File Descriptions

The following provides a brief description for each component of the final document:

**_rels/.rels**
Defines an internal identifier and type for global content items. *This file is generated automatically by the library based on other user directives.*

**docProps/app.xml**
Specifies the name of the application that generated the document. *This file is generated automatically by the library based on other user directives.*

**docProps/core.xml**
Specifies the title of the document. *This file is generated automatically by the library based on other user directives.*

**docProps/custom.xml**
Specifies the custom document properties. *This file is generated automatically by the library based on other user directives.*

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


## Units

OpenXML properties are specified in several different units, depending on which attribute is being set.

**Points**
Most spacing declarations are measured in full points.

**Half Points**
All font sizes are measure in half points.  A font size of 24 is equivalent to 12pt.

**Eighth Points**
Borders are measured in 1/8 points.  A border size of 4 is equivalent to 0.5pt.

**Twips**
A twip is 1/20 of a point.  Word documents are printed at 72dpi.  1in == 72pt == 1440 twips.

**Pixels**
In Word documents, pixels are equivalent to points.

**EMUs (English Metric Unit)**
EMUs are a virtual unit designed to facilitate the smooth conversion between inches, millimeters, and pixels for images and vector graphics.  1in == 914400 EMUs == 72dpi x 100 x 254.

At present, Caracal expects values to be specified in whichever unit OOXML requires. This is admittedly difficult for new Caracal users. Eventually, we'll probably implement a utility object under the hood to convert user-specified units into the format expected by OOXML.


## Syntax Flexibility

Generally speaking, Caracal commands will accept instructions via any combination of a parameters hash and/or a block.  For example, all of the following commands are equivalent.

```ruby
docx.style id: 'special', name: 'Special', size: 24, bold: true

docx.style id: 'special', size: 24 do
  name 'Special'
  bold true
end

docx.style do
  id   'special'
  name 'Special'
  size 24
  bold true
end
```

Parameter options are always evaluated before block options. This means if the same option is provided in the parameter hash and in the block, the value in the block will overwrite the value from the parameter hash. Tread carefully.


## Validations

All Caracal models perform basic validations on their attributes, but this is, without question, the least sophisticated part of the library at present.

In forthcoming versions of Caracal, we'll be looking to expand the `InvalidModelError` class to provide broader error reporting abilities across the entire library.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'caracal'
```

Then execute:

```bash
bundle install
```


## Commands

In the following examples, the variable `docx` is assumed to be an instance of Caracal::Document.

```ruby
docx = Caracal::Document.new('example_document.docx')
```

Most code examples show optional values being passed in a block.  As noted above, you may also pass these options as a parameter hash or as a combination of a parameter hash and a block.


### File Name

The final output document's title can be set at initialization or via the `file_name` method.

```ruby
docx = Caracal::Document.new('example_document.docx')

docx.file_name 'different_name.docx'
```

The current document name can be returned by invoking the `name` method:

```ruby
docx.name    # => 'example_document.docx'
```

*The default file name is caracal.docx.*


### Page Size

Page dimensions can be set using the `page_size` method.  The method accepts two parameters for controlling the width and height of the document.
It also accepts a third parameter for setting the page orientation.  If you want landscape orientation, you need to change both the page
dimensions and the orientation explicitly.

*Page size defaults to United States standard A4, portrait dimensions (8.5in x 11in).*

```ruby
docx.page_size do
  width       15840       # sets the page width. units in twips.
  height      12240       # sets the page height. units in twips.
  orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
end
```

Both the `width` and `height` attributes require positive integer values.


### Page Margins

Page margins can be set using the `page_margins` method.  The method accepts four parameters for controlling the margins of the document.

*Margins default to 1.0in for all sides.*

```ruby
docx.page_margins do
  left    720     # sets the left margin. units in twips.
  right   720     # sets the right margin. units in twips.
  top     1440    # sets the top margin. units in twips.
  bottom  1440    # sets the bottom margin. units in twips.
end
```

All attributes require positive integer values. Additionally, the combined size of the margins on either axis cannot exceed the page size on that axis (e.g., the sum of the `left` and `right` values must be less than the `page_width`).


### Page Breaks

Page breaks can be added via the `page` method.  The method accepts no parameters.

```ruby
docx.page     # starts a new page.
```


### Page Numbers

Page numbers can be added to the footer via the `page_numbers` method.  The method accepts optional parameters for controlling the alignment, label and size of the text.

*Page numbers are turned off by default.*

```ruby
docx.page_numbers true do
  align        :right  # sets the alignment. accepts :left, :center, and :right.
  label        'Page'  # sets the text that will go to the left of the page number. Defaults to nil.
  size:        24      # sets the label and number size simultaneously. units in half points.
  label_size:  24      # sets the label size only. units in half points.
  number_size: 20      # sets the number size only. units in half points.
end
```

The `size` option and the `label_size` and `number_size` options are mutually exclusive.


### Fonts

Fonts are added to the font table file by calling the `font` method and passing the name of the font.

*At present, Caracal only supports declaring the primary font name.*

```ruby
docx.font do
  name 'Droid Serif'
end
```


### Styles

Paragraph style classes can be defined using the `style` method.  The method accepts several optional parameters to control the rendering of text using the style.

```ruby
docx.style do
  id              'Heading1'  # sets the internal identifier for the style.
  name            'heading 1' # sets the friendly name of the style.
  type            'paragraph' # sets the style type. accepts `paragraph` or `character`
  font            'Palantino' # sets the font family.
  color           '333333'    # sets the text color. accepts hex RGB.
  size            28          # sets the font size. units in half points.
  bold            false       # sets the font weight.
  italic          false       # sets the font style.
  underline       false       # sets whether or not to underline the text.
  caps            false       # sets whether or not text should be rendered in all capital letters.
  align           :left       # sets the alignment. accepts :left, :center, :right, and :both.
  line            360         # sets the line height. units in twips.
  top             100         # sets the spacing above the paragraph. units in twips.
  bottom          0           # sets the spacing below the paragraph. units in twips.
  indent_left     360         # sets the left indent. units in twips.
  indent_right    360         # sets the rights indent. units in twips.
  indent_first    720         # sets the first line indent. units in twips.
end
```

Caracal establishes a standard set of default styles for every document. Default styles can be overridden by issuing a `style` command referencing an existing id. Default style ids are:

* Normal
* Title
* Subtitle
* Heading1
* Heading2
* Heading3
* Heading4
* Heading5
* Heading6

Styles are declared as `paragraph` by default. If you need to adjust inline text styles repeatedly, you might
benefit from defining a `character` style.  Paragraph styles affects all text runs within a paragraph; character styles
are used to style individual runs within a larger text block.

One-off inline text styling can also be accomplished by passing the `text` command override arguments (see below).


### Custom Properties

Custom document properties can be defined using the `custom_property` method.  The method accepts a few required parameters to control the definition of the custom property.

```ruby
docx.custom_property do
  name      'property name 1' # sets the name of the custom property.
  value     'test'            # sets the value of the custom property.
  type      :text             # sets the property type. accepts :text, :number, :date, :boolean.
end
```

The `name`, `value`, and `height` attributes are required. If any of the attributes are missing, the custom property will not be created.

A document may have zero or many custom properties. Each custom property's `name` should be unique with its `type`.



### Paragraphs

Paragraph text can be added using the `p` method.  The method accepts several optional parameters for controlling the style and behavior of the paragraph.

In its simple form, a paragraph accepts a text string and formatting options.

```ruby
docx.p 'Sample text.'

docx.p 'Sample text.', style: 'custom_style'

docx.p 'Sample text.' do
  style           'custom_style'    # sets the paragraph style. generally used at the exclusion of other attributes.
  align           :left             # sets the alignment. accepts :left, :center, :right, and :both.
  color           '333333'          # sets the font color.
  size            32                # sets the font size. units in 1/2 points.
  bold            true              # sets whether or not to render the text with a bold weight.
  italic          false             # sets whether or not render the text in italic style.
  underline       false             # sets whether or not to underline the text.
  bgcolor         'cccccc'          # sets the background color.
  highlight_color 'yellow'          # sets the highlight color. only accepts OOXML enumerations. see http://www.datypic.com/sc/ooxml/t-w_ST_HighlightColor.html.
  vertical_align  'superscript'     # sets the vertical alignment.
end
```

More complex paragraph runs can be accomplished by using the `text` method instead the paragraph's block.

```ruby
docx.p do
  text 'Here is a sentence with a '
  link 'link', 'https://www.example.com'
  text ' to something awesome', font: 'Courier New', color: '555555', size: 32, bold: true, italic: true, underline: true, bgcolor: 'cccccc'
  text '.'
  br
  text 'This text follows a line break and uses a character style instead of overrides.', style: 'MyCharStyle'
  page
end
```


### Links

Links can be added inside paragraphs using the `link` method.  The method accepts several optional parameters for controlling the style and behavior of the rule.

```ruby
p do
  link 'Example Text', 'https://wwww.example.com' do
    internal        false             # sets whether or not the link references an external url. defaults to false.
    font            'Courier New'     # sets the font name to use. defaults to nil.
    color           '0000ff'          # sets the color of the text. defaults to 1155cc.
    size            24                # sets the font size. units in half-points. defaults to nil.
    bold            false             # sets whether or not the text will be bold. defaults to false.
    italic          false             # sets whether or not the text will be italic. defaults to false.
    underline       true              # sets whether or not the text will be underlined. defaults to true.
    bgcolor         'cccccc'          # sets the background color.
    highlight_color 'yellow'          # sets the highlight color. only accepts OOXML enumerations. see http://www.datypic.com/sc/ooxml/t-w_ST_HighlightColor.html.
  end
end
```


### Bookmarks

Bookmarks can be added directly to the document or inside paragraph blocks using the `bookmark_start` and `bookmark_end`
methods. Bookmarks can be inserted at the document-level to describe section headings, etc. or inside
of a paragraph block for fine-grained linking.

```ruby
# document-level bookmark
dox.bookmark_start id: 's1', name: 'section1'
docx.h2 'Section Heading'
docx.bookmark_end id: 's1'
docx.p  'Section content.'

# pargraph-level bookmark
docx.h2 'Section Heading'
docx.p do
  text 'Pretend this paragraph has a lot of text and we want to bookmark '
  bookmark_start id: 'p1', name: 'phrase1'
  text 'a single phrase'
  bookmark_end id: 'p1'
  text ' inside the larger block.'
end
```

Bookmarks work in conjunction with internal links.  Please see above.


### Headings

Headings can be added using the `h1`, `h2`, `h3`, `h4`, `h5`, and `h6` methods.  Headings are simply paragraph commands with a specific style set, so anything you can do with a paragraph is available to a heading.

```ruby
docx.h1 'Heading'

docx.h2 do
  text 'Heading with a '
  link 'Link', 'http://www.google.com'
  text '.'
end
```


### Rules

Horizontal rules can be added using the `hr` method.  The method accepts several optional parameters for controlling the style of the rule.

```ruby
docx.hr do
  color   '333333'   # sets the color of the line. defaults to auto.
  line    :double    # sets the line style (single or double). defaults to single.
  size    8          # sets the thickness of the line. units in 1/8 points. defaults to 4.
  spacing 4          # sets the spacing around the line. units in 1/8 points. defaults to 1.
end
```


### Line Breaks

Line breaks can be added via the `br` method inside paragraphs.

```ruby
docx.p do
  text 'This sentence precedes the line break.'
  br
  text 'This sentence follows the line break.'
end
```

Line breaks only work instead paragraph-like commands. If you want to create an empty line between two paragraphs, use an empty paragraph instead.

```ruby
docx.p
```


### Lists

Ordered lists can be added using the `ol` and `li` methods.  The `li` method substantially follows the same rules as the the `p` method.

```ruby
docx.ol do
  li 'First item'
  li do
    text 'Second item with a '
    link 'link', 'http://www.google.com'
    text '.'
    br
    text 'This sentence follows a line break.'
  end
end
```

Similarly, unordered lists can be added using the `ul` and `li` methods.

```ruby
docx.ul do
  li 'First item'
  li do
    text 'Second item with a '
    link 'link', 'http://www.google.com'
    text '.'
    br
    text 'This sentence follows a line break.'
  end
end
```

Lists can nested as many levels deep as you wish and mixed in any combination.

```ruby
docx.ul do
  li 'First item'
  li 'Second item' do
    ol do
      li 'SubItem 1'
      li 'SubItem 2' do
        ol do
          li 'SubSubItem'
        end
      end
    end
  end
end
```


### List Styles

List styles can be defined using the `list_style` command. The method accepts several optional parameters to control the rendering of list items using the style.

*Caracal will automatically define 9 levels of default styles for both ordered and unordered lists.*

```ruby
docx.list_style do
  type    :ordered    # sets the type of list. accepts :ordered or :unordered.
  level   2           # sets the nesting level. 0-based index.
  format  'decimal'   # sets the list style. see OOXML docs for details.
  value   '%3.'       # sets the value of the list item marker. see OOXML docs for details.
  align   :left       # sets the alignment. accepts :left, :center: and :right. defaults to :left.
  indent  400         # sets the indention of the marker from the margin. units in twips.
  left    800         # sets the indention of the text from the margin. units in twips.
  start   2           # sets the number at which item counts begin. defaults to 1.
  restart 1           # sets the level that triggers a reset of numbers at this level. 1-based index. 0 means numbers never reset. defaults to 1.
end
```


### Images

Images can be added by using the `img` method.  The method accepts several optional parameters for controlling the style and placement of the asset.

*Caracal will automatically embed the image in the Word document.*

```ruby
docx.img 'https://www.example.com/logo.png' do
  data    raw_data  # sets the file data directly instead of opening the url
  width   396       # sets the image width. units specified in pixels.
  height  216       # sets the image height. units specified in pixels.
  align   :right    # controls the justification of the image. default is :left.
  top     10        # sets the top margin. units specified in pixels.
  bottom  10        # sets the bottom margin. units specified in pixels.
  left    10        # sets the left margin. units specified in pixels.
  right   10        # sets the right margin. units specified in pixels.
end
```

*Note: If you provide the image data, you should still supply a URL. I know this
is a bit hacky, but it allows the library to key the image more effectively and
Caracal needs a file extension to apply to the renamed media file. This seemed
the simplest solution to both problems.*


### Tables

```
Release v1.4.0 deprecated the behaviour of automatically adding an empty paragraph tag after every table. If you are upgrading from an older version of the library, you will need to control such spacing in your own code.
```

Tables can be added using the `table` method.  The method accepts several optional paramters to control the layout and style of the table cells.

The `table` command accepts data in the form of a two-dimensional arrays. This corresponds to rows and column cells within those rows.  Each array item can be a string, a Hash of options, a Proc (which will be passed as a block), or a `TableCellModel`.  The command will normalize all array contents into a two-dimensional array of `TableCellModel` instances.

```ruby
docx.table [['Header 1','Header 2'],['Cell 1', 'Cell 2']] do
  border_color   '666666'   # sets the border color. defaults to 'auto'.
  border_line    :single    # sets the border style. defaults to :single. see OOXML docs for details.
  border_size    4          # sets the border width. defaults to 0. units in twips.
  border_spacing 4          # sets the spacing around the border. defaults to 0. units in twips.
end
```

Table borders can be further styled with position-specific options. Caracal supports styling the top, bottom, left, right, inside horizontal, and inside vertical borders with the `border_top`, `border_bottom`, `border_left`, `border_right`, `border_horizontal`, and `border_vertical`, respectively. Options have the same meaning as those set at the table level.

```ruby
docx.table data, border_size: 4 do
  border_top do
    color   '000000'
    line    :double
    size    8
    spacing 2
  end
end
```

Table cells can be styles using the `cell_style` method inside the table's block.  The method will attempt to apply any specified options against the collection of `TableModelCell` instances provided in the first argument.  Any improper options will fail silently.

*As a convenience, the table provides the methods `rows`, `cols`, and `cells` to facilitate building the first argument.*

The example will style the first row as a header and establish a fixed width for the first column.

```ruby
docx.table [['Header 1','Header 2'],['Cell 1', 'Cell 2']], border_size: 4 do
  cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
  cell_style cols[0], width: 6000
end
```

It is possible to merge cells vertically and horizontally using the `rowspan` and `colspan` options in `cell_style` method e.g.

```ruby
docx.table [['11', '1213', '14'], ['21', '22', '23', '24']] do
  cell_style rows[0][0], rowspan: 2
  cell_style rows[0][1], colspan: 2
  cell_style rows[0][2], rowspan: 2
end
```

*Note: content of cells 21 and 24 will disappear*

### Table Cells

If your table contains more complex data (multiple paragraphs, images, lists, etc.), you will probably want to instantiate your `TableCellModel` instances directly.  With the exception of page breaks, table cells can contain anything the document can contain, including another table.

```ruby
c1 = Caracal::Core::Models::TableCellModel.new do
  background 'cccccc'    # sets the background color. defaults to 'ffffff'.
  margins do
    top                  # sets the top margin. defaults to 100. units in twips.
    bottom               # sets the bottom margin. defaults to 100. units in twips.
    left                 # sets the left margin. defaults to 100. units in twips.
    right                # sets the right margin. defaults to 100. units in twips.
  end

  p 'This is a sentence above an image.'
  p
  img 'https://www.example.com/logo.png', width: 200, height: 100
end
```


### Nested Tables

Because table cells can contain anything that can be added to the document, **tables can be nested to achieve whatever layout goals you want to achieve**.

```ruby
row1 = ['Header 1', 'Header 2', 'Header 3']
row2 = ['Cell 1', 'Cell 2', 'Cell 3']
row3 = ['Cell 4', 'Cell 5', 'Cell 6']
row4 = ['Footer 1', 'Footer 2', 'Footer 3']
c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 0, bottom: 100, left: 0, right: 200 } do
  table [row1, row2, row3, row4], border_size: 4 do
    cell_style rows[0],  bold: true, background: '3366cc', color: 'ffffff'
    cell_style rows[-1], bold: true,   background: 'dddddd'
    cell_style cells[3], italic: true, color: 'cc0000'
    cell_style cells,    size: 18, margins: { top: 100, bottom: 0, left: 100, right: 100 }
  end
end
c2 = Caracal::Core::Models::TableCellModel.new margins: { top: 0, bottom: 100, left: 0, right: 200 } do
  p 'This layout uses nested tables (the outer table has no border) to provide a caption to the table data.'
end

docx.table [[c1,c2]] do
  cell_style cols[0], width: 6000
end
```


## Experimental Features

### IFrames

You can include an external Word document into your working Caracal document by specifying a URL or by supplying the data directly.

*It should be noted that the metaphor here is imperfect. Caracal fully includes the external file at the time of insertion. Further changes to the external file will not be reflected in your Caracal output.*

```ruby
# this example loads the file from the internet
docx.iframe url: 'http://www.some-website.org/snippet.docx'

# this example loads the data directly
docx.iframe data: File.read('my/path/to/snippet.docx')
```

Caracal is pretty smart about including the external document, at least as it relates to images. As long as the external
document only uses the feature set Caracal supports natively, you should be okay.

But if the external document uses more advanced Word features, the `iframe` directive may or may not work. Again, a
Word document is really just a dozen or so XML files zipped up with the extension `.docx`.  Most of the commands you issue in a Word document only add OOXML to one of these internal files. But some commands--like inserting an image--modify several of
the internal files. So, when you include an external file, what Caracal is doing under the hood is grabbing the contents
of the main internal XML file and copying that OOXML into the Caracal document's main internal file. Caracal is smart enough
to look for any images in the external file and make the corresponding entries in its own internal files, but if other
advanced features of Word require similar adjustments, Caracal won't know to do that.  Probably those advanced features
will not operate as expected in the parent Caracal document.

Again, this feature is considered experimental.  Use at your own risk/discretion.


## Template Rendering

Caracal includes [Tilt](https://github.com/rtomayko/tilt) integration to facilitate its inclusion in other frameworks.

Rails integration can be added via the [Caracal-Rails](https://github.com/trade-informatics/caracal-rails) gem.


## Using Variables

Lexical scope is a pretty big challenge for Caracal and it often confuses new users. This [closed issue](https://github.com/trade-informatics/caracal/issues/71) covers the discussion both from the user and library persepctive.


## Filing an Issue

Caracal was written for and tested against Word 2010, 2013, and Office365.  It should also open in LibreOffice
with high fidelity.


### Older Versions
If you are using a version of Word that predates 2010, Caracal may or may not work for you. (Probably it won't.)
We don't ever plan to support versions before 2010, but if you choose to embark on that endeavor, we'd be
happy to answer questions and provide what guidance we can. We just won't write any code in that direction.


### Newer Versions

For those using reasonably current versions of Word, please consider the following:

- Before you file an issue, please run the example Caracal project [caracal-example](https://github.com/trade-informatics/caracal-example) in your development environment and
check the output.  This project implements nearly every feature Caracal supports and renders the expected output
correctly.  It can be thought of as a canonical implementation of the library.

- If you don't see your issue in the example project's implementation of the same feature, chances are you
made a mistake in your document's syntax or have an environment-specific, non-caracal problem.

- If you do see the same behavior in the example project, you've probably uncovered a variance in the way
your particular permutation of Windows/Word interprets the OOXML.


### How to Work on a Problem

Caracal is essentially an exercise in reverse engineering OOXML output. When developing features, we
typically start by building the simplest Word document we can that includes the desired behavior.
Then, we change the document extension to .zip, extract the archive, and inspect the resulting OOXML.
Finally, we teach the corresponding renderer to output that OOXML.

It's a tedious process, but it's not nearly as tedious as learning the entire OOXML specification.

The downside is Word changes its expectations about OOXML format with each version, so it can be a bit
of a balancing act to get the OOXML structured for acceptance by all supported versions.

Ultimately, we'll probably need to implement version-specific renderers (i.e., a set of renderers
for 2010/2013, a set for 2016, etc.).


## Contributing

1. Fork it ( https://github.com/trade-informatics/caracal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Why is It Called Caracal?

Because my son likes caracals. :)


## Inspiration

A tip of the hat to the wonderful PDF generation library [Prawn](https://github.com/prawnpdf/prawn).


## License

Copyright (c) 2014 Trade Informatics, Inc

[MIT License](https://github.com/trade-informatics/caracal/blob/master/LICENSE.txt)
