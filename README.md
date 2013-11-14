led_weather_indicator
============
LEDテープを使った3時間おきの天気予報表示

以下のLEDテープを使用しています。
* http://www.switch-science.com/catalog/1313/

![fig.1](http://distilleryimage8.s3.amazonaws.com/00684298bd7a11e2a7ab22000a1f97eb_6.jpg)

how to use
====
git cloneしてソースを取ってくる。
<pre>
$ mkdir -p ~/src
$ cd ~/src
$ git clone https://github.com/yoggy/led_weather_indicator.git
$ cd led_weather_indicator
</pre>

必要なライブラリのインストール。
<pre>
$ gem install bundler
$ bundle install
</pre>

led_weather_indicator.rbの郵便番号とArduinoが接続されているデバイスファイルを環境にあわせて編集。
<pre>
$ vi led_weather_indicator.rb

  location = "230-0000" # ここの部分を
  dev = "/dev/ttyACM0"  # 利用環境にあわせて変更

</pre>

led_weather_indicator.inoをArduinoに書き込み。LEDテープとArduinoの接続はソースコードを参照のこと。

led_weather_indicator.rbを実行。
<pre>
  $ bundle exec ruby led_weather_indicator.rb
</pre>

crontabに適当に設定
<pre>
0,30 * * * * cd $HOME/src/led_weather_indicator && bundle exec ruby led_weather_indicator.rb >/dev/null 2>&1
</pre>
