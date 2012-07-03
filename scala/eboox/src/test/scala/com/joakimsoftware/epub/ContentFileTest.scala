package com.joakimsoftware.epub

import org.junit.Before
import org.junit.Test
import org.scalatest.junit.AssertionsForJUnit
import org.scalatest.junit.JUnitSuite

import scala.io.Source

/**
Tests for class ContentFile.

@author  Chris Joakim
@version 2011/05/01
*/
class ContentFileTest extends JUnitSuite with AssertionsForJUnit {

	@Before def initialize {
		Config.load()
	}

	@Test def test_constructor {
		val cf1 = new ContentFile("excellent.css")
		val cf2 = new ContentFile("chapter05.html")
		val cf3 = new ContentFile("image3.png")
		expect("text/css") { cf1.media_type }
		expect("OEBPS/excellent.css") { cf1.full_filename }
		expect("application/xhtml+xml") { cf2.media_type }
		expect("image/png")  { cf3.media_type }
	}
	
	@Test def test_is_html {
		val cf1 = new ContentFile("excellent.css")
		val cf2 = new ContentFile("chapter05.html")
		expect(false) { cf1.isHtml }
		expect(true)  { cf2.isHtml }		
	}

}
