package com.joakimsoftware.epub

/**
Instances of this class represent one unique content file (css, html, image)
to be included in the book.

@author  Chris Joakim
@version 2011/05/01
*/
class ContentFile(val filename:String, 
	var nav_label_text:String = "", var play_order:Int = 0) {
		
	def href ={
		filename
	}	
	
	def id ={
		// "oops".replaceAll("\\.[^.]*$", "") + ".js"
		filename.replaceAll("[.]","_").replaceAll(" ","_")
	}	
	
	def media_type : String = {
		Config.media_type(filename)
	}
	
	def full_filename : String = {
		Config.content_dir + Config.fs + filename
	}
	
	def isHtml : Boolean = {
		if (filename.toLowerCase.indexOf(".htm") > 0) {
			return true;
		}
		return false;
	}	
	
}
