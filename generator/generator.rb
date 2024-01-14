require_relative './read_corpus'
require_relative './writer'

class Generator
  def initialize
    @corpus = CorpusReader.new
    @corpus.read_corpus
  end

  def generate
    writer = Writer.new('abrv')
    convert_abbreviations(writer)
    writer.close
    writer = Writer.new('tsbm')
    convert(writer)
    writer.close
  end

  def convert_abbreviations(writer)
    writer.write("<h1>Аббрывеатуры</h1>\n")
    first = true

    # read lines from UTF-16 encoded file
    File.open('../tsbm/tsbm_abrv.dsl', "rb:UTF-16LE") do |file|
      file.readlines.each_with_index do |line, i|
        # skip lines without real data
        next if i < 3
        converted = line.encode!('UTF-8')

        if converted.start_with?("\t")
          writer.write(line.chomp)
        else
          if first
            first = false
          else
            writer.write("</p>\n")
          end

          writer.write("<p><b>#{line.chomp}</b><br />")
        end
      end
      writer.write("</p>")
    end
  end

  def convert(output)
    output.write("<h1>Слоўнік</h1>\n")
    first = true
    missed_in_corpus = 0

    # read lines from UTF-16 encoded file
    File.open('../tsbm/tsbm.dsl', "rb:UTF-16LE") do |file|
      file.readlines.each_with_index do |line, i|
        # skip lines without real data
        next if i < 4
        converted = line.encode!('UTF-8')

        if converted.start_with?("\t")
          if converted.include?('[m1]')
            next
          elsif converted.include?('[m2]')

            line.gsub!(/\[p\].?\[i\].?(\[c \w*\])?([а-яА-Я«»\.\-іэўёІЭЎЁ ]+)\[\/p\].?(\[\/c\])?.?\[\/i\]/, '<i>\2</i><br />')
            line.gsub!(/\[p\]\[c.*\]\[b\]\/\/\[\/b\]\[\/c\]\[\/p\]/, '//<br/>')
            line.gsub!("\t[m2]", '')
            line.gsub!(/\[(\/?)(b|i|sub|sup)\]/, '<\1\2>')
            line.gsub!(/\[(\/?)ex\]/, '<\1q>')
            line.gsub!(/\[\/?(c|p).?\w*\]/, '')
            line.gsub!(/\\(\[)|\\(\])/, '\1\2')
            line.gsub!(/\[\/?lang( id=\d+)?\]/, '')
            
            output.write(line)
          elsif converted.include?('[m3]')
            line.gsub!("\t[m3]\\[", '')
            line.gsub!("\\]", '')
            line.gsub!(/\[\/?c.?\w*\]/, '')
            output.write("<i>#{line}</i>")
          else
            p 'Unknown line format, will be skipped:'
            p line
          end
        else
          output.inc

          if first
            first = false
          else
            output.write("</idx:entry>\n")
            output.write("<hr />")
          end
          output.write("<idx:entry scriptable=\"yes\">\n")

          chomped = line.chomp
          
          write_tag(output, 'b') do
            write_tag(output, 'idx:orth') do
              output.write(chomped)

              if @corpus[chomped]
                write_tag(output, 'idx:infl') do
                  @corpus[chomped].each do |form|
                    output.write("<idx:iform value=\"#{form}\" />")
                    # add ў form for words starting with у for better search
                    if chomped.start_with?('у')
                      output.write("<idx:iform value=\"#{form.sub('у', 'ў')}\" />")
                    end
                  end
                end
              else
                missed_in_corpus += 1
              end
            end
          end
          output.write("<br />")
        end
      end
    end
    p "Missed in corpus: #{missed_in_corpus}"
  end

  def inspect
    ''
  end

  private

  def write_tag(output, tag, &block)
    output.write("<#{tag}>")
    yield
    output.write("</#{tag}>")
  end
end

Generator.new.generate