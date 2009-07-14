require 'ManPage'

class ManPageSpider
	attr_reader :results
	
	def initialize(paths)
		@paths = paths
		@results = []
	end
	
	def parse
		@paths.each do |path|
			parsePath(path)
		end
	end
	
	private
	
	def parsePath(path)
		if FileTest.directory?(path) then			
			Dir.open(path).each do |file|
				parseManPageDirectories(File.join(path, file)) unless file =~ /^\.{1,2}$/
			end
		end
	end
	
	def parseManPageDirectories(path)
		if FileTest.directory?(path) and path =~ /man[0-9]?(x|n)?$/i then
			Dir.open(path).each do |file|
				parseManPage(File.join(path, file),
					path[/[0-9]?(x|n)?$/i]) unless file =~ /^\.{1,2}$/
			end
		end
	end
	
	def parseManPage(path, section)
		results << ManPage.new(path, section)
	end
end
