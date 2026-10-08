#!/usr/bin/env python3
"""Dimensioned 2-D drawings (SVG) for the WhoIsThis blueprints.

The numbers here mirror the OpenSCAD files; run after changing either:
    python3 docs/blueprints/tools/drawings.py
Writes <design>/drawings/<view>.svg for the three designs.
"""
import os

S = 6.0          # px per mm
M = 70           # side margin px
MT = 150         # top margin px (room for the title and dimensions above the part)
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

class View:
    def __init__(self, title, w, h, note=""):
        self.title, self.w, self.h, self.note = title, w, h, note
        self.items = []

    def _x(self, x): return M + x * S
    def _y(self, y): return MT + (self.h - y) * S         # y up, like the SCAD

    def rect(self, x, y, w, h, label="", dashed=False, fill="none", stroke="#111", rx=0):
        self.items.append((self._rect, (x, y, w, h, label, dashed, fill, stroke, rx)))
        return self

    def circle(self, cx, cy, d, label="", dashed=False):
        self.items.append((self._circle, (cx, cy, d, label, dashed)))
        return self

    def dim_h(self, x1, x2, y, text=None, off=0):
        self.items.append((self._dim_h, (x1, x2, y, text, off)))
        return self

    def dim_v(self, y1, y2, x, text=None, off=0):
        self.items.append((self._dim_v, (y1, y2, x, text, off)))
        return self

    def _rect(self, x, y, w, h, label, dashed, fill, stroke, rx):
        d = ' stroke-dasharray="4 3"' if dashed else ""
        s = f'<rect x="{self._x(x):.1f}" y="{self._y(y + h):.1f}" width="{w * S:.1f}" height="{h * S:.1f}" rx="{rx * S:.1f}" fill="{fill}" stroke="{stroke}" stroke-width="1.2"{d}/>'
        if label:
            s += f'<text x="{self._x(x + w / 2):.1f}" y="{self._y(y + h / 2) + 4:.1f}" font-size="11" text-anchor="middle" fill="#334">{label}</text>'
        return s

    def _circle(self, cx, cy, d, label, dashed):
        dd = ' stroke-dasharray="4 3"' if dashed else ""
        s = f'<circle cx="{self._x(cx):.1f}" cy="{self._y(cy):.1f}" r="{d / 2 * S:.1f}" fill="none" stroke="#111" stroke-width="1.2"{dd}/>'
        s += f'<line x1="{self._x(cx) - 4:.0f}" y1="{self._y(cy):.1f}" x2="{self._x(cx) + 4:.0f}" y2="{self._y(cy):.1f}" stroke="#111" stroke-width="0.6"/>'
        s += f'<line x1="{self._x(cx):.1f}" y1="{self._y(cy) - 4:.0f}" x2="{self._x(cx):.1f}" y2="{self._y(cy) + 4:.0f}" stroke="#111" stroke-width="0.6"/>'
        if label:
            s += f'<text x="{self._x(cx) + d / 2 * S + 4:.1f}" y="{self._y(cy) + 4:.1f}" font-size="11" fill="#334">{label}</text>'
        return s

    def _dim_h(self, x1, x2, y, text, off):
        yy = self._y(y) + off
        t = text or f"{abs(x2 - x1):g}"
        X1, X2 = self._x(min(x1, x2)), self._x(max(x1, x2))
        return (f'<line x1="{X1:.1f}" y1="{yy:.1f}" x2="{X2:.1f}" y2="{yy:.1f}" stroke="#b00" stroke-width="0.8" marker-start="url(#a)" marker-end="url(#a)"/>'
                f'<line x1="{X1:.1f}" y1="{yy - 6:.1f}" x2="{X1:.1f}" y2="{yy + 6:.1f}" stroke="#b00" stroke-width="0.6"/>'
                f'<line x1="{X2:.1f}" y1="{yy - 6:.1f}" x2="{X2:.1f}" y2="{yy + 6:.1f}" stroke="#b00" stroke-width="0.6"/>'
                f'<text x="{(X1 + X2) / 2:.1f}" y="{yy - 4:.1f}" font-size="11" text-anchor="middle" fill="#b00">{t}</text>')

    def _dim_v(self, y1, y2, x, text, off):
        xx = self._x(x) + off
        t = text or f"{abs(y2 - y1):g}"
        Y1, Y2 = self._y(max(y1, y2)), self._y(min(y1, y2))
        return (f'<line x1="{xx:.1f}" y1="{Y1:.1f}" x2="{xx:.1f}" y2="{Y2:.1f}" stroke="#b00" stroke-width="0.8" marker-start="url(#a)" marker-end="url(#a)"/>'
                f'<line x1="{xx - 6:.1f}" y1="{Y1:.1f}" x2="{xx + 6:.1f}" y2="{Y1:.1f}" stroke="#b00" stroke-width="0.6"/>'
                f'<line x1="{xx - 6:.1f}" y1="{Y2:.1f}" x2="{xx + 6:.1f}" y2="{Y2:.1f}" stroke="#b00" stroke-width="0.6"/>'
                f'<text x="{xx + 4:.1f}" y="{(Y1 + Y2) / 2 + 4:.1f}" font-size="11" fill="#b00" transform="rotate(-90 {xx + 4:.1f} {(Y1 + Y2) / 2 + 4:.1f})" text-anchor="middle">{t}</text>')

    def svg(self):
        W, H = max(self.w * S + 2 * M + 160, 1000), self.h * S + MT + M + 60
        body = "".join(fn(*args) for fn, args in self.items)
        return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W:.0f}" height="{H:.0f}" viewBox="0 0 {W:.0f} {H:.0f}" font-family="Helvetica, Arial, sans-serif">'
                f'<defs><marker id="a" markerWidth="6" markerHeight="6" refX="3" refY="3" orient="auto"><circle cx="3" cy="3" r="1.5" fill="#b00"/></marker></defs>'
                f'<rect width="100%" height="100%" fill="#fff"/>'
                f'<text x="{M}" y="30" font-size="15" font-weight="bold" fill="#111">{self.title}</text>'
                f'<text x="{M}" y="48" font-size="11" fill="#555">{self.note}  ·  all dimensions mm, 1 px = {1 / S:.3f} mm</text>'
                f'{body}</svg>')


def write(design, name, view):
    d = os.path.join(ROOT, design, "drawings")
    os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, name + ".svg"), "w") as f:
        f.write(view.svg())


# ----------------------------------------------------------------------------- lapel badge
def lapel_badge():
    W, H, D = 56, 31, 14.5
    wall = 1.6
    # front view: what the other person sees (lens window, mic hole); X across, Y up
    v = View("Lapel badge — front face (seen from the other person)", W, H, "Shell floor = front. Lid with magnets is the back.")
    v.rect(0, 0, W, H, rx=3)
    v.rect(1.9, 1.9, 21, 17.8, "XIAO stack (behind)", dashed=True)
    v.circle(12.4, 24.45, 7.0, "Ø7 (Ø11×0.6 recess)")
    v.rect(8.15, 20.2, 8.5, 8.5, "", dashed=True)
    v.rect(23.9, 2.1, 30, 20, "LP502030 (behind)", dashed=True)
    v.rect(24.9, 22.9, 6, 3.6, "", dashed=True)
    v.rect(24.4, 1.6, 20, 8, "antenna", dashed=True)
    v.circle(18.9, 4.9, 1.2, "mic")
    v.rect(40, 24.4, 6, 5, "btn", dashed=True)
    v.dim_h(0, W, -2.5, off=14)
    v.dim_v(0, H, W + 2, off=10)
    v.dim_h(0, 12.4, H + 2, "12.4 to lens", off=-14)
    v.dim_v(0, 24.45, -3, "24.45", off=-10)
    v.dim_h(0, 43, H + 6, "43 to button (on top edge)", off=-26)
    write("lapel-badge", "front", v)

    # top edge view: X across, Z (depth) up — USB-C is on the left end, button on this edge
    v = View("Lapel badge — top edge (+Y) and left end (−X) cut-outs", W, D, "Depth: 1.6 front wall + 8.9 cavity + 1.2 lip + 2.6 magnet lid")
    v.rect(0, 0, W, D)
    v.rect(0, 11.9, W, 2.6, "lid (back, magnets inside)", fill="#eef")
    v.circle(43, 5.0, 4.4, "Ø4.4 plunger hole, Ø8 cap outside")
    v.rect(-6.5 + 0, 0, 0.01, 0.01)  # keep bounds
    v.dim_v(0, D, W + 2, "14.5", off=10)
    v.dim_v(0, 5.0, -3, "5.0", off=-10)
    v.dim_h(0, 43, -2, "43", off=14)
    write("lapel-badge", "top-edge", v)

    v = View("Lapel badge — left end (−X): USB-C plug cut-out and charge LED", H, D, "Plug cut-out 13 × 7 centred on the receptacle; LED pipe Ø1.5")
    v.rect(0, 0, H, D)
    v.rect(0, 11.9, H, 2.6, "lid", fill="#eef")
    v.rect(10.8 - 6.5, 7.8 - 3.5, 13, 7, "USB-C 13 × 7")
    v.circle(10.8 + 8.5, 8.8, 1.5, "LED")
    v.dim_h(0, 10.8, -2, "10.8", off=14)
    v.dim_v(0, 7.8, -3, "7.8", off=-10)
    v.dim_h(0, H, D + 2, off=-14)
    write("lapel-badge", "left-end", v)

    # section through the camera (Y–Z)
    v = View("Lapel badge — section A-A through the lens (Y–Z)", H, D, "Camera module on its ribbon beside the board; board socket faces the front")
    v.rect(0, 0, H, D)
    v.rect(0, 0, H, 1.6, "front wall", fill="#ddd")
    v.rect(1.9, 1.9, 17.8, 8.5, "XIAO stack (sense board toward front)", fill="#dfd")
    v.rect(20.2, 2.0, 8.5, 4.5, "camera", fill="#ccc")
    v.rect(22.75, 0.4, 3.4, 1.6, "", fill="#999")
    v.rect(0, 11.9, H, 2.6, "lid 2.6 (magnet pockets 2.2 deep)", fill="#eef")
    v.dim_v(1.9, 10.4, H + 2, "8.5 stack", off=10)
    v.dim_v(0, 14.5, -3, "14.5", off=-10)
    v.dim_h(1.9, 19.7, -2, "17.8", off=14)
    v.dim_h(20.2, 28.7, -2, "8.5", off=28)
    write("lapel-badge", "section-aa", v)


# ----------------------------------------------------------------------------- cap-brim clip
def cap_brim_clip():
    W, L, D = 46, 36, 14.5
    v = View("Cap-brim clip — plan (seen from below, the button side)", W, L, "Front wall (camera) at the bottom of the drawing; brim is behind the lid")
    v.rect(0, 0, W, L, rx=3)
    v.rect(1.9, 6.9, 21, 17.8, "XIAO stack", dashed=True)
    v.rect(8.15, 2.0, 8.5, 4.5, "cam", dashed=True)
    v.rect(23.9, 2.1, 20, 30, "LP502030", dashed=True)
    v.rect(24.4, 9.6, 8, 20, "antenna", dashed=True)
    v.circle(38.9, 19.1, 4.4, "Ø4.4 button hole (floor)")
    v.rect(35.9, 16.1, 6, 6, "", dashed=True)
    v.dim_h(0, W, -2.5, off=14)
    v.dim_v(0, L, W + 2, off=10)
    v.dim_h(0, 38.9, L + 2, "38.9", off=-14)
    v.dim_v(0, 19.1, -3, "19.1", off=-10)
    v.dim_v(0, 6.9, W + 6, "6.9 cam→board", off=24)
    write("cap-brim-clip", "plan", v)

    v = View("Cap-brim clip — front wall (−Y): lens and mic", W, D, "Lens Ø7 window with Ø11 × 0.6 recess; the brim sits on the lid above")
    v.rect(0, 0, W, D)
    v.rect(0, 11.9, W, 2.6, "lid (magnets) — brim above", fill="#eef")
    v.circle(12.4, 6.15, 7.0, "Ø7 lens")
    v.circle(20.4, 8.15, 1.2, "mic")
    v.dim_h(0, 12.4, -2, "12.4", off=14)
    v.dim_v(0, 6.15, -3, "6.15", off=-10)
    v.dim_v(0, D, W + 2, "14.5", off=10)
    write("cap-brim-clip", "front", v)

    v = View("Cap-brim clip — left end (−X): USB-C plug cut-out", L, D, "13 × 7 cut-out centred on the receptacle; LED pipe Ø1.5")
    v.rect(0, 0, L, D)
    v.rect(0, 11.9, L, 2.6, "lid", fill="#eef")
    v.rect(15.8 - 6.5, 7.8 - 3.5, 13, 7, "USB-C 13 × 7")
    v.circle(15.8 + 8.5, 8.8, 1.5, "LED")
    v.dim_h(0, 15.8, -2, "15.8", off=14)
    v.dim_v(0, 7.8, -3, "7.8", off=-10)
    write("cap-brim-clip", "left-end", v)

    v = View("Cap-brim clip — top plate (sits on the brim)", W, L, "3 mm plate, two Ø8.4 × 2.2 magnet pockets opening downward, polarity opposite to the lid")
    v.rect(0, 0, W, L, rx=3)
    v.circle(12, 18, 8.4, "Ø8.4")
    v.circle(34, 18, 8.4, "Ø8.4")
    v.dim_h(12, 34, -2.5, "22", off=14)
    v.dim_v(0, 18, -3, "18", off=-10)
    write("cap-brim-clip", "top-plate", v)


# ----------------------------------------------------------------------------- fob
def fob():
    L, W, D = 74, 29, 13.9
    v = View("Point-and-ask fob — plan (lid removed)", L + 8, W + 8, "Nose (lens) on the left, tail (button, slide switch, key ring) on the right")
    v.rect(0, 0, L, W, rx=3)
    v.rect(2.0, 10.25, 4.5, 8.5, "cam", dashed=True)
    v.rect(7.0, 4.0, 17.8, 21, "XIAO (USB-C ↑)", dashed=True)
    v.rect(25.8, 2.1, 40, 25, "LP502540", dashed=True)
    v.rect(33.8, 10.6, 20, 8, "antenna", dashed=True)
    v.rect(67.4, 7.5, 5, 6, "btn", dashed=True)
    v.rect(68.8, 17.2, 3.6, 8.6, "slide", dashed=True)
    v.circle(70, -2.5, 4, "Ø4 key ring")
    v.circle(70, -2.5, 9, "", dashed=True)
    v.dim_h(0, L, -7, off=14)
    v.dim_v(0, W, L + 7, off=10)
    v.dim_h(0, 7.0, W + 2, "7", off=-14)
    v.dim_h(0, 25.8, W + 2, "25.8", off=-28)
    v.dim_h(0, 66.3, W + 2, "66.3 tail wall", off=-42)
    write("point-and-ask-fob", "plan", v)

    v = View("Point-and-ask fob — tail (+X): button, slide switch", W, D, "Ø4.4 plunger hole with Ø10 cap; 5 × 2 slot for the SS12D00 knob")
    v.rect(0, 0, W, D)
    v.rect(0, 11.9, W, 2.0, "lid", fill="#eef")
    v.circle(10.5, 5.0, 4.4, "Ø4.4 button")
    v.rect(19.0, 3.0, 5, 2, "slot 5 × 2")
    v.dim_h(0, 10.5, -2, "10.5", off=14)
    v.dim_h(0, 21.5, -2, "21.5", off=28)
    v.dim_v(0, 5.0, -3, "5.0", off=-10)
    v.dim_v(0, D, W + 2, "13.9", off=10)
    write("point-and-ask-fob", "tail", v)

    v = View("Point-and-ask fob — nose (−X): lens and mic", W, D, "Ø7 lens window, Ø11 × 0.6 recess")
    v.rect(0, 0, W, D)
    v.rect(0, 11.9, W, 2.0, "lid", fill="#eef")
    v.circle(14.5, 6.15, 7.0, "Ø7 lens")
    v.circle(22.5, 6.15, 1.2, "mic")
    v.dim_h(0, 14.5, -2, "14.5", off=14)
    v.dim_v(0, 6.15, -3, "6.15", off=-10)
    write("point-and-ask-fob", "nose", v)

    v = View("Point-and-ask fob — right side (+Y): USB-C plug cut-out", L, D, "13 × 7 cut-out; LED pipe Ø1.5")
    v.rect(0, 0, L, D)
    v.rect(0, 11.9, L, 2.0, "lid", fill="#eef")
    v.rect(15.9 - 6.5, 7.8 - 3.5, 13, 7, "USB-C 13 × 7")
    v.circle(15.9 - 8.5, 8.8, 1.5, "LED")
    v.dim_h(0, 15.9, -2, "15.9", off=14)
    v.dim_v(0, 7.8, -3, "7.8", off=-10)
    write("point-and-ask-fob", "side", v)


if __name__ == "__main__":
    lapel_badge()
    cap_brim_clip()
    fob()
    print("drawings written")
