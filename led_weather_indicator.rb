#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#
#  led_weather_indicator.rb - LEDテープを使った3時間おきの天気予報表示
#
require 'rubygems'
require 'bundler'
Bundler.require

location = "230-0000" # 横浜市鶴見区
dev = "/dev/ttyACM0"  # ここは利用環境にあわせて変更

# 天気データを取得
forecast = WeatherPinpointJp.get(location, WeatherPinpointJp::POSTAL_CODE)

# 3時間毎の天気コードを取得
codes = forecast.weather_3h.slice(0, 8) # 先頭8個分を取り出す

# arduinoに送信するコードを作成
cmd = "c"
codes.each {|c|
  cmd << (c/100).to_s
}

# 取得データのログを記録しておく
log_file = File.dirname($0) + "/weather.log"
f = open(log_file, "a+")
f.puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} : codes=#{forecast.weather.join(",")}, codes_3h=#{codes.join(',')}, send command=#{cmd}, url=#{forecast.url}"

# arduinoへコードを送信 (leonald対策でsleepを入れている)
sp = SerialPort.new(dev, 9600)
sleep 2
sp.write(cmd)
sp.flush
sleep 2
sp.close

