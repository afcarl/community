package com.joakimsoftware.epub

import java.io.File
import java.util.Calendar
import java.util.Date

import scala.io.Source
import scala.collection.mutable.HashMap
import scala.collection.mutable.ListBuffer

/**
Singleton used to read and parse the configuration text file for
a given book.  Contains accessor methods used by the Generator.

@author  Chris Joakim
@version 2011/05/01
*/
object Config {

	var config_file = ""
	var book_dir	= ""
	var properties	= new HashMap[String, String]
	var excludes	= new HashMap[String, String]

	def load(filename:String="config.txt") = {

		if ((properties.size < 1) && (excludes.size < 1)) {
			config_file = filename
			book_dir = new File(absolute_config_filename).getParent()

			println("pwd:      " + pwd)
			println("book_dir: " + book_dir)

			excludes.put("content.opf", "")
			excludes.put("toc.ncx", "")
			excludes.put("package.sh", "")

			for (line <- Source.fromFile(config_file).getLines) {
				var trimmed = line.trim
				if (trimmed.size > 0) {
					if (!trimmed.startsWith("#")) { // ignore comment lines
						if (trimmed.indexOf("-exclude ") == 0) {
							val value = line.substring(9).trim
							excludes.put(value, "")
							println("added exclude:	 " + value)
						}
						else if (trimmed.indexOf("-") == 0) {
							val sidx = line.indexOf(" ")
							if (sidx > 0) {
								val key	  = line.substring(0, sidx).trim
								val value = line.substring(sidx).trim
								properties.put(key, value)
								println("added property: " + key + " = " + value)
							}
						}
					}
				}
			}
			println("Config.initialize - config_file: " + config_file + " properties size: " + properties.size)
		}
	}

	def fs = {
		File.separator
	}
	
	def pwd = {
		new File("").getAbsolutePath()
	}
	
	def absolute_config_filename = {
		new File(config_file).getAbsolutePath()
	}

	def proj_name = {
		"pubby"
	}

	def mimetype_filename = {
		"" + book_dir + fs + "mimetype"
	}

	def container_xml_filename = {
		"" + meta_inf_dir + fs + "container.xml"
	}

	def content_opf_filename = {
		"" + book_dir + fs + content_dir + fs + "content.opf"
	}

	def cover_image = {
		media_type(book_cover_image)
	}

	def toc_ncx_filename = {
		"" + book_dir + fs + content_dir + fs + "toc.ncx"
	}

	def meta_inf_dir = {
		"" + book_dir + fs + "META-INF"
	}

	def content_dir = {
		property("-book_content_dir", "OEBPS")
	}
	
	def absolute_content_dir = {
		book_dir + fs + content_dir
	}	

	def book_author = {
		property("-book_author", "")
	}

	def book_cover_file = {
		property("-book_cover_file", null)
	}

	def book_cover_image = {
		property("-book_cover_image", null)
	}
	
	def book_cover_image_media_type = {
		media_type(book_cover_image)
	}
	
	def book_creator = {
		property("-book_creator", book_author)
	}

	def book_date = {
		property("-book_date", new Date().toString)
	}

	def book_description = {
		property("-book_description", book_title)
	}

	def book_epub_filename = {
		"" + book_dir + fs + "" + book_title + "_" + book_version + ".epub".replace(' ', '_').trim
	}

	def book_id = {
		property("-book_id", "1")
	}

	def book_language = {
		property("-book_language", "en")
	}

	def book_publisher = {
		property("-book_publisher", "")
	}

	def book_rights = {
		val year = Calendar.getInstance().get(Calendar.YEAR)
		property("-book_rights", "Copyright " + year)
	}

	def book_subject = {
		property("-book_subject", book_title)
	}

	def book_title = {
		property("-book_title", "Book").replace(' ', '_').trim
	}

	def book_version = {
		property("-book_version", "1.0")
	}

	def package_script_filename_sh = {
		"" + book_dir + fs + "package.sh"
	}
	
	def package_script_filename_bat = {
		"" + book_dir + fs + "package.bat"
	}	

	def media_type(fn:String) = {
		val idx = fn.lastIndexOf('.')
		val ext = fn.substring(idx + 1)
		property("-media_type." + ext.toLowerCase, ext)
	}

	def property(name:String, default_val:String) = {
		properties.getOrElse(name, default_val).trim
	}

	def lookup_nav_label(fname:String) = {
		val pname = "-nav_label_" + fname
		property(pname, fname)
	}

	def year = {
		"" + Calendar.getInstance().get(Calendar.YEAR)
	}

	def required_properties = {
		Array("-book_author", "-book_title", "-book_version",
					"-book_cover_file", "-book_cover_image")
	}

	def valid : Boolean = {
		for (val prop <- required_properties) {
			if (property(prop, null) == null) { return false }
		}
		true
	}

}
