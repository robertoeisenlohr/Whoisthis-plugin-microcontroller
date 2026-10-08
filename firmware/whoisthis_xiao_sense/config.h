// Build-time configuration. Everything here has a safe default for a bare XIAO ESP32-S3 Sense;
// the optional parts (button, battery sense, OLED, buzzer) turn on only when you wire them.
// Every value can be overridden from the build line (-DWIT_OLED=1 …), which CI uses.
#pragma once

#ifndef WIT_FIRMWARE_VERSION
#define WIT_FIRMWARE_VERSION "1.0.0"
#endif
#ifndef WIT_PROTOCOL_VERSION
#define WIT_PROTOCOL_VERSION 1
#endif
#ifndef WIT_MODEL
#define WIT_MODEL "XIAO ESP32-S3 Sense"
#endif

// Wi-Fi: leave empty to provision through the board's own access point (see README).
// Credentials saved through the portal live in NVS and win over these defaults.
#ifndef WIT_WIFI_SSID
#define WIT_WIFI_SSID ""
#endif
#ifndef WIT_WIFI_PASS
#define WIT_WIFI_PASS ""
#endif
#ifndef WIT_WIFI_CONNECT_TIMEOUT_MS
#define WIT_WIFI_CONNECT_TIMEOUT_MS 20000
#endif

#ifndef WIT_HTTP_PORT
#define WIT_HTTP_PORT 80
#endif
#ifndef WIT_STREAM_PORT
#define WIT_STREAM_PORT 81
#endif

// JPEG quality (lower = better, bigger). 12 keeps a 1280px frame well under the 1 MB ring slot.
#ifndef WIT_JPEG_QUALITY
#define WIT_JPEG_QUALITY 12
#endif
// Hard cap on the long side the app may ask for; UXGA (1600) is the OV2640 ceiling.
#ifndef WIT_MAX_LONG_SIDE
#define WIT_MAX_LONG_SIDE 1600
#endif

// Momentary button to GND (tap / long press). XIAO D1 = GPIO2. -1 disables input.* capabilities.
#ifndef WIT_BUTTON_PIN
#define WIT_BUTTON_PIN 2
#endif
#ifndef WIT_LONG_PRESS_MS
#define WIT_LONG_PRESS_MS 600
#endif

// Battery sense: BAT+ → 220k → A0 (GPIO1) → 220k → GND. -1 disables the battery capability.
#ifndef WIT_BATTERY_PIN
#define WIT_BATTERY_PIN -1
#endif
#ifndef WIT_BATTERY_DIVIDER
#define WIT_BATTERY_DIVIDER 2.0f
#endif
#ifndef WIT_BATTERY_PERIOD_MS
#define WIT_BATTERY_PERIOD_MS 30000
#endif

// User LED on the XIAO (active LOW). Blinks twice when a label is presented.
#ifndef WIT_LED_PIN
#define WIT_LED_PIN 21
#endif

// Optional 128x64 SSD1306 OLED on I2C (XIAO D4 = SDA GPIO5, D5 = SCL GPIO6). Set to 1 and install
// Adafruit SSD1306 + Adafruit GFX; detected at boot at 0x3C, which enables display.text.
#ifndef WIT_OLED
#define WIT_OLED 0
#endif
#ifndef WIT_OLED_ADDR
#define WIT_OLED_ADDR 0x3C
#endif

// Optional passive buzzer. -1 disables; otherwise a short chirp accompanies a spoken label.
#ifndef WIT_BUZZER_PIN
#define WIT_BUZZER_PIN -1
#endif
