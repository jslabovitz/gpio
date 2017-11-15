module GPIO

  class Manager

    def initialize
      @pin_ios = {}
    end

    def exist?
      GPIOFilesystem.exist?
    end

    def setup_input_pin(params)
      setup_pin(params.merge(direction: :in))
    end

    def setup_output_pin(params)
      setup_pin(params.merge(direction: :out))
    end

    def setup_pin(params)
      Pin.new(params).tap do |pin|
        @pin_ios[pin.value_io] = pin
      end
    end

    def shutdown
      pins.map(&:shutdown)
    end

    def pins
      @pin_ios.values
    end

    def pin_for_io(io)
      @pin_ios[io]
    end

  end

end