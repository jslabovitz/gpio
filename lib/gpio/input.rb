module GPIO

  class Input

    DebounceDelta = 0.1

    attr_accessor :pin_number
    attr_accessor :edge_mode
    attr_accessor :value
    attr_reader   :value_io

    def initialize(pin_number:, edge_mode: nil)
      @pin_number = pin_number
      @edge_mode = edge_mode
      @last_value_timestamp = nil
      export
      set_direction
      set_edge_mode
      open_value
    end

    def direction
      'in'
    end

    def debounce_input
      value = read_value
      timestamp = Time.now.to_f
      if @last_value_timestamp.nil? || (timestamp - @last_value_timestamp) > DebounceDelta
        @last_value_timestamp = timestamp
        @value = value
        true
      else
        false
      end
    end

    def export
      unless root_path.exist?
        export_path.open('wb') { |io| io.write(@pin_number.to_s) }
        3.times do
          return if root_path.exist?
          sleep 0.1
        end
        raise "Couldn't export pin #{@pin_number}: no GPIO path appeared at #{root_path}"
      end
    end

    def unexport
      if root_path.exist?
        if @value_io
          @value_io.close
          @value_io = nil
        end
        unexport_path.open('wb') { |io| io.write(@pin_number.to_s) }
      end
    end

    private

    def set_direction
      direction_path.open('wb') { |io| io.write(direction) }
    end

    def set_edge_mode
      if @edge_mode
        edge_path.open('wb') { |io| io.write(@edge_mode.to_s) }
      end
    end

    def open_value
      @value_io = value_path.open((direction == 'out') ? 'wb' : 'rb')
    end

    def read_value
      @value_io.seek(0, IO::SEEK_SET)
      @value_io.gets.chomp.to_i != 0
    end

    def export_path
      GPIOFilesystem / 'export'
    end

    def unexport_path
      GPIOFilesystem / 'unexport'
    end

    def root_path
      GPIOFilesystem / "gpio#{pin_number}"
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