// WhoIsThis cap-brim clip — XIAO ESP32-S3 Sense + LP502030, magnets through the brim.
// Hangs under the brim: lid (top, with magnets) touches the brim, camera looks forward (-Y) from
// the front wall, button on the underside. A matching top plate with magnets sits on the brim.
//   openscad -D part='"shell"' -o shell.stl cap-brim-clip.scad   (also: lid, plate, cap, preview)
include <../lib/parts.scad>

part = "preview";

batt    = batt_502030;
shell_h = wall + clr + stack_h + clr + lip_h;          // 11.9
outer   = [46, 36, shell_h];
total_depth = shell_h + mag_lid_t;                      // 14.5

cam_c     = [wall + clr + xiao_pcb[0] / 2, 0, wall + clr + cam_body[1] / 2];  // lens centre x, z on the front wall
cam_body_y = wall + 0.4;                                // body starts just behind the lens recess
board_pos = [wall + clr, cam_body_y + cam_body[2] + 0.5];  // [1.9, 6.9]; 21 x 17.8, USB-C toward -X
z_socket  = wall + clr;
z_pcb_top = z_socket + stack_h;                          // 10.4
usb_c     = [board_pos[1] + xiao_pcb[1] / 2, z_pcb_top - xiao_pcb[2] - usbc[2] / 2];
batt_pos  = [board_pos[0] + xiao_pcb[0] + 1.0, wall + bclr, z_pcb_top - batt[2]];  // 30 along Y, against the lid
ant_pos   = [batt_pos[0] + 0.5, wall + 8, wall];        // 8 x 20 flex lying across Y under the battery
btn_c     = [batt_pos[0] + 15, batt_pos[1] + 17];       // x, y of the plunger in the floor
tact_low  = [6, 6, 3.1];                                 // low-profile 6x6x3.1 tactile (added part)
mags      = [[12, outer[1] / 2], [34, outer[1] / 2]];
plug_cut  = [13, 7];

module shell_part() {
    difference() {
        shell(outer);
        // lens window in the front (-Y) wall, recessed 0.6
        translate([cam_c[0], -1, cam_c[2]]) rotate([-90, 0, 0]) cylinder(d = cam_lens_d + 1.0, h = wall + 2);
        translate([cam_c[0], -0.01, cam_c[2]]) rotate([-90, 0, 0]) cylinder(d = 11, h = 0.6);
        // USB-C plug through the -X wall
        translate([-1, usb_c[0] - plug_cut[0] / 2, usb_c[1] - plug_cut[1] / 2]) cube([wall + 2, plug_cut[0], plug_cut[1]]);
        // button plunger through the floor
        translate([btn_c[0], btn_c[1], -1]) cylinder(d = 4.4, h = wall + 2);
        // charge LED light pipe, -X wall
        translate([-1, usb_c[0] + 8.5, usb_c[1] + 1]) rotate([0, 90, 0]) cylinder(d = 1.5, h = wall + 2);
        // mic port, front wall beside the lens
        translate([cam_c[0] + 8, -1, cam_c[2] + 2]) rotate([-90, 0, 0]) cylinder(d = 1.2, h = wall + 2);
    }
    // camera cradle: a U that holds the module upright against the front wall
    translate([cam_c[0] - cam_body[0] / 2 - clr - 1, cam_body_y - 0.4, wall]) cube([1, cam_body[2] + 1.4, cam_body[1]]);
    translate([cam_c[0] + cam_body[0] / 2 + clr, cam_body_y - 0.4, wall]) cube([1, cam_body[2] + 1.4, cam_body[1]]);
    translate([cam_c[0] - cam_body[0] / 2 - clr - 1, cam_body_y + cam_body[2] + clr, wall]) cube([cam_body[0] + 2 * clr + 2, 1, 4]);
    // battery rail between board and cell
    translate([batt_pos[0] - 1.0, wall, wall]) cube([1.0, outer[1] - 2 * wall, 6]);
    // switch pocket in the floor under the battery
    for (dx = [-1, 1]) translate([btn_c[0] + dx * (3 + clr + 0.5) - 0.5, btn_c[1] - 3 - clr, wall]) cube([1, 6 + 2 * clr, 2.5]);
}

module lid_part() {
    difference() {
        lid(outer, mag_lid_t);
        magnet_pockets(mags);
    }
}

// Sits on top of the brim; pockets open downward, magnets in opposite polarity to the lid's.
module top_plate() {
    difference() {
        rbox([outer[0], outer[1], 3]);
        for (m = mags) translate([m[0], m[1], -0.01]) cylinder(d = mag_d + 0.4, h = mag_h + 0.2);
    }
}

module button_cap() {
    cylinder(d = 9, h = 1.2);
    translate([0, 0, 1.2]) cylinder(d = 4.0, h = wall + 0.6);
}

module preview() {
    shell_part();
    translate([board_pos[0], board_pos[1], z_pcb_top]) mirror([0, 0, 1]) xiao_stack();
    translate([cam_c[0] - cam_body[0] / 2, cam_body_y + cam_body[2], cam_c[2] - cam_body[1] / 2]) rotate([90, 0, 0]) camera_module();
    translate(batt_pos) battery([batt[1], batt[0], batt[2]]);   // 30 mm runs along Y
    color("#d4a017") translate(ant_pos) cube([antenna_flex[1], antenna_flex[0], antenna_flex[2]]);
    translate([btn_c[0] - 3, btn_c[1] - 3, wall + tact_low[2]]) mirror([0, 0, 1]) color("#444") cube(tact_low);
    color("#9ad", 0.5) translate([0, 0, shell_h + 6]) lid_part();
    color("#8a6", 0.5) translate([0, 0, shell_h + 14]) top_plate();
    color("#e33") translate([btn_c[0], btn_c[1], -1.2]) mirror([0, 0, 1]) button_cap();
}

if (part == "shell") shell_part();
else if (part == "lid") lid_part();
else if (part == "plate") top_plate();
else if (part == "cap") button_cap();
else preview();

echo(str("outer envelope: ", outer[0], " x ", outer[1], " x ", total_depth, " mm (+3 mm top plate on the brim)"));
