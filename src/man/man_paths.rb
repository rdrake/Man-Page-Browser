def get_base_paths
  # OM NOM NOM
  paths = %x[manpath 2> /dev/null].chomp.split(':')
  if $?.exitstatus == 0 then paths else [] end
end

def get_paths
  Enumerator.new do |e|
    get_base_paths.each do |base_path|
      Dir.glob(File.join(base_path, "man*")).each do |path|
        e.yield path
      end
    end
  end
end

def get_files
  Enumerator.new do |e|
    get_paths.each do |path|
      Dir[File.join(path, "*")].each do |file|
        if file =~ /\d(x|n)?(\.(gz|bz2|x))?$/ then
          e.yield file
        end
      end
    end
  end
end
