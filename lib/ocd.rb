class OCD

  def initialize(config)
    @config = config
  end

  def scan
    Dir.glob(@config.directory + "/*.{" +
             @config.extensions.join(',') + "}") do |f|
      basics = File.basename(f)
      episode = extract_episode(basics)
      if episode
        puts "#{basics}: #{episode.inspect}"
      end
    end
  end

  def extract_episode(name)
    if name =~ @@ep_pattern
      match = $~.to_a
      return nil if match.length < 4
      ep = Hashie::Mash.new
      ep.show_name, ep.season, ep.episode = match[1], match[2], match[3]
      return ep
    end
  end

  def print_config
    puts @config.inspect
  end

  @@ep_pattern = Regexp.compile(%r{(.*)\.[sS]([0-9]{1,2})[eE]([0-9]{1,2}).*})
end
