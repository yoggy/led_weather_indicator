#!/usr/bin/ruby
#
#  led_weather_indicator.rb 
#

require 'rubygems'
require 'serialport'
require 'open-uri'
require 'rexml/document'
require 'pp'

url = "http://weathernews.jp/pinpoint/xml/46106.xml" # 横浜
dev = "/dev/cu.usbmodem1411"
log_file = File.dirname($0) + "/weather.log"

f = open(log_file, "a+")

f.puts("==== date : " + Time.now.strftime("%Y-%m-%d %H:%M:%S"))

# 1時間毎の天気コードを取得
doc = REXML::Document.new(open(url))
codes = [];
doc.elements.each('weathernews/data/day/weather/hour') {|e|
  codes << e.text.to_i
}
codes = codes.slice(0, 24) #32時間分あるので先頭24時間分だけ取り出す
f.puts "weather codes=#{codes.join(',')}"

# 天気コード比較
def code_rank(a)
  rank = {
      0 => 0,
    100 => 1,
    550 => 2,
    200 => 3,
    300 => 4,
    400 => 5,
    850 => 6,
  }
  return rank[a] if rank.key?(a)
  
  return 10
end

def compare_code(a, b)
  puts 
  return code_rank(a) <= code_rank(b)
end

# 3時間毎の天気コードに集約
codes_e3h = []
count = 0;
max_code = 0;
codes.each {|c|
  if compare_code(max_code ,c)
    max_code = c
  end
  count += 1
  if count == 3
    codes_e3h << max_code
    max_code = 0
    count = 0
  end
}
f.puts "weather codes (every 3 hours)=" + codes_e3h.join(',')

# arduinoに送信するコードを作成
cmd = "c"
codes_e3h.each {|c|
  cmd << (c/100).to_s
}
f.puts "send command=" + cmd

# arduinoへコードを送信 (leonald対策でsleepを入れている)
sp = SerialPort.new(dev, 9600)
sleep 2
sp.write(cmd)
sp.flush
sleep 2
sp.close

