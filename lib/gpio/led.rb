module GPIO

  class LED

    attr_accessor :name
    attr_reader   :max_brightness

    def initialize(name:)
      @name = name
      read_max_brightness
    end

    def on
      self.brightness = @max_brightness
    end

    def off
      self.brightness = 0
    end

    def brightness=(brightness)
      brightness = case brightness
      when true
        @max_brightness
      when false
        0
      else
        brightness
      end
      brightness_path.open('wb') do |io|
        io.puts(brightness.to_s)
      end
    end

    private

    def read_max_brightness
      @max_brightness = max_brightness_path.read.chomp.to_i
    end

    def root_path
      LEDFilesystem / @name
    end

    def brightness_path
      root_path / 'brightness'
    end

    def max_brightness_path
      root_path / 'max_brightness'
    end

  end

end