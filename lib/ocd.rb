class OCD
  def initialize(config)
    @config = config
    logger.level = Logger::INFO
  end

  def scan
    min_age = Date.today - @config['shelf_life_days']
    Dir.glob(@config['directory'] + "/*.{" +
             @config['extensions'].join(',') + "}") do |f|
      next if Date.parse(File.ctime(f).strftime('%Y/%m/%d')) > min_age
      basics = File.basename(f)
      episode = extract_episode(basics)

      if episode
        dir = find_name_with_season(
          @config['directory'], episode[:show_name], episode[:season])
        logger.info("Moving #{f} to #{dir.path}")
        begin
          FileUtils.mv(f, dir.path)
        rescue => ex
          logger.error("Couldn't move file: #{ex.inspect}")
        end
      end
    end
  end

private

  def extract_episode(name)
    if name =~ @@ep_pattern
      match = $~.to_a
      return {
        :show_name => match[1],
        :season => match[2].to_i,
        :episode => match[3].to_i
      } if match.length > 3
    end
  end

  def find_name_with_season(path, name, season)
    [lambda {|n, s| "#{n}/Season #{s}"},
     lambda {|n, s| "#{n}/#{n} #{s}"},
     lambda {|n, s| "#{n} #{s}"},
     lambda {|n, s| n}].each do |finder|
      guess = File.join(path, finder.call(name, season))
      break Dir.open(guess) if File.directory?(guess)
      guess.gsub!('.', ' ')
      break Dir.open(guess) if File.directory?(guess)
    end
  end

  # I wanted to do this in the least readable way possible.
  # Also, for some reason it wouldn't compile insensitive, so
  # I spelled out the cases. Good times.
  @@ep_pattern = Regexp.compile(/(.*)[\. ][sS]([0-9]{1,2})[eE]([0-9]{1,2}).*/)

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end
