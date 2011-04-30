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
        dir = find_directory(episode)
        puts episode.show_name + ": " + dir
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

  def find_directory(episode)
    home = @config.directory
    guess = home + "/" + episode.show_name
    if !Dir.exists? guess
      guess = home + "/" + episode.show_name.gsub('.', ' ')
      return nil if !Dir.exists? guess
    end

    return guess
  end

  # I wanted to do this in the least readable way possible :)
  # Also, for some reason it wouldn't compile insensitive, so
  # I spelled out the cases. Good times.
  @@ep_pattern = Regexp.compile(%r{(.*)\.[sS]([0-9]{1,2})[eE]([0-9]{1,2}).*})
end
