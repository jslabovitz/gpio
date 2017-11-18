module GPIO

  class Output < Input

    def direction
      'out'
    end

    def value=(value)
      @value_io.puts((value ? 1 : 0).to_s)
    end

  end

end