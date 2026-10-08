// WhoIsThis point-and-ask fob — XIAO ESP32-S3 Sense + LP502540, tail button, key ring.
// Camera in the nose (-X), board behind it (USB-C out of the +Y side), battery along the body,
// tactile button and power slide switch in the tail (+X). Lid is the top.
//   openscad -D part='"shell"' -o shell.stl point-and-ask-fob.scad   (also: lid, cap, preview)
include <../lib/parts.scad>

part = "preview";

batt    = batt_502540;
shell_h = wall + clr + stack_h + clr + lip_h;           // 11.9
outer   = [74, 29, shell_h];
total_depth = shell_h + lid_t;                           // 13.9

iy        = outer[1] - 2 * wall;                         // 25.8 interior width
cam_c     = [0, outer[1] / 2, wall + clr + cam_body[1] / 2];   // lens centre y, z on the nose wall
cam_body_x = wall + 0.4;
board_pos = [cam_body_x + cam_body[2] + 0.5, wall + (iy - xiao_pcb[0]) / 2];  // 17.8 along X, 21 along Y, USB-C toward +Y
z_socket  = wall + clr;
z_pcb_top = z_socket + stack_h;
usb_c     = [board_pos[0] + xiao_pcb[1] / 2, z_pcb_top - xiao_pcb[2] - usbc[2] / 2];   // x, z centre on the +Y wall
batt_pos  = [board_pos[0] + xiao_pcb[1] + 1.0, wall + bclr, z_pcb_top - batt[2]];
ant_pos   = [batt_pos[0] + 8, wall + 9, wall];
tail_x    = batt_pos[0] + batt[0] + bclr + 0.5;          // start of the tail compartment
btn_c     = [outer[1] / 2 - 4, 5.0];                     // y, z of the plunger on the +X wall
slide_c   = [outer[1] / 2 + 7, 4.0];                     // y, z of the SS12D00 knob slot
ring_c    = [outer[0] - 4, -2.5];                        // key-ring lobe at the tail/-Y corner
plug_cut  = [13, 7];

module shell_part() {
    difference() {
        union() {
            shell(outer);
            translate([ring_c[0], ring_c[1], 0]) cylinder(d = 9, h = shell_h);          // key-ring lobe
        }
        translate([ring_c[0], ring_c[1], -1]) cylinder(d = 4, h = shell_h + 2);
        // lens window in the nose, recessed 0.6
        translate([-1, cam_c[1], cam_c[2]]) rotate([0, 90, 0]) cylinder(d = cam_lens_d + 1.0, h = wall + 2);
        translate([-0.01, cam_c[1], cam_c[2]]) rotate([0, 90, 0]) cylinder(d = 11, h = 0.6);
        // USB-C plug through the +Y wall
        translate([usb_c[0] - plug_cut[0] / 2, outer[1] - wall - 1, usb_c[1] - plug_cut[1] / 2]) cube([plug_cut[0], wall + 2, plug_cut[1]]);
        // charge LED light pipe, +Y wall
        translate([usb_c[0] - 8.5, outer[1] - wall - 1, usb_c[1] + 1]) rotate([-90, 0, 0]) cylinder(d = 1.5, h = wall + 2);
        // tail: button plunger and slide-switch knob slot
        translate([outer[0] - wall - 1, btn_c[0], btn_c[1]]) rotate([0, 90, 0]) cylinder(d = 4.4, h = wall + 2);
        translate([outer[0] - wall - 1, slide_c[0] - 2.5, slide_c[1] - 1]) cube([wall + 2, 5, 2]);
        // mic port, nose beside the lens
        translate([-1, cam_c[1] + 8, cam_c[2]]) rotate([0, 90, 0]) cylinder(d = 1.2, h = wall + 2);
    }
    // camera cradle against the nose wall
    translate([cam_body_x - 0.4, cam_c[1] - cam_body[0] / 2 - clr - 1, wall]) cube([cam_body[2] + 1.4, 1, cam_body[1]]);
    translate([cam_body_x - 0.4, cam_c[1] + cam_body[0] / 2 + clr, wall]) cube([cam_body[2] + 1.4, 1, cam_body[1]]);
    translate([cam_body_x + cam_body[2] + clr, cam_c[1] - cam_body[0] / 2 - clr - 1, wall]) cube([1, cam_body[0] + 2 * clr + 2, 4]);
    // rails: board|battery and battery|tail
    translate([batt_pos[0] - 1.0, wall, wall]) cube([1.0, iy, 6]);
    translate([tail_x - 1.0, wall, wall]) cube([1.0, iy, 6]);
    // tactile switch pocket in the tail
    for (dy = [-1, 1]) translate([tail_x, btn_c[0] + dy * (3 + clr + 0.5) - 0.5, wall]) cube([outer[0] - wall - tail_x, 1, 7]);
}

module lid_part() { lid(outer, lid_t); }

module button_cap() {
    cylinder(d = 10, h = 1.5);
    translate([0, 0, 1.5]) cylinder(d = 4.0, h = wall + 0.6);
}

module preview() {
    shell_part();
    translate([board_pos[0] + xiao_pcb[1], board_pos[1], z_pcb_top]) rotate([0, 0, 90]) mirror([0, 0, 1]) xiao_stack();
    translate([cam_body_x + cam_body[2], cam_c[1] - cam_body[0] / 2, cam_c[2] - cam_body[1] / 2]) rotate([0, -90, 0]) mirror([1, 0, 0]) camera_module();
    translate(batt_pos) battery(batt);
    color("#d4a017") translate(ant_pos) cube(antenna_flex);
    translate([outer[0] - wall - tact_6x6[2], btn_c[0] - 3, btn_c[1] - 3]) rotate([0, 90, 0]) translate([-6, 0, 0]) tact();
    color("#555") translate([outer[0] - wall - 3.6, slide_c[0] - 4.3, wall + 0.5]) cube([3.6, 8.6, 4]);
    color("#9ad", 0.5) translate([0, 0, shell_h + 6]) lid_part();
    color("#e33") translate([outer[0] + 1.5, btn_c[0], btn_c[1]]) rotate([0, -90, 0]) button_cap();
}

if (part == "shell") shell_part();
else if (part == "lid") lid_part();
else if (part == "cap") button_cap();
else preview();

echo(str("outer envelope: ", outer[0], " x ", outer[1], " x ", total_depth, " mm"));
