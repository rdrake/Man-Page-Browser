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
require 'sqlite3'

require 'ManPageSpider'
require 'ManPageDir'
require 'ManPage'

db = SQLite3::Database.open("data.sqlite3")
htdocs = "man"

dirs = ManPageDir.new
spider = ManPageSpider.new(dirs.dirs)
spider.parse

count = 1
total_count = spider.results.count

db.prepare("INSERT INTO Entries (section_id, os_id, name, path) VALUES(?, ?, ?, ?)") do |stmt|
	spider.results.each do |result|
		FileUtils.mkdir_p(File.join(htdocs, result.path))
		section_id = db.get_first_value("SELECT id FROM Sections WHERE key='#{result.section}'")
		
		if (count % 100 == 0) then
			puts "Done #{count} / #{total_count} (#{(count / total_count.to_f * 100)}%)"
		end
		
		count += 1
		
		f = File.new(File.join(htdocs, result.html_path), 'w')
		f.puts(result.to_html)
		f.close
		
		stmt.execute section_id, 1, result.name, result.html_path
	end
end
