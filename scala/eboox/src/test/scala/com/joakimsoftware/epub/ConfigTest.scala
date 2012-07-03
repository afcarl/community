package com.joakimsoftware.epub

import org.junit.Before
import org.junit.Test
import org.scalatest.junit.AssertionsForJUnit
import org.scalatest.junit.JUnitSuite

import scala.io.Source

/**
Tests for the Config singleton.

@author  Chris Joakim
@version 2011/05/01
*/
class ConfigTest extends JUnitSuite with AssertionsForJUnit {

	var s : String = null
	var x : String = null

	@Before def initialize {
		Config.load("fun_with_latin_book" + Config.fs + "config.txt")
	}

	@Test def test_property_defaults {
		expect("some value") { Config.property("undefined", "some value") }
	}

	@Test def test_year {
		expect("2011") { Config.year }
	}

	@Test def test_proj_name {
		s = Config.proj_name
		println("proj_name: " + s)
		expect("pubby") { s }
	}

	@Test def test_pwd {
		s = normalize_filename(Config.pwd)
		x = "/cjoakim/github/eboox"
		println("pwd: " + s)
		expect(x) { s }
	}

	@Test def test_absolute_config_filename {
		s = normalize_filename(Config.absolute_config_filename)
		x = "/cjoakim/github/eboox/fun_with_latin_book/config.txt"
		println("absolute_config_filename: " + s)
		expect(x) { s }
	}
	
	@Test def test_container_xml_filename {
		s = normalize_filename(Config.container_xml_filename)
		x = "/cjoakim/github/eboox/fun_with_latin_book/META-INF/container.xml"
		println("container_xml_filename: " + s)
		expect(x) { s }
	}

	@Test def test_content_opf_filename {
		s = normalize_filename(Config.content_opf_filename)
		x = "/cjoakim/github/eboox/fun_with_latin_book/OEBPS/content.opf"
		println("content_opf_filename: " + s)
		expect(x) { s }
	}

	@Test def test_toc_ncx_filename {
		s = normalize_filename(Config.toc_ncx_filename)
		x = "/cjoakim/github/eboox/fun_with_latin_book/OEBPS/toc.ncx"
		println("toc_ncx_filename: " + s)
		expect(x) { s }
	}

	@Test def test_book_title {
		s = normalize_filename(Config.book_title)
		x = "Fun_with_Latin"
		println("book_title: " + s)
		expect(x) { s }
	}

	@Test def test_book_epub_filename {
		s = normalize_filename(Config.book_epub_filename)
		x = "/cjoakim/github/eboox/fun_with_latin_book/Fun_with_Latin_0.5.0.epub"
		println("book_epub_filename s: " + s)
		println("book_epub_filename x: " + x)
		expect(x) { s }
	}

	@Test def test_valid {
		assert(Config.required_properties.size >= 5)
		expect(true) { Config.valid }
	}

	@Test def test_media_type {
	  val test_cases = Map(
		"my.css"  -> "text/css",
		"my.html" -> "application/xhtml+xml",
		"my.ncx"  -> "application/x-dtbncx+xml",
		"my.gif"  -> "image/gif",
		"my.jpg"  -> "image/jpeg",
		"my.jpeg" -> "image/jpeg",
		"MY.JPEG" -> "image/jpeg",
		"my.png"  -> "image/png",
		"my.otf"  -> "font/opentype")

		test_cases foreach (
		  (t2) => assert_media_type (t2._1, t2._2)
		)
	}

	def assert_media_type(fn:String, x:String) = {
		expect(Config.media_type(fn)) { x }
	}

	def normalize_filename(fn:String) : String = {
		("" + fn).replaceAll("C:", "").replaceAll("c:", "").replace('\\', '/').trim
	}

}
