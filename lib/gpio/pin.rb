module GPIO

  class Pin

    attr_accessor :number
    attr_accessor :direction
    attr_accessor :edge_mode
    attr_reader   :value_io

    def initialize(number:, direction:, edge_mode: :none)
      @number = number
      @direction = direction
      @edge_mode = edge_mode
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
      @value_io.gets.chomp.to_i != 0
    end

    def write(value)
      @value_io.puts((value ? 1 : 0).to_s)
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