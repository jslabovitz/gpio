module GPIO

  class Pin

    attr_accessor :number
    attr_accessor :io_mode
    attr_accessor :edge_mode
    attr_reader   :value_io

    def initialize(number, io_mode: 'r', edge_mode: 'falling')
      @number = number
      @io_mode = io_mode
      @edge_mode = edge_mode    # "none", "rising", "falling", or "both"
      export
      set_edge_mode
      open
    end

    def export
      export_path.write(@number.to_s)
      3.times do
        return if root_path.exist?
        sleep 0.1
      end
      raise "No GPIO path appeared at #{root_path}"
    end

    def unexport
      @value_io.close
      unexport_path.write(@number.to_s)
    end

    def open
      @value_io = value_path.open(@io_mode)
    end

    def read
      value = @value_io.read
      @value_io.seek(0, IO::SEEK_SET)
      value
    end

    private

    def set_edge_mode
      edge_path.write(@edge_mode)
    end

    def export_path
      GPIOFilesystem / 'export'
    end

    def unexport_path
      GPIOFilesystem / 'unexport'
    end

    def root_path
      GPIOFilesystem / "gpio#{number}"
    end

    def edge_path
      root_path / 'edge'
    end

    def value_path
      root_path / 'value'
    end

  end

end