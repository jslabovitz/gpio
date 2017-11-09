require 'gpio/version'
require 'path'

module GPIO

  GPIOFilesystem = Path.new('/sys/class/gpio')

  def self.has_gpio?
    GPIOFilesystem.exist?
  end

  class Pin

    attr_accessor :number
    attr_accessor :io_mode
    attr_accessor :edge_mode

    def initialize(number, io_mode: 'r', edge_mode: 'falling')
      @number = number
      @io_mode = io_mode
      @edge_mode = edge_mode    # "none", "rising", "falling", or "both"
      @root_path = GPIOFilesystem / "gpio#{number}"
      @edge_path = @root_path / 'edge'
      @value_path = @root_path / 'value'
      export
      set_edge_mode
      open
    end

    def export
      (GPIOFilesystem / 'export').write(@number.to_s)
      3.times do
        return if @root_path.exist?
        sleep 0.1
      end
      raise "No GPIO path appeared at #{@root_path}"
    end

    def unexport
      @value_io.close
      (GPIOFilesystem / 'unexport').write(@number.to_s)
    end

    def io_mode=(mode)
      @io_mode = mode
    end

    def set_edge_mode
      @edge_path.write(@edge_mode)
    end

    def open
      @value_io = @value_path.open(@io_mode)
    end

    def read
      value = @value_io.read
      @value_io.seek(0, IO::SEEK_SET)
      value
    end

  end

end