// Build-time configuration. Everything here has a safe default for a bare XIAO ESP32-S3 Sense;
// the optional parts (button, battery sense, OLED, buzzer) turn on only when you wire them.
#pragma once

#define WIT_FIRMWARE_VERSION "1.0.0"
#define WIT_PROTOCOL_VERSION 1
#define WIT_MODEL "XIAO ESP32-S3 Sense"

// Wi-Fi: leave empty to provision through the board's own access point (see README).
// Credentials saved through the portal live in NVS and win over these defaults.
#define WIT_WIFI_SSID ""
#define WIT_WIFI_PASS ""
#define WIT_WIFI_CONNECT_TIMEOUT_MS 20000

#define WIT_HTTP_PORT 80
#define WIT_STREAM_PORT 81

// JPEG quality (lower = better, bigger). 12 keeps a 1280px frame well under the 1 MB ring slot.
#define WIT_JPEG_QUALITY 12
// Hard cap on the long side the app may ask for; UXGA (1600) is the OV2640 ceiling.
#define WIT_MAX_LONG_SIDE 1600

// Momentary button to GND (tap / long press). XIAO D1 = GPIO2. -1 disables input.* capabilities.
#define WIT_BUTTON_PIN 2
#define WIT_LONG_PRESS_MS 600

// Battery sense: BAT+ → 220k → A0 (GPIO1) → 220k → GND. -1 disables the battery capability.
#define WIT_BATTERY_PIN -1
#define WIT_BATTERY_DIVIDER 2.0f
#define WIT_BATTERY_PERIOD_MS 30000

// User LED on the XIAO (active LOW). Blinks twice when a label is presented.
#define WIT_LED_PIN 21

// Optional 128x64 SSD1306 OLED on I2C (XIAO D4 = SDA GPIO5, D5 = SCL GPIO6). Set to 1 and install
// Adafruit SSD1306 + Adafruit GFX; detected at boot at 0x3C, which enables display.text.
#define WIT_OLED 0
#define WIT_OLED_ADDR 0x3C

// Optional passive buzzer. -1 disables; otherwise a short chirp accompanies a spoken label.
#define WIT_BUZZER_PIN -1
