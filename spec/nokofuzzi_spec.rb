require_relative '../lib/nokofuzzi.rb'
describe Nokogiri::XML::Document do

  describe '#without_xpath' do
    let(:source_xml) { Nokogiri::XML('<node><a><c></c></a><b><c></c></b></node>')}
    let(:expected_b_c_xml) { Nokogiri::XML('<node><a><c></c></a><b></b></node>') }
    let(:expected_c_xml) { Nokogiri::XML('<node><a></a><b></b></node>') }
    let(:expected_b_xml) { Nokogiri::XML('<node><a><c></c></a></node>') }
    it "expects removing //b/c to remove the <c> node inside <b>" do
      expect(source_xml.without_xpath('//b/c').to_xml).to eq(expected_b_c_xml.to_xml)
    end
    it "expects removing //c to remove all <c> nodes" do
      expect(source_xml.without_xpath('//c').to_xml).to eq(expected_c_xml.to_xml)
    end
    it "expects removing //b to remove everything <b> node and below" do
      expect(source_xml.without_xpath('//b').to_xml).to eq(expected_b_xml.to_xml)
    end
  end
  describe "#set_text_at_xpath" do
    let(:source_xml) { Nokogiri::XML('<node><a><c></c></a><b><c></c></b></node>')}
    let(:expected_b_c_xml) { Nokogiri::XML('<node><a><c></c></a><b><c>HI</c></b></node>') }
    let(:expected_c_xml) { Nokogiri::XML('<node><a><c>HI</c></a><b><c>HI</c></b></node>') }
    let(:expected_b_xml) { Nokogiri::XML('<node><a><c></c></a><b>HI</b></node>') }

    it "expects removing //b/c to replacing the <c> node text inside <b>" do
      expect(source_xml.set_text_at_xpath('//b/c', "HI").to_xml).to eq(expected_b_c_xml.to_xml)
    end
    it "expects removing //c to replace text for all <c> nodes" do
      expect(source_xml.set_text_at_xpath('//c', "HI").to_xml).to eq(expected_c_xml.to_xml)
    end
    it "expects removing //b to replace text for the <b> node and remove the <c> node" do
      expect(source_xml.set_text_at_xpath('//b', "HI").to_xml).to eq(expected_b_xml.to_xml)
    end

  end

  describe "#fuzz_at_xpath" do
    let(:source_xml) { Nokogiri::XML('<node><a><c>HI</c></a><b><c>BYE</c></b></node>')}
    let(:expected_xml) { Nokogiri::XML('<node><a><c>_HI</c></a><b><c>_BYE</c></b></node>') }

    it "expects fuzzing //c should make the modification in the block on all //c nodes." do
      expect(
        source_xml.fuzz_at_xpath("//c") do |node|
          node.content = "_#{node.text}"
        end.to_xml
      ).to eq(expected_xml.to_xml)
    end
  end

  describe '#each_missing' do
    let(:source_xml) { Nokogiri::XML('<node><a></a><b><c></c></b></node>')}
    let(:altered_xmls) do
      xmls = []
      source_xml.each_missing do |node, xml|
        xmls << xml
      end
      xmls
    end
    let(:removed_nodes) do
      removed_nodes = []
      source_xml.each_missing do |node, xml|
        removed_nodes << node
      end
      removed_nodes.map { |string| Nokogiri::XML(string).to_xml }
    end
    let(:expected_removed_nodes) do
      [
        '<node><a></a><b><c></c></b></node>',
        '<a></a>',
        '<b><c></c></b>',
        '<c></c>'
      ]
    end
    let(:expected_altered_xmls) do
      [
        '',
        '<node><b><c></c></b></node>',
        '<node><a></a></node>',
        '<node><a></a><b></b></node>',
      ]
    end

    it "has one removed node for each tag" do
      expect(removed_nodes.count).to eq 4
    end
    it "removed nodes contain each of the expected removed nodes" do
      expected_removed_nodes.each do |removed|
        expect(removed_nodes).to include(Nokogiri::XML(removed).to_xml)
      end
    end
    it "altered xmls contain each of the expected altered xmls" do
      expected_altered_xmls.each do |altered|
        expect(altered_xmls).to include(Nokogiri::XML(altered).to_xml)
      end
    end
  end
end
