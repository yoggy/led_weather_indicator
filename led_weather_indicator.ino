//
//  led_weather_indicator.ino
//
//  This sketch is using Adafruit_NeoPixel library.
//    https://github.com/adafruit/Adafruit_NeoPixel
//
#include <Adafruit_NeoPixel.h>

#define LED_NUM 8

Adafruit_NeoPixel strip = Adafruit_NeoPixel(LED_NUM, 6, NEO_GRB + NEO_KHZ800);

byte *buf = new byte[LED_NUM];
uint16_t buf_idx = 0;

uint32_t color100 = strip.Color(12,  6,  0); // sunny
uint32_t color200 = strip.Color( 6,  6,  6); // cloudy
uint32_t color300 = strip.Color( 0,  0, 12); // rainy
uint32_t color400 = strip.Color( 0,  6,  6); // snowy
uint32_t color500 = strip.Color( 6,  1,  1); // hot
uint32_t color850 = strip.Color( 4,  0, 12); // heavy rain

void setup() {
  Serial.begin(9600);
  while (!Serial); // for leonald, micro...
  
  strip.begin();
}

void loop() {
  while (Serial.available() > 0) {
    int c = Serial.read();
    Serial.println(c);
    if (c == 'c') {
      buf_idx = 0;
    }
    else {
      buf[buf_idx] = c;
      buf_idx ++;
      if (buf_idx == 8) {
        set_led_color();
        buf_idx = 0;
      }
    }
  }
}

void set_led_color() {
  for(uint16_t i = 0; i < strip.numPixels(); ++i) {
    switch (buf[i]) {
      case '1':
        strip.setPixelColor(i, color100);
        break;
      case '2':
        strip.setPixelColor(i, color200);
        break;
      case '3':
        strip.setPixelColor(i, color300);
        break;
      case '4':
        strip.setPixelColor(i, color400);
        break;
      case '5':
        strip.setPixelColor(i, color500);
        break;
      case '8':
        strip.setPixelColor(i, color850);
        break;
      default:
        strip.setPixelColor(i, strip.Color( 0,  0, 0));
        break;
    }
  }
  strip.show();
}


