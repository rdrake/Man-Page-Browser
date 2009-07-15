# Copyright (c) 2009, Richard Drake
# All rights reserved.
#  
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#  
#   1. Redistributions of source code must retain the above copyright notice,
#      this list of conditions and the following disclaimer.
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#   3. Neither the name of the Mobile Education Project, the University of
#      Ontario Institute of Technology (UOIT), nor the names of its
#      contributors may be used to endorse or promote products derived from
#      this software without specific prior written permission.
#  
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

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
