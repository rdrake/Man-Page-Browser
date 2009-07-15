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
