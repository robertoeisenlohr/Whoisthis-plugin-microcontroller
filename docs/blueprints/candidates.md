# Form-factor candidates

Six ways to wear or place the same electronics: XIAO ESP32-S3 Sense stack (21 × 17.8 × 15 mm, or
21 × 17.8 × 8.5 mm with the camera moved to the end of its ribbon), the LP502030 cell
(5 × 20 × 30 mm) unless noted, the flex antenna, a tactile button, and a JST 1.25 battery pigtail.
Sizes are outer envelopes of a 1.6 mm-wall printed shell with 0.3 mm clearances. Runtime figures
come from the arithmetic in `measurements.md`.

What all six share, because the contract and the app expect it:

- **Camera forward, at eye or chest height** – the app's face pipeline wants faces ≥ 80 px in a
  1280 px frame, i.e. a person inside ≈ 3 m.
- **One button** – `tap` asks the app for a lookup / `long_press` stops the stream (the app decides;
  the firmware only reports).
- **A visible indicator** – the on-board LED blinks when a label is presented; the device should not
  look like a hidden camera.
- **USB-C reachable** for charging and flashing without opening the case.
- **Antenna away from the battery and the body**, lens window clear of the wall, mic port optional.

| # | Candidate | Envelope (mm) | Weight | Streaming / stills runtime | Accessories changed | Best for |
|---|-----------|---------------|--------|----------------------------|---------------------|----------|
| 1 | **Lapel pin** | 28 × 36 × 13 | ≈ 14 g | 1.5 h / 4.5 h | + 2 magnets Ø8×2 + steel back plate | Daily wear on a shirt or jacket; the most "WhoIsThis" of the six |
| 2 | **Pendant** | Ø 36 × 13 | ≈ 15 g | 1.5 h / 4.5 h | + lanyard bail; optional 602030 cell (+20 %) | Hands-free, works on any clothing, sits exactly at chest height |
| 3 | **Cap-brim clip** | 44 × 24 × 10 | ≈ 14 g | 1.5 h / 4.5 h | + 20 mm spring clip | Best viewpoint (eye level, looks where you look), thinnest shell |
| 4 | **Glasses temple clip** | 58 × 20 × 11 tapering to 7 | ≈ 12 g | 0.7 h / 2 h | **swap** cell for LP401230 (110 mAh); camera on its ribbon | Closest to the glasses plugin experience; for people who already wear glasses |
| 5 | **Point-and-ask fob** | 54 × 26 × 13 | ≈ 22 g | 3 h / 9 h | **swap** cell for LP502540 (500 mAh); big 12 mm button | Deliberate, visible use: press, the board takes one still, the app answers |
| 6 | **Door / desk puck with display** | 62 × 44 × 20 | ≈ 45 g | mains (USB-C) | **drop** the battery; + 0.96" OLED, + 2.4 GHz antenna 30×10 | Reception desk, front door, meeting room: shows the name on the device itself (`display.text`) |

## 1. Lapel pin

```
 front (28 × 36)            side (13 deep)
 ┌────────────┐             ┌───┐
 │   ◉ lens   │  ← camera   │▐ │ camera module on the stack, lens 1 mm behind the window
 │  ●  LED    │             │█ │ XIAO stack, USB-C facing DOWN through the shell's bottom edge
 │            │             │▒ │ battery 5 mm flat behind the board
 │ [button]   │  ← top edge │   │ magnet pockets in the back wall
 └────────────┘             └───┘
```

- Board stands upright, USB-C at the bottom edge (charge while pinned, cable hangs down).
- Battery behind the board, between it and the back plate; the two magnets sit beside the battery.
  A steel plate under the shirt holds it; no pin to pierce fabric.
- Antenna flex glued to the inside of the front face, above the lens, farthest from the battery.
- Button on the top edge (thumb finds it without looking).
- Risk: 13 mm proud of the chest; a jacket flap can cover the lens.

## 2. Pendant

Same stack as the pin, round shell, the ribbon lets the lens sit dead centre with the stack
behind it. Battery in the lower half, bail at the top. Runs on a 3 mm lanyard; a 602030 cell adds
20 % with 1 mm more depth. Swings when you walk: the app's quality gates already reject blurred
frames, so stills at 4 s are the natural mode here, streaming when standing still.

## 3. Cap-brim clip

```
 top view (44 × 24), 10 mm thick
 ┌──────────────────────────────┐
 │ [XIAO 21×17.8]  [battery 30×20] │   board and cell side by side, not stacked → 10 mm thin
 │  ◉ lens at the front edge      │   camera module clipped to the brim's front lip
 └──────────────────────────────┘
```

- Flattest because nothing stacks; the camera on its ribbon looks out from under the brim.
- Spring clip (or two slots for the brim itself) on the underside; USB-C at the back edge.
- Very stable image (the head moves less than the chest) and looks exactly where the wearer looks.
- Needs a cap. Lens window must be hooded against sun; the brim does most of that.

## 4. Glasses temple clip

- The slim one. The main board sits in a 22 × 20 × 11 mm pod right behind the hinge, hidden by the
  frame front; a 4 × 12 × 30 mm cell runs back along the temple in a 7 mm channel; the camera on its
  ribbon looks forward from the pod's front face.
- Clip: two silicone-lined fingers around the temple, like an aftermarket camera light.
- Shortest runtime (110 mAh): 40 min streaming, 2 h stills. Fine for "walk into the event, look
  around" use; weak for a whole day.
- 12 g on one temple is noticeable; keep the pod as far forward as possible.

## 5. Point-and-ask fob

```
 54 × 26 × 13, pill shaped
 ┌─[ ◉ lens ]────────────────────────┐
 │  XIAO stack   │  LP502540 cell    │  big 12 mm button on top, slide power switch on the side
 └──────────────USB-C────────────────┘
```

- A different interaction: the device is in the hand, pointed at someone, and a press takes one
  still. Nothing streams unless the user holds the button. Visible, consensual, easy to explain.
- The 500 mAh cell gives a whole day of occasional use; the firmware's "stills on tap" mode and
  Wi-Fi modem sleep cover the rest (small firmware addition: `GET /capture` on tap only).
- Fits a key ring; least "wearable camera" of the six, the easiest to put down.

## 6. Door / desk puck with display

- Stationary: screwed next to a door or standing on a desk, USB-C powered, no battery.
- The 0.96" OLED shows the label the app sends with `present()` (`display.text`), the button
  acknowledges; the camera window faces the visitor at ≈ 1.4 m height.
- The flex antenna is replaced by a 30 × 10 mm antenna on a 100 mm coax to clear the wall.
- Streams all day; the phone running WhoIsThis has to stay on the same Wi-Fi.
- Changes the product story (a fixed camera recognising visitors) and the consent conversation; the
  firmware already supports every part of it.

## What I would pick

**Lapel pin (1)** as the first build: it is the use the app is designed for, the parts you bought
cover it entirely, and the magnetic mount means no sewing or clips. **Cap-brim clip (3)** is the
better camera position if you will wear a cap anyway, and it is the thinnest shell. **Door puck (6)**
is worth a second blueprint later because it exercises `display.text` and `input.tap` on real
hardware.

A full blueprint for the chosen one(s) will contain: dimensioned front/side/section drawings,
an OpenSCAD model exporting STL (shell + lid + button cap), a wiring diagram with the JST 1.25
pigtail, the battery divider and the button, a print/assembly sequence, and the firmware
`config.h` for that build.
