# Генератар слоўнікаў у фармаце EPUB для Kindle

Дадзены генератар дазваляе стварыць слоўнікавы EPUB-файл для чытальніка Kindle з лічбавага тэкста Тлумачальнага слоўніка беларускай мовы (ТСБМ). Для стварэння індэкса па якім шукаюцца словы быў выкарастаны [Беларускі N-корпус](https://bnkorpus.info/).

## Усталёўка

1. Усталюйце [Ruby](https://www.ruby-lang.org/en/downloads/) (па-змаўчанні ўжо ўсталяваны на macOS і Linux).
2. Усталюйце завісімасці `bundle install`.
3. Пры першам запуску скрыпта `./publish.sh` будзе спампован Беларускі N-корпус з выкарыстаннем `curl`. Альтэрнатыўна можна спампаваць яго самастойна і разархіваць у дырэкторыю `./GrammarDB`.

## Выкарыстанне

1. Запусціць скрыпт `./publish.sh`. Ён згенеруе EPUB-файл `./Тлумачальны Слоўнік Беларускай Мовы.epub`.
2. Самы просты варыянт - перакінуць гэты файл на Kindle праз [Send to Kindle](https://www.amazon.com.au/sendtokindle).

   Як альтэрнатыва можна сканвертаваць `./kindlegen –verbose -dont_append_source Тлумачальны\ Слоўнік\ Беларускай\ Мовы.epub` і перакінуць атрыманы файл на Kindle праз USB.

## Вынік

Апошнюю версію слоўніка можна спампаваць з [рэлізаў](https://github.com/belspectre/kindle_slounik/releases)

## Дакументацыя як пісаць слоўнікі для Kindle

[Kindle Publishing Guidelines](https://kindlegen.s3.amazonaws.com/AmazonKindlePublishingGuidelines.pdf)
