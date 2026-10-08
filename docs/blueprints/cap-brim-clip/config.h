// firmware/whoisthis_xiao_sense/config.h overrides for the cap-brim clip build.
#pragma once
#define WIT_MODEL "WhoIsThis cap clip"
#define WIT_BUTTON_PIN 2        // D1: low-profile tactile switch in the floor (press upward)
#define WIT_BATTERY_PIN 1       // A0: 220k/220k divider
#define WIT_BATTERY_DIVIDER 2.0f
#define WIT_LED_PIN 21
#define WIT_OLED 0
#define WIT_BUZZER_PIN -1
#define WIT_JPEG_QUALITY 12
