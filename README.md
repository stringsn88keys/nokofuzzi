nokofuzzi
=========

Fuzz testing iterators and extensions for Nokogiri

# Installation

Add this to your Gemfile (in the test group) and run `bundle install`:

``` ruby
gem 'nokofuzzi'
```

# Usage

I have larger plans for methods to attach to the Nokogiri document, but for now there are two:

## each_missing
`each_missing` sets up an "each" iterator that sends you the string xml that was removed, and the new xml string (both from Nokogiri::XML)

``` ruby
existing_xml = Nokogiri::XML('/path/to/xml')

existing_xml.each_missing do |removed_xml, new_xml|
  puts "String representation of the xml removed: #{removed_xml}"
  puts "String representation of the modified xml #{new_xml}"
end
```

## without_xpath
`without_xpath` creates a duplicate of the receiver with all matches for the given xpath removed.

``` ruby
modified_xml = Nokogiri::XML('<a><b></b><c><b></b></c></a>').without_xpath('//b')

puts modified_xml.to_xml # <?xml version="1.0"?><a><c/></a>
```

## set_text_at_xpath(xpath, text)
`set_text_at_xpath` replaces the text for a node (as well as contents below that node)

``` ruby
modified_xml = Nokogiri::XML('<a><b></b><c><b></b></c></a>').set_text_at_xpath('//c', "HI")

puts modified_xml.to_xml # <?xml version="1.0"?><a><b/><c>HI</c></a>
```

## fuzz_at_xpath(xpath)
`fuzz_at_xpath` passes each node matching the xpath to a given block which contains the operations to 
perform on the node

``` ruby
modified_xml = Nokogiri::XML('<a><b>HI</b><c><b>HI</b></c></a>').fuzz_at_xpath do |node|
  node.content = "-- #{node.text} --"
end
```

puts modified_xml.to_xml # <?xml version="1.0"?><a><b>-- HI --</b><c><b>-- HI --</b></c></a>
