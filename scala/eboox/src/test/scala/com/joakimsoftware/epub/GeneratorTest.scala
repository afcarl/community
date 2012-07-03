package com.joakimsoftware.epub

import org.junit.Before
import org.junit.Test
import org.scalatest.junit.AssertionsForJUnit
import org.scalatest.junit.JUnitSuite

import scala.io.Source

/**
Tests for the Generator singleton.

@author  Chris Joakim
@version 2011/05/01
*/
class GeneratorTest extends JUnitSuite with AssertionsForJUnit {
	
	@Test def test_generate_absolute_path_config {
		val args = Array("/cjoakim/github/cjoakim/tech/scala28/s2/fun_with_latin_book/config.txt")
		execute_tests(args)	}
	
	def execute_tests(args:Array[String]) = {
		Generator.main(args)
		
		assert(Config.book_title.indexOf("Fun_with_Latin") >= 0)
		assert(Generator.content_files.size == 4)
		assert(Generator.spine_files.size == 3)
	}	
}
