package com.joakimsoftware.epub

import java.io.File
import java.io.FileWriter

import scala.io.Source
import scala.collection.mutable.ListBuffer
import scala.collection.mutable.ListBuffer

/**
This Singleton is used to generate the various epub metadata files
for your book.  It also generates packaging scripts.

@author  Chris Joakim
@version 2011/05/01
*/
object Generator {

	var content_files = new ListBuffer[ContentFile]
	var spine_files	  = new ListBuffer[ContentFile]

	def main(args: Array[String]) = {
		if (args.size > 0) {
			Config.load(args(0))
			generate
		}
		else {
			println("Error: A fully-qualified configuration filename is required on the command line.")
		}
	}

	def generate = {
		content_files = new ListBuffer[ContentFile]
		spine_files   = new ListBuffer[ContentFile]
		
		if (Config.valid) {
			println("OK: config file and entries are valid.")
			identify_files
			generate_mimetype_file
			generate_container_xml
			generate_content_opf
			generate_toc_ncx
			generate_package_scripts
		}
		else {
			println("ERROR: The config.txt file is either missing or invalid.")
			println("Please create and edit 'config.txt' in your book directory, and retry.")
		}
	}

	def identify_files = {
		println("Generator identify_files in dir: " + Config.absolute_content_dir)
		val files = new File(Config.absolute_content_dir).list
		for (val fn <- files) {
			val f = new File(Config.absolute_content_dir + fs + fn) //"" + Config.content_dir + fs + fn)
			if (!f.isDirectory()) {
				if (Config.excludes.contains(fn)) {
					println("excluding file: " + fn)
				}
				else {
					if (fn.equals(Config.book_cover_file)) {
						println("auto-included file: " + fn)
					}
					else if (fn.equals(Config.book_cover_image)) {
						println("auto-included file: " + fn)
					}
					else {
						val cf = new ContentFile(fn)
						content_files += cf
						println("including content file: " + fn)
						if (cf.isHtml) {
							cf.nav_label_text = Config.lookup_nav_label(cf.filename)
							spine_files += cf
							println("including spine file:   " + fn)
						}
					}
				}
			}
		}
		println("identify_files - content: " + content_files.size + " spine: " + spine_files.size)
	}

	def generate_mimetype_file = {
		write_file(Config.mimetype_filename, "application/epub+zip")
	}

	def generate_container_xml = {
		new File(Config.meta_inf_dir).mkdir()
		val content = container_xml_content.replace("xxx", Config.content_dir)
		write_file(Config.container_xml_filename, content)
	}

	def generate_content_opf = {
		write_file(Config.content_opf_filename, content_opf_content)
	}

	def generate_toc_ncx = {
		write_file(Config.toc_ncx_filename, generate_toc_ncx_content)
	}
	
	def generate_toc_ncx_content = {
		generate_toc_ncx_top +
		generate_toc_ncx_nav_points + 
		nl + "  </navMap>" + nl + "</ncx>"
	}

	def generate_toc_ncx_top : String = {
		"""<?xml version="1.0" encoding="utf-8" standalone="no"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
  <head>
    <meta name="cover" content="cover"/>
    <meta name="dtb:uid" content="%s"/>
    <meta name="dtb:depth" content="-1"/>
    <meta name="dtb:totalPageCount" content="0"/>
    <meta name="dtb:maxPageNumber"  content="0"/>
  </head>
  <docTitle>
    <text>%s</text>
  </docTitle>
  <navMap>
    <navPoint id="navpoint-1" playOrder="1">
      <navLabel>
        <text>Book cover</text>
      </navLabel>
      <content src="%s"/>
    </navPoint>
""".format(Config.book_id, Config.book_title, Config.book_cover_file)
	}
	
	def generate_toc_ncx_nav_points : String = {
		var sb = new StringBuilder
		var order = 1
		spine_files.foreach { cf =>
			order += 1
			cf.play_order = order
			sb.append("""    <navPoint id="navpoint-%s" playOrder="%s">
      <navLabel>
        <text>%s</text>
      </navLabel>
      <content src="%s"/>
    </navPoint>""".format(cf.id, cf.play_order, cf.nav_label_text, cf.href))
			sb.append(nl)
		}
		sb.toString
	}	
	
	def generate_package_scripts = {
		var shell_script = """#!/bin/bash

# Generated script used to package your epub file.

cd %s
rm %s

echo 'packaging epub file...'
zip -0Xq %s mimetype 
zip -Xr9Dq %s *

# It is recommended that you validate the generated epub file with a
# tool such as 'epubcheck' - see http://code.google.com/p/epubcheck/
# java -jar epubcheck-1.2.jar file.epub /books/Fun_with_Latin_0.5.0.epub

echo 'done'	
""".format(Config.book_dir, Config.book_epub_filename,
			Config.book_epub_filename, Config.book_epub_filename,
			Config.book_epub_filename)
		write_file(Config.package_script_filename_sh, shell_script)
		
		var batch_script = """@echo off

# Generated script used to package your epub file.

cd  %s
del %s

echo 'packaging epub file...'
zip -0Xq %s mimetype 
zip -Xr9Dq %s *

# It is recommended that you validate the generated epub file with a
# tool such as 'epubcheck' - see http://code.google.com/p/epubcheck/
# java -jar epubcheck-1.2.jar file.epub /books/Fun_with_Latin_0.5.0.epub

echo 'done'	
""".format(Config.book_dir, Config.book_epub_filename,
			Config.book_epub_filename, Config.book_epub_filename)
		write_file(Config.package_script_filename_bat, batch_script)
	}

	def fs = {
		File.separator
	}
	
	def container_xml_content = {
"""<?xml version="1.0" encoding="utf-8" standalone="no"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="%s/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>		
""".format(Config.content_dir)
	}
	
	def content_opf_content : String = {
		content_opf_content_header +
		content_opf_content_metadata + 
		content_opf_content_manifest + 
		content_opf_content_spine + 
		content_opf_content_guide +
		nl + "</package>"
	}
	
	def content_opf_content_header : String = {
		"""<?xml version="1.0" encoding="utf-8" standalone="no"?>
<package xmlns="http://www.idpf.org/2007/opf" version="2.0" unique-identifier="bookid">"""
	}
	
	def content_opf_content_metadata : String = {
		"""
  <metadata>
    <dc:identifier xmlns:dc="http://purl.org/dc/elements/1.1/" id="bookid">%s</dc:identifier>
    <dc:title xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:title>
    <dc:rights xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:rights>
    <dc:publisher xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:publisher>
    <dc:subject xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:subject>
    <dc:date xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:date>
    <dc:description xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:description>
    <dc:creator
        xmlns:dc="http://purl.org/dc/elements/1.1/" 
        xmlns:opf="http://www.idpf.org/2007/opf" 
        opf:file-as="%s">%s</dc:creator>
    <dc:language xmlns:dc="http://purl.org/dc/elements/1.1/">%s</dc:language>
    <meta name="cover" content="cover-image"/>
  </metadata>
""".format(Config.book_id, Config.book_title, Config.book_rights, 
		Config.book_publisher, Config.book_subject, Config.book_date, 
		Config.book_description, Config.book_creator, Config.book_creator, 
		Config.book_language)
	}
	
	def content_opf_content_manifest : String = {
		var sb = new StringBuilder
		sb.append("""  <manifest>
    <item id="ncxtoc" media-type="application/x-dtbncx+xml" href="toc.ncx"/>
    <item id="cover"  media-type="application/xhtml+xml" href="%s"/>
    <item id="cover-image" href="%s" media-type="%s"/>
""".format(Config.book_cover_file, Config.book_cover_image, Config.book_cover_image_media_type))

		content_files.foreach { cf =>
			sb.append("""    <item id="%s" href="%s" media-type="%s"/>""".format(cf.id, cf.href, cf.media_type))
			sb.append(nl)
		}
		sb.append("  </manifest>")
		sb.append(nl)
		sb.toString
	}
	
	def content_opf_content_spine : String = {
		var sb = new StringBuilder
		sb.append("""  <spine toc="ncxtoc">""")
		sb.append(nl)
    	sb.append("""    <itemref idref="cover" linear="yes"/>""")
		sb.append(nl)
		spine_files.foreach { cf =>
		  sb.append("""    <itemref idref="%s" />""".format(cf.id))
		  sb.append(nl)
		}
		sb.append("  </spine>")
		sb.append(nl)
		sb.toString
	}
	
	def content_opf_content_guide : String = {
		"""  <guide>
    <reference href="%s" type="cover" title="Cover"/>
  </guide>""".format(Config.book_cover_file)
	}	

	def nl : String = {
		System.getProperty("line.separator")
		//"\n"
	}
	
	def write_file(fn:String, text:String) = {
		println("writing file: " + fn)
		val out = new java.io.FileWriter(fn)
		out.write(text)
		out.close
		println("file written: " + fn)
	}

}