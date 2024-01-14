if [ ! -d "GrammarDB" ]; then
  # download GrammarDB using curl
  curl https://github.com/Belarus/GrammarDB/releases/download/RELEASE-202309/RELEASE-20230920.zip -L -o GrammarDB.zip
  unzip GrammarDB.zip -d GrammarDB
fi

cd generator
ruby generator.rb
mv out/* ../EPUB/OEBPS/Text/

cd ../EPUB
rm -f *.csv
rm -f *.epub
zip -X0 "EPUB" mimetype
zip -rDX9 "EPUB" * -x "*.DS_Store" -x mimetype
mv "EPUB.zip" "../Тлумачальны Слоўнік Беларускай Мовы.epub"