class Input < ActiveRecord::Base

  def self.collect
    sensor_output = %x(sudo ./lib/sensor.a)
    values = sensor_output.scan(/(\d+.\d+)/).flatten
    
    { temperature: Float(values[0]), humidity: Float(values[1]), dewpoint: Float(values[2]) }
  end

  def self.generate_chart_series
    temperature_series, humidity_series, dewpoint_series = {}, {}, {}

    Input.all.each do |input|
      temperature_series[input.created_at] = input.temperature * 1.8 + 32
      humidity_series[input.created_at] = input.humidity
      dewpoint_series[input.created_at] = input.dewpoint
    end

    [
      { name: "Temp F", data: temperature_series },
      { name: "Humidity %", data: humidity_series },
      { name: "Dew Point %", data: dewpoint_series }
    ]
  end
end
