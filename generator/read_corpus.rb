require 'ox'

class CorpusReader
  def initialize
    @dict = {}
    @sum = 0
  end

  def read_corpus
    Dir.glob('../GrammarDB/RELEASE-20230920/*.xml').each do |file|
      parsed = Ox.parse(File.read(file))

      @sum += parsed.Wordlist.nodes.size

      parsed.Wordlist.nodes.each do |paradigm|
        name = paradigm.attributes[:lemma].gsub('+', '')
        @dict[name] = []
        paradigm.nodes.select do |node|
          node.value == 'Variant'
        end.each do |variant|
          @dict[name] += variant.nodes.map{|form| form.nodes.first.gsub('+', '')}
        end
        @dict[name].uniq!
      end
    end
  end

  def [](key)
    @dict[key]
  end
end