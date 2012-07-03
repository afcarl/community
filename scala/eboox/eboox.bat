@echo off

rem Edit the value of SCALA_LIB_DIR to point to where the Scala lib/
rem directory is on your computer.
set SCALA_LIB_DIR="C:\devroot\scala-2.8.1.final\lib"
set MVN_TARGET_DIR="target"

set CP="."
set CP=%CP%;%SCALA_LIB_DIR%/scala-library.jar
set CP=%CP%;%MVN_TARGET_DIR%/eboox-1.0.0.jar

set CLASS="com.joakimsoftware.epub.Generator"

rem Edit the end of this line - change 'fun_with_latin_book/config.txt'
rem the actual value of your config.txt file for your book.

call java -Xms256m -Xmx1024m -server -cp %CP% %CLASS% fun_with_latin_book/config.txt 
