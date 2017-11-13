require 'path'

require 'gpio/pin'
require 'gpio/version'

module GPIO

  GPIOFilesystem = Path.new('/sys/class/gpio')

  def self.has_gpio?
    GPIOFilesystem.exist?
  end

end