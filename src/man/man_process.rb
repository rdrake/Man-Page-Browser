require 'fileutils'
require 'man_paths'

# Set/create the output directory
out_dir = "manpages"

if not File.exists?(out_dir)
  Dir.mkdir(out_dir)
end

def process(file)
  out_file = File.join("manpages", file) + ".html"
  FileUtils.mkdir_p(File.dirname(out_file))
  command = "groff -t -man -Thtml > #{out_file} 2> /dev/null"

  if File.extname(file) == ".gz" then
    command = "gunzip -cf #{file} | " + command
  else
    command = "cat #{file} | " + command
  end

  %x[#{command}]

  if $?.exitstatus != 0 and File.exists?(out_file) then
    File.delete(out_file)
  end
end

count = 0

get_files.each do |file|
  process(file)
  count += 1

  if count % 10 == 0 then
    puts "Completed #{count}."
  end
end
