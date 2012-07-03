@echo off

# Generated script used to package your epub file.

cd  /cjoakim/github/eboox/fun_with_latin_book
del /cjoakim/github/eboox/fun_with_latin_book/Fun_with_Latin_0.5.0.epub

echo 'packaging epub file...'
zip -0Xq /cjoakim/github/eboox/fun_with_latin_book/Fun_with_Latin_0.5.0.epub mimetype 
zip -Xr9Dq /cjoakim/github/eboox/fun_with_latin_book/Fun_with_Latin_0.5.0.epub *

# It is recommended that you validate the generated epub file with a
# tool such as 'epubcheck' - see http://code.google.com/p/epubcheck/
# java -jar epubcheck-1.2.jar file.epub /books/Fun_with_Latin_0.5.0.epub

echo 'done'	
