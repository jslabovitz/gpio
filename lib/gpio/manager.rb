module GPIO

  class Manager

    def initialize
      @pin_ios = {}
    end

    def exist?
      GPIOFilesystem.exist?
    end

    def setup_input_pin(params)
      add_pin(Input.new(params))
    end

    def setup_output_pin(params)
      add_pin(Output.new(params))
    end

    def add_pin(pin)
      @pin_ios[pin.value_io] = pin
    end

    def shutdown
      pins.map(&:unexport)
    end

    def pins
      @pin_ios.values
    end

    def pin_for_io(io)
      @pin_ios[io]
    end

  end

end