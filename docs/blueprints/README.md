# Blueprints: a WhoIsThis camera built on the XIAO ESP32-S3 Sense

This folder holds the physical designs for the microcontroller device: the dimension sheet, the
catalogue of form factors (with the people they were designed around and the ways to make them),
and one folder per built design with an OpenSCAD model, STL files, dimensioned SVG drawings, a bill
of materials, wiring, assembly steps and the firmware `config.h` for that build.

| Path | What |
|------|------|
| [`measurements.md`](measurements.md) | Exact sizes of the board, camera, battery, cables and the optional parts, with sources and what still has to be measured on the bench; the print allowances the models use. |
| [`candidates.md`](candidates.md) | 21 form factors with envelopes and notes, which shape each of 17 personas would pick, 11 fabrication methods, and the follow-ups they imply. |
| [`personas.md`](personas.md) | How each persona would *use* it: companion / ask / post styles, trigger, answer channel, consent ritual, charging habits, and the firmware and app features those needs rank first. |
| [`lapel-badge/`](lapel-badge/) | **Built.** 56 × 31 × 14.5 mm magnetic chest badge; `bail = true` makes it a pendant. |
| [`cap-brim-clip/`](cap-brim-clip/) | **Built.** 46 × 36 × 14.5 mm box under a cap brim, magnets through the brim, button underneath. |
| [`point-and-ask-fob/`](point-and-ask-fob/) | **Built.** 74 × 29 × 13.9 mm key fob, camera in the nose, tail button and power switch, 500 mAh. |
| `lib/parts.scad` | Part models, print allowances and the shell/lid/magnet helpers every design includes. |
| `tools/drawings.py` | Generates the dimensioned SVG drawings from the same numbers as the models. |

## Regenerate

```sh
sudo apt install openscad            # or the AppImage
cd docs/blueprints/lapel-badge
for p in shell lid cap; do openscad -q -D "part=\"$p\"" -o stl/lapel-badge-$p.stl lapel-badge.scad; done
openscad -o preview.png --imgsize=1400,900 --camera=28,15,7,55,0,35,260 --projection=p lapel-badge.scad
python3 ../tools/drawings.py
```

Print all shells floor-down with no supports: PETG, 0.2 mm layers, 4 perimeters, 20 % infill.
Before printing the first one, measure the four values marked **measure** in `measurements.md`
(stack height, camera body, ribbon length, battery pack) and update `lib/parts.scad`.
