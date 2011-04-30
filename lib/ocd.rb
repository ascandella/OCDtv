class OCD

  def initialize(config)
    @config = config
  end

  def scan
    Dir.glob(@config.directory + "/*.{" +
             @config.extensions.join(',') + "}") do |f|
      puts f
    end
  end

  def print_config
    puts @config.inspect
  end
end
