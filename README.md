== README

Theis plant monitor hooks up to a Raspberry Pi with this sensor:
https://www.adafruit.com/products/1298

It uses whenever crontab gem to collect sensor data every hour.   fswebcam takes a picture as well at the top of the hour if it's currently daytime.  The lat/long is hardcoded for Seattle in the Input model for determining daylight hours.

Another rake task at 10 pm uses Imagemagick/RMagick to animate the images during the day into a timelapse gif.
