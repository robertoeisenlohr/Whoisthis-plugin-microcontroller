// firmware/whoisthis_xiao_sense/config.h overrides for the lapel badge / pendant build.
// Copy over the stock config.h or pass as -D flags (see firmware/README.md).
#pragma once
#define WIT_MODEL "WhoIsThis lapel badge"
#define WIT_BUTTON_PIN 2        // D1: tactile switch on the top edge
#define WIT_BATTERY_PIN 1       // A0: 220k/220k divider from BAT+ (fit it; the badge has the room)
#define WIT_BATTERY_DIVIDER 2.0f
#define WIT_LED_PIN 21          // on-board LED, visible through the USB-C cut-out only; keep for debugging
#define WIT_OLED 0
#define WIT_BUZZER_PIN -1
#define WIT_JPEG_QUALITY 12
