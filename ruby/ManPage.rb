require 'rubygems'
require 'hpricot'

class ManPage
	attr_reader :name, :basename, :path, :full_path, :section, :html_path
	
	def initialize(path, section)
		@name = File.basename(path).gsub(/\.(gz|bz2)/, '')
		@basename = File.basename(path)
		@path = File.dirname(path)
		@full_path = path
		@section = section
		@level = @path.count('/')
		@html_path = File.join(@path, @name) + ".html"
	end
	
	def to_html
		command = "groff -t -man -Thtml | tidy -i 2>/dev/null"
		
		if @full_path =~ /\.gz$/ then
			command = "gzip -cd #{@full_path} | " + command
		else
			command = "cat #{@full_path} | " + command
		end
		
		post_process_html(`#{command}`)
	end
	
	private
	
	def post_process_html(html)
		doc = Hpricot(html)
		relative_offset = "../" * @level
		
		(doc/"body").prepend "<a name='TOP-TOC'></a>"
		
		(doc/"head").prepend "<meta name='viewport' content='width=device-width'>"
		(doc/"head").prepend "<meta name='viewport' content='initial-scale=1.0'>"
		(doc/"head").prepend "<link rel='stylesheet' type='text/css' href='#{relative_offset}stylesheets/iphone.css' />"
		# Reverse these so they appear properly in the output.
		(doc/"head").prepend "<script type='text/javascript'>$.include('#{relative_offset}js/top-toc.js');</script>"
		(doc/"head").prepend "<script src='#{relative_offset}js/jquery.include.js' type='text/javascript'></script>"
		(doc/"head").prepend "<script src='#{relative_offset}js/jquery.min.js' type='text/javascript'></script>"
		
		#puts "#{doc.to_html} | tidy -i 2>/dev/null"
		#`#{doc.to_html} | tidy -i 2>/dev/null`
		doc.to_html
	end
end
