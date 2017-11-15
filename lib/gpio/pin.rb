module GPIO

  class Pin

    attr_accessor :number
    attr_accessor :direction
    attr_accessor :edge_mode
    attr_accessor :value_type
    attr_reader   :value_io

    def initialize(number:, direction:, edge_mode: :none, value_type: nil)
      @number = number
      @direction = direction
      @edge_mode = edge_mode
      @value_type = value_type
      setup
    end

    def setup
      export
      set_direction
      set_edge_mode
      open_value
    end

    def shutdown
      unexport
    end

    def read
      @value_io.seek(0, IO::SEEK_SET)
      value = @value_io.read.chomp
      value = case @value_type
      when :bool
        (value == '0') ? false : true
      when :int
        value.to_i
      else
        value
      end
    end

    def write(value)
      value = (value ? 1 : 0) if @value_type == :bool
      @value_io.write(value.to_s)
    end

    def input?
      @direction == :in
    end

    def output?
      @direction == :out
    end

    private

    def export
      unless root_path.exist?
        export_path.open('wb') { |io| io.write(@number.to_s) }
        3.times do
          return if root_path.exist?
          sleep 0.1
        end
        raise "Couldn't export pin #{@number}: no GPIO path appeared at #{root_path}"
      end
    end

    def unexport
      if root_path.exist?
        @value_io.close if @value_io
        unexport_path.open('wb') { |io| io.write(@number.to_s) }
      end
    end

    def set_direction
      direction_path.open('wb') { |io| io.write(@direction.to_s) }
    end

    def set_edge_mode
      if input? && @edge_mode
        edge_path.open('wb') { |io| io.write(@edge_mode.to_s) }
      end
    end

    def open_value
      @value_io = value_path.open(output? ? 'wb' : 'rb')
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

    def direction_path
      root_path / 'direction'
    end

    def edge_path
      root_path / 'edge'
    end

    def value_path
      root_path / 'value'
    end

  end

end