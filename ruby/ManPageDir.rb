class ManPageDir
	attr_reader :dirs, :paths
	
	# OS X has the first two, Ubuntu appears to only have the last.
	@@paths = [ "/etc/man.conf", "/etc/manpaths", "/etc/manpath.config" ]

	def initialize
		@dirs = []
				
		@@paths.each do |p|
			parseFile(p) if File.exists?(p)
		end

		if ENV['MANPATH'] != nil then
			ENV['MANPATH'].split(':').each do |p|
				add(p)
			end
		end
	end
	
	def parseFile(file)
		f = File.open(file)
		
		f.each do |line|
			# Just add the last path on the line.
			add(line[/(\S+)$/]) if line =~ /^(MANDB_MAP|MANPATH|MANDATORY_MANPATH)/
		end
	end
	
	def add(path)
		@dirs << path if !@dirs.include?(path)
	end
end
