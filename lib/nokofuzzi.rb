require 'nokogiri'

module Nokogiri
  module XML
    class Document
      def each_missing
        self.xpath('//*').map { |xml_node| xml_node.path }.each do |xpath|
          xml_dup = self.dup
          xml_node = xml_dup.xpath(xpath)
          xml_node_xml = xml_node.to_xml
          xml_node.remove
          yield(xml_node_xml, xml_dup.to_xml)
        end
      end
      def each_leaf_missing
        # TODO
      end
      def each_leaf_fuzzed
        # TODO
      end
      def without_xpath(xpath)
        xml_dup = self.dup
        xml_dup.xpath(xpath).each do |xml_node|
          xml_node.remove
        end
        xml_dup
      end
    end
  end
end
