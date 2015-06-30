include Magick

class Input < ActiveRecord::Base

  def self.collect
    sensor_output = %x(sudo ./lib/sensor.a)
    values = sensor_output.scan(/(\d+.\d+)/).flatten
    
    { temperature: Float(values[0]), humidity: Float(values[1]), dewpoint: Float(values[2]) }
  end

  def self.save_picture
    sun_times = SunTimes.new
    rise = sun_times.rise(Date.current, 47, -122).localtime
    set = sun_times.set(Date.current + 1, 47, -122).localtime
    daylight = rise..set

    if daylight.cover? Time.zone.now
      %x(fswebcam -r 1280x960 --flip h,v --no-banner app/assets/images/daily/#{Time.now.to_i}.jpg)
    end
  end

  def self.collect_and_save
    input = Input.new self.collect
    input.save

    self.save_picture
  end

  def self.generate_chart_series
    temperature_series, humidity_series, dewpoint_series = {}, {}, {}

    Input.all.each do |input|
      temperature_series[input.created_at] = input.temperature * 1.8 + 32
      humidity_series[input.created_at] = input.humidity
      dewpoint_series[input.created_at] = input.dewpoint * 1.8 + 32
    end

    [
      { name: "Temp F", data: temperature_series },
      { name: "Dew Point F", data: dewpoint_series },
      { name: "Humidity %", data: humidity_series }
    ]
  end

  def self.create_animation
    images = Dir.glob("app/assets/images/daily/*.jpg")
    anim = ImageList.new(*images)
    anim.write("app/assets/images/animations/#{Date.current.to_s}.gif")
    File.delete(*images)
  end
end
