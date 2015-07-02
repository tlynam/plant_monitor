include Magick

class Input < ActiveRecord::Base

  def self.collect
    sensor_output = `sudo ./lib/sensor.a`
    values = sensor_output.scan(/(\d+.\d+)/).flatten.map { |val| Float(val) }
    
    { temperature: values[0], humidity: values[1], dewpoint: values[2] }
  end

  def fahrenheit_temperature
    (self.temperature * 1.8 + 32).round(2)
  end

  def fahrenheit_dewpoint
    (self.dewpoint * 1.8 + 32).round(2)
  end

  def self.save_picture
    `fswebcam -r 1280x960 --flip h,v --no-banner public/images/daily/#{Time.now.to_i}.jpg`
  end

  def self.daytime?
    sun_times = SunTimes.new
    rise = sun_times.rise(Date.current, 47, -122).localtime
    set = sun_times.set(Date.current + 1, 47, -122).localtime
    daylight = rise..set

    daylight.cover? Time.zone.now
  end

  def self.collect_and_save
    Input.create! collect

    save_picture if daytime?
  end

  def self.generate_chart_series
    temperature_series, humidity_series, dewpoint_series = {}, {}, {}

    Input.all.each do |input|
      temperature_series[input.created_at] = input.fahrenheit_temperature
      humidity_series[input.created_at] = input.humidity
      dewpoint_series[input.created_at] = input.fahrenheit_dewpoint
    end

    [
      { name: "Temp F", data: temperature_series },
      { name: "Dew Point F", data: dewpoint_series },
      { name: "Humidity %", data: humidity_series }
    ]
  end

  def self.create_animation
    images = Dir.glob("public/images/daily/*.jpg")
    anim = ImageList.new(*images)
    anim.write("public/images/animations/#{Date.current.to_s}.gif")
    File.delete(*images)
  end
end
