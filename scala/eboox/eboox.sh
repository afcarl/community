#!/bin/bash

# Edit the value of SCALA_LIB_DIR to point to where the Scala lib/
# directory is on your computer.
SCALA_LIB_DIR="/opt/local/share/scala-2.8/lib"
MVN_TARGET_DIR="target"

CP="."
CP=$CP:$SCALA_LIB_DIR/scala-library.jar
CP=$CP:$MVN_TARGET_DIR/eboox-1.0.0.jar

CLASS="com.joakimsoftware.epub.Generator"

# Edit the end of this line - change 'fun_with_latin_book/config.txt'
# the actual value of your config.txt file for your book.
java -Xms256m -Xmx1024m -server -cp $CP $CLASS fun_with_latin_book/config.txt 
