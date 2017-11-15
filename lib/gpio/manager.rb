module GPIO

  class Manager

    def initialize
      @pin_ios = {}
    end

    def exist?
      GPIOFilesystem.exist?
    end

    def on_pin(number, params={}, &block)
      pin = Pin.new(number, params.merge(handler: block))
      @pin_ios[pin.value_io] = pin
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