require 'path'

require 'gpio/manager'
require 'gpio/input'
require 'gpio/output'
require 'gpio/led'

module GPIO

  GPIOFilesystem = Path.new('/sys/class/gpio')
  LEDFilesystem = Path.new('/sys/class/leds')

end