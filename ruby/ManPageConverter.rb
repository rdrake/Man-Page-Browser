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
