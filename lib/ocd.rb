class OCD
  def initialize(config, opts={})
    @config = config
    logger.level = opts[:debug] ? Logger::DEBUG : Logger::INFO
  end

  def scan(dry_run=false)
    min_age = Date.today - @config['shelf_life_days']
    Dir.glob(@config['directory'] + "/*.{" +
             @config['extensions'].join(',') + "}") do |f|
      next if Date.parse(File.ctime(f).strftime('%Y/%m/%d')) > min_age
      basics = File.basename(f)
      episode = extract_episode(basics)

      if episode
        dir = find_name_with_season(
          @config['directory'], episode[:show_name], episode[:season])

        if dir.nil?
          logger.warn("Could not find path for #{f}. Episode: #{episode.inspect}")
          next
        end

        if dir.is_a? Array
          logger.warn("Found multiple paths for #{f}: #{dir.join(', ')}. Ignoring")
          next
        end

        logger.info("#{dry_run ? 'Would move' : 'Moving'} #{f} to #{dir.path}")
        next if dry_run
        begin
          FileUtils.mv(f, dir.path)
        rescue => ex
          logger.error("Couldn't move file: #{ex.inspect}")
        end
      end
    end
  end

  def extract_episode(name)
    @@all_patterns.each do |pattern|
      if name =~ pattern
        match = $~.to_a
        return {
          :show_name => match[1],
          :season => match[3].to_i,
          :episode => match[4].to_i
        } if match.length > 4
      end
    end
    raise 'no match'
  end

private

  def find_name_with_season(path, name, season)
    @config['layout'].map do |pattern|
      pattern.gsub('%{name}', name).gsub('%{season}', season.to_s)
    end.each do |subpath|
      found, guess = nil, File.join(path, subpath)
      # cxlt's famous any? trick for short-circuiting
      @@substitutions.any? do |stripper|
        guess.gsub!(stripper[0], stripper[1])
        found = Dir.open(guess) if File.directory?(guess)
      end
      break found if found
    end
  end

  # I wanted to do this in the least readable way possible.
  # Also, for some reason it wouldn't compile insensitive, so
  # I spelled out the cases. Good times.
  @@scene_pattern = Regexp.compile(/(.*)[\. ][sS]?(20[0-9]{1,2}[\. ])?([0-9]{1,2})[eE\. ]([0-9]{1,2}).*/)
  @@tvnamer_pattern = Regexp.compile(/([^0-9\.]*) - [\[](20[0-9]{1,2}-)?([0-9]{1,2})[x-]([0-9]{1,2})[\]] - ([^\.]).*/)
  @@all_patterns = [@@scene_pattern, @@tvnamer_pattern]

  @@substitutions = [['', ''], ['.', ' '], ['The ', ''], ['Its', "It's"], [/ *[0-9]{4}/, '']]

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end
