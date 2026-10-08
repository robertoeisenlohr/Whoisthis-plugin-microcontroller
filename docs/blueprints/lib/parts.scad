// Part models and enclosure helpers shared by the WhoIsThis blueprints.
// All sizes in mm. Figures marked "measure" in measurements.md are parameters here, so a bench
// measurement is a one-line change and every design follows.

// ---- bought parts -----------------------------------------------------------------------------
xiao_pcb      = [21.0, 17.8, 1.0];   // main board; USB-C on a 17.8 mm edge, pointing along X
stack_h       = 8.5;                 // main PCB underside → top of the (empty) camera socket, measure
usbc          = [8.9, 7.3, 3.2];     // receptacle: width, depth along X, height; 1.3 mm proud of the edge
usbc_proud    = 1.3;
cam_body      = [8.5, 8.5, 4.5];     // sensor housing (measure)
cam_lens_d    = 6.0;  cam_lens_h = 2.0;
cam_ribbon_w  = 13.5; cam_ribbon_l = 22;   // free FPC length (measure)
batt_502030   = [30.0, 20.0, 5.3];   // protected pack
batt_502540   = [40.0, 25.0, 5.3];
batt_401230   = [30.0, 12.0, 4.2];
tact_6x6      = [6.0, 6.0, 5.0];     // body; plunger adds 1.5 (6x6x5) or 4 (6x6x9 "tall" plunger)
tact_plunger_d = 3.5;
mag_d = 8.0; mag_h = 2.0;            // N52 disc magnets
jst125        = [6.0, 3.6, 4.5];     // 1.25 mm 2-pin housing
antenna_flex  = [20, 8, 1.0];        // kit flex antenna (measure)

// ---- print parameters ------------------------------------------------------------------------
wall  = 1.6;    // 4 perimeters at 0.4 mm
clr   = 0.3;    // per side around rigid parts
bclr  = 0.5;    // per side around the battery (it swells a little over its life)
lid_t = 2.0;    // plain lid thickness
mag_lid_t = 2.6;// lid with magnet pockets: 2.2 pocket + 0.4 skin
lip_h = 1.2; lip_clr = 0.15;
rnd   = 3.0;    // outer corner radius
$fn = 48;

module rbox(size, r = rnd) {
    // rounded-vertical-edge box, origin at the min corner
    translate([r, r, 0]) linear_extrude(size[2]) offset(r) square([size[0] - 2 * r, size[1] - 2 * r]);
}

// Open-top shell: outer size, cavity = outer minus walls, floor = wall. Lid goes on +Z.
module shell(outer) {
    difference() {
        rbox(outer);
        translate([wall, wall, wall]) rbox([outer[0] - 2 * wall, outer[1] - 2 * wall, outer[2]], rnd - wall);
    }
}

// Lid with an inner lip that drops into the cavity. `thick` is the plate.
module lid(outer, thick = lid_t) {
    rbox([outer[0], outer[1], thick]);
    translate([wall + lip_clr, wall + lip_clr, -lip_h])
        difference() {
            rbox([outer[0] - 2 * (wall + lip_clr), outer[1] - 2 * (wall + lip_clr), lip_h], rnd - wall);
            translate([1.0, 1.0, -1]) rbox([outer[0] - 2 * (wall + lip_clr) - 2, outer[1] - 2 * (wall + lip_clr) - 2, lip_h + 2], max(rnd - wall - 1, 0.5));
        }
}

// Two magnet pockets in a lid, opened from the inside (-Z), leaving a 0.4 skin.
module magnet_pockets(positions, h = mag_h) {
    for (p = positions) translate([p[0], p[1], -0.01]) cylinder(d = mag_d + 0.4, h = h + 0.2);
}

// ---- part mock-ups for the fit preview --------------------------------------------------------
module xiao_stack(with_camera = false) {
    color("#1f6f3a") cube(xiao_pcb);                                   // main PCB
    color("#c0c0c0") translate([-usbc_proud, (xiao_pcb[1] - usbc[0]) / 2, xiao_pcb[2]]) cube([usbc[1], usbc[0], usbc[2]]);
    color("#2a2a2a") translate([6, 3, xiao_pcb[2]]) cube([13, 12, 3]);  // ESP32-S3 module
    color("#1f6f3a") translate([0, 0.15, stack_h - 3.0]) cube([21, 17.5, 1.0]);  // Sense board
    color("#333") translate([6.5, 4.5, stack_h - 2.0]) cube([10, 9, 2.0]);        // camera socket
    if (with_camera) translate([7.25, 5.5, stack_h]) camera_module();
}

module camera_module() {
    color("#111") cube(cam_body);
    color("#222") translate([cam_body[0] / 2, cam_body[1] / 2, cam_body[2]]) cylinder(d = cam_lens_d, h = cam_lens_h);
}

module battery(size) { color("#b9b9b9") cube(size); }
module tact() { color("#444") cube(tact_6x6); color("#222") translate([3, 3, tact_6x6[2]]) cylinder(d = tact_plunger_d, h = 1.5); }
module magnet() { color("#777") cylinder(d = mag_d, h = mag_h); }
