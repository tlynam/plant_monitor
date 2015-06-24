class Input < ActiveRecord::Base

  def self.collect
    sensor_output = %x(sudo ./lib/sensor.a)
    values = sensor_output.scan(/(\d+.\d+)/).flatten
    
    { temperature: Float(values[0]), humidity: Float(values[1]), dewpoint: Float(values[2]) }
  end
end
