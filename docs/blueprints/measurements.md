# Measurements

All sizes in millimetres. "Source" says where the number comes from; **measure** marks figures the
vendor does not publish and that must be confirmed with calipers on the actual parts before any
enclosure is printed. Tolerances for printed parts: allow 0.3 mm clearance per side around every
module, 0.5 mm around the battery.

## Seeed Studio XIAO ESP32-S3 Sense (bought: Amazon B0C69FFVHH, $19.19)

| Item | Size | Source |
|------|------|--------|
| XIAO ESP32-S3 main board (PCB footprint) | 21.0 × 17.8 | Seeed wiki, hardware overview |
| Main board thickness, USB-C shell included | ≈ 3.5 (PCB 1.0 + USB-C 3.2 top side, pads/charger on the back) | XIAO family drawing; **measure** |
| Sense expansion board (camera + PDM mic + microSD) | 21.0 × 17.5 PCB, mates with the main board through a board-to-board connector | Seeed wiki; **measure** |
| Full stack with camera module seated | 21.0 × 17.8 × **15.0** | Seeed wiki specs table |
| Stack without the camera module (board + expansion + B2B) | ≈ 8.5 | derived (15.0 − camera module); **measure** |
| Camera module (OV2640 or OV3660, 1/4" sensor) | sensor housing ≈ 8.5 × 8.5, lens barrel Ø ≈ 6, height ≈ 6.5 above the expansion board | typical module for this 24-pin DVP socket; **measure** |
| Camera FPC ribbon | 24-pin, 0.5 mm pitch, free length ≈ 20–25 (it can be unplugged and the sensor mounted away from the board) | Seeed wiki ("fixed with screws or placed anywhere using the extension cable"); **measure** |
| microSD slot | push-in, card protrudes ≈ 2 when fitted; on the expansion board's edge | **measure** |
| PDM microphone | on the expansion board top side, needs a ≥ 1 mm port if ever used | Seeed wiki |
| USB-C receptacle | on the main board's short edge, centred, ≈ 9 × 3.2 opening | **measure** |
| Pin headers | 2 × 7 pins, 2.54 mm pitch, on the 21 mm edges; **not soldered** on the bought variant | Seeed |
| BAT+ / BAT− pads | two pads on the back of the main board, next to the USB-C; **negative is the pad nearest the USB-C** | Seeed wiki |
| Reset / Boot buttons | side-firing tactile buttons on the main board's top side, next to USB-C | Seeed |
| Wi-Fi antenna | external, U.FL on the main board; the kit's flex antenna ≈ 20 × 8 × 1 on a ≈ 50 mm coax | Seeed kit contents; **measure** |
| Charge current | 100 mA fast / 0.9 mA trickle (charge LED red while charging) | Seeed wiki |
| Weight, full stack | ≈ 4 g; **measure** | — |
| Operating temperature | −20 … 65 °C | Seeed wiki |
| Current draw (expansion board fitted) | Wi-Fi active ≈ 110 mA; streaming webcam ≈ 140 mA avg, ≈ 350 mA peak; light sleep ≈ 5 mA; deep sleep ≈ 3 mA | Seeed wiki power table |

The kit box: one assembled Sense stack, the camera module on its ribbon, the flex antenna. No
headers, no battery, no case.

## EEMB LP502030 LiPo, 3.7 V 250 mAh, 4-pack (bought: $20.99)

| Item | Size | Source |
|------|------|--------|
| Cell code 50-20-30 = thickness-width-length | **5.0 × 20 × 30** (±0.2 / ±0.5 / ±1) | EEMB naming scheme |
| Protected pack as sold (PCM under tape adds length) | ≈ 5.3 × 20.5 × 31–32 | reseller datasheets; **measure** |
| Leads | red (+), black (−), 26 AWG, ≈ 50 mm (the picture shows a short lead) | listing; **measure** |
| Connector | JST PH **2.0 mm** 2-pin plug | listing |
| Energy, weight | 0.9 Wh, ≈ 3.5 g | label |
| Charge/discharge | 0.5 C standard charge (125 mA; the XIAO's 100 mA charger is fine), 1 C discharge max (250 mA continuous; the 350 mA capture peaks are short and covered by the board's input capacitors) | EEMB datasheet |

The XIAO has **no battery connector**: the pack's JST PH plug is cut off (or a 1.25 mm pigtail is
crimped on, see below) and the leads are soldered to BAT+/BAT−. Keep the PCM: the XIAO's charger
has no cut-off of its own.

## LYJEE JST 1.25 mm 2-pin pigtails, 10 pairs, 80 mm (bought: $5.99)

| Item | Size |
|------|------|
| Housing (female, with wires) | ≈ 6.0 × 3.6 × 4.5, 1.25 mm pitch |
| Wire | 28 AWG, red + black, 80 mm, pre-tinned ends |

Use: solder the **male** pigtail to BAT+/BAT− and splice the **female** one onto the battery, so a
battery can be swapped without reheating the pads. The pair occupies ≈ 8 × 4 × 5 inside the case.

## Q-MING 80 W soldering kit and LONELY BINARY starter kit

Tools and loose parts; nothing to enclose. From the starter kit the following are useful for the
builds: 6 × 6 mm tactile switches (12 mm long shaft variants fit a 2 mm wall), 220 kΩ resistors
(battery divider), 10 kΩ, LEDs, a slide switch, jumper wire, 1 µF–10 µF capacitors.

## Optional parts the candidates introduce

| Part | Size | Why |
|------|------|-----|
| 0.96" SSD1306 OLED module, 128 × 64, I²C | module 27.3 × 27.8 × 4.1, active area 21.7 × 10.9 | shows the label on a desk/door unit (`display.text`) |
| 0.42" SSD1306 OLED, 72 × 40 | 12 × 20 × 2.5 | fits a wearable; too small for names, fine for a 1-line hint |
| LP401230 LiPo, 110 mAh | 4 × 12 × 30 | slim temple clip |
| LP602030 LiPo, 300 mAh | 6 × 20 × 30 | same footprint, +20 % runtime |
| LP502540 LiPo, 500 mAh | 5 × 25 × 40 | fob / pendant with a whole-day stills budget |
| Neodymium magnets N52 Ø 8 × 2 (×2) and a steel backing plate | Ø 8 × 2 | magnetic lapel mount through fabric |
| 6 × 6 × 9 tactile switch with a 7–8 mm cap | 6 × 6 × 9 | tap / long-press button |
| 7 × 3.5 slide switch (SS12D00) | 8.6 × 3.5 × 4 | hard power cut for wearables |
| 2.4 GHz flex antenna 30 × 10, 100 mm coax | 30 × 10 × 1 | relocating the antenna away from the body/battery |
| M1.4 × 4 self-tapping screws | — | lid |
| 22 mm quick-release watch strap (wrist) / 20 mm webbing clip (brim) | — | mounts |

## Runtime arithmetic used in `candidates.md`

250 mAh × 0.85 usable ÷ 140 mA ≈ **1.5 h** continuous MJPEG at 1280 px.
Stills every 4 s with Wi-Fi modem sleep between captures: average ≈ 45 mA → ≈ **4.5 h**.
Deep sleep is not useful here: the Sense expansion board leaks ≈ 3 mA.
