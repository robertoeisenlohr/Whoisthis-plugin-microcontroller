# Firmware: WhoIsThis on the XIAO ESP32-S3 Sense

Arduino sketch that makes a [Seeed Studio XIAO ESP32-S3 Sense](https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/)
a WhoIsThis capture device. The plugin APK in `../app` finds it on the local Wi-Fi and streams its
camera into the WhoIsThis app. Frames go to whoever asks on the LAN and nowhere else.

## Flash

1. Arduino IDE 2.x (or `arduino-cli`) with the **esp32 by Espressif** core ≥ 3.0 installed.
2. Board: *XIAO_ESP32S3*; set **PSRAM: OPI PSRAM** (the camera frame buffers live there).
3. Optional: `WIT_OLED 1` in `config.h` needs the *Adafruit SSD1306* and *Adafruit GFX* libraries.
4. Upload `whoisthis_xiao_sense/whoisthis_xiao_sense.ino`. Serial monitor at 115200 shows the IP.

```sh
arduino-cli core install esp32:esp32
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32S3:PSRAM=opi firmware/whoisthis_xiao_sense
arduino-cli upload  --fqbn esp32:esp32:XIAO_ESP32S3:PSRAM=opi -p /dev/ttyACM0 firmware/whoisthis_xiao_sense
```

## First boot (Wi-Fi)

With no credentials the board opens an access point **`whoisthis-cam-XXXX`** (steady LED blink).
Join it from the phone, open any page (or `http://192.168.4.1/`), enter your Wi-Fi name and
password; the board restarts and joins. Credentials are stored in NVS; `WIT_WIFI_SSID`/`WIT_WIFI_PASS`
in `config.h` are compile-time defaults for a fleet.

Then on the phone: WhoIsThis → Plugins → Microcontroller. The board appears by mDNS
(`whoisthis-cam-XXXX`); otherwise type its IP in the plugin screen.

## Protocol (`protocol` 1)

| Call | Answer |
|------|--------|
| `GET /whoisthis` | `{"id","model","firmware","protocol","capabilities":[…],"battery":87\|null,"stream_port":81,"camera":true,"rssi":-61,"uptime_s":…}` |
| `GET /capture?max=1280` | one `image/jpeg`, long side ≤ `max` (QVGA…UXGA steps) |
| `GET :81/stream?max=1280` | `multipart/x-mixed-replace;boundary=whoisthisframe`; every part has `Content-Type`, `Content-Length`, `X-Timestamp` |
| `GET /events?after=N` | `{"next":M,"events":[{"seq","name","detail"}]}`, names `tap` (`detail` = count), `long_press`, `battery` (percent). 16-deep ring; poll every ~400 ms. |
| `POST /present` | body `{"text":"…","show":true,"speak":true}` → OLED text when fitted, two LED blinks, buzzer chirp when fitted |
| `GET /` · `POST /wifi` | status page · `ssid=&pass=` form, saves and restarts |

mDNS: `_whoisthis._tcp` on port 80 with TXT `id`, `model`, `caps` (comma-separated contract ids),
`stream_port`, `fw`. `capabilities` lists only what the board confirmed at boot
(`display.text` only when the OLED answered on I²C, `battery` only when `WIT_BATTERY_PIN` is wired,
`input.*` only with a button pin). Unknown ids are ignored by the plugin, so a newer firmware never
makes it claim more than the contract knows.

Two HTTP servers: control on 80 (short requests) and the stream on 81, so a running stream never
blocks `/present` or `/events` (the ESP-IDF httpd serves one request at a time per instance).

## Wiring the options (`config.h`)

| Option | Default | Pins |
|--------|---------|------|
| Button (tap / long press) | on, `WIT_BUTTON_PIN 2` (D1) | momentary switch D1 → GND |
| Battery percent | off | BAT+ → 220 kΩ → A0 (GPIO1) → 220 kΩ → GND, `WIT_BATTERY_PIN 1` |
| OLED 128×64 SSD1306 | off | SDA D4 (GPIO5), SCL D5 (GPIO6), 3V3, GND; `WIT_OLED 1` |
| Buzzer | off | passive buzzer on a free pin, `WIT_BUZZER_PIN` |
| User LED | GPIO21 (on-board, active LOW) | — |

The LiPo (JST PH 2.0 on the EEMB pack) goes to the **BAT+ / BAT−** pads on the back of the XIAO:
the board has no battery connector, so cut the pack's plug off or crimp a JST 1.25 lead to a pigtail
and solder it to the pads (negative is the pad nearest the USB-C port). The on-board charger
charges the pack at 100 mA from USB-C.

## Power

Measured by Seeed with the expansion board: ~110 mA Wi-Fi active, ~140 mA average while streaming
(peaks ~350 mA during capture). The 250 mAh cell therefore gives **roughly 1.5 h of streaming**;
stills every 4 s with Wi-Fi modem sleep stretch that to several hours. See `../docs/blueprints`.
