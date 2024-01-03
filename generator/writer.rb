class Writer
  def initialize(file_name)
    @chunk_size = 10_000
    @chunk_index = 0
    @current_item_index = 0
    @file_name = file_name
    initialize_file(@chunk_index)
  end

  def write(string)
    @file.write(string)
  end

  def inc
    @current_item_index += 1
    if @current_item_index > @chunk_size
      @chunk_index += 1
      @current_item_index = 0
      initialize_file(@chunk_index)
    end
  end

  def close
    write_file_ending(@file)
    @file.close
  end

  private

  def initialize_file(index)
    close if @file

    @file = File.open("out/#{@file_name}_#{index}.xhtml", 'w')
    write_file_beginning(@file)
  end

  def write_file_beginning(output)
    output.write(
"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>
<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">

<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:math=\"http://exslt.org/math\" xmlns:svg=\"http://www.w3.org/2000/svg\" 

xmlns:tl=\"https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf\" xmlns:saxon=\"http://saxon.sf.net/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"

xmlns:cx=\"https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\"

xmlns:mbp=\"https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf\" xmlns:mmc=\"https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf\" xmlns:idx=\"https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf\">

<head>
  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
  <link href=\"../Styles/style.css\" rel=\"stylesheet\" type=\"text/css\" />
</head>

<body>
")
    output.write("<mbp:frameset>") unless @file_name == 'abrv'
  end

  def write_file_ending(output)
    output.write("</idx:entry></mbp:frameset>") unless @file_name == 'abrv'
    output.write("</body></html>")
  end
end