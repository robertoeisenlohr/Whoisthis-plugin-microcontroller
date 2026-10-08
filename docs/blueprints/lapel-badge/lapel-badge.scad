// WhoIsThis lapel badge / pendant — XIAO ESP32-S3 Sense + LP502030, magnetic back.
// Camera looks out of the front face (the shell floor); the lid is the back and carries the magnets.
//   openscad -D part='"shell"' -o shell.stl lapel-badge.scad      (also: lid, cap, preview)
include <../lib/parts.scad>

part = "preview";
bail = false;            // pendant: adds a lanyard loop on the top edge

// ---- derived layout (origin: outer front-left-bottom corner; X along the badge, Z = depth) ----
batt   = batt_502030;
shell_h = wall + clr + stack_h + clr + lip_h;         // 11.9: parts stay under the lid lip
outer  = [56, 31, shell_h];
total_depth = shell_h + mag_lid_t;                     // 14.5

board_pos = [wall + clr, wall + clr];                  // [1.9, 1.9]; 21 x 17.8, USB-C toward -X
z_socket  = wall + clr;                                // sense-board side faces the front
z_pcb_top = z_socket + stack_h;                        // main PCB underside toward the lid (10.4)
usb_c     = [board_pos[1] + xiao_pcb[1] / 2, z_pcb_top - xiao_pcb[2] - usbc[2] / 2];  // y, z centre
cam_pos   = [board_pos[0] + xiao_pcb[0] / 2, board_pos[1] + xiao_pcb[1] + 0.5 + cam_body[1] / 2]; // lens centre x,y
batt_pos  = [board_pos[0] + xiao_pcb[0] + 1.0, wall + bclr, z_pcb_top - batt[2]];   // against the lid
ant_pos   = [batt_pos[0] + 4, wall + 4, wall];                                        // flex on the front wall
jst_pos   = [batt_pos[0] + 1, batt_pos[1] + batt[1] + bclr + 0.3, wall];
btn_c     = [43, 5.0];                                 // x, z of the plunger on the +Y wall
btn_body  = [btn_c[0] - 3, outer[1] - wall - tact_6x6[2], btn_c[1] - 3];
mags      = [[14, outer[1] / 2], [42, outer[1] / 2]];
plug_cut  = [13, 7];                                   // USB-C plug clearance through the wall

module cam_pocket() {
    // four locating posts around the camera body, 3 mm high, 1 mm thick, glue the module in
    for (dx = [-1, 1], dy = [-1, 1])
        translate([cam_pos[0] + dx * (cam_body[0] / 2 + clr + 0.5) - 0.5, cam_pos[1] + dy * (cam_body[1] / 2 + clr + 0.5) - 0.5, wall])
            cube([1, 1, 3]);
}

module shell_part() {
    difference() {
        union() {
            shell(outer);
            if (bail) translate([outer[0] / 2, outer[1] - 0.5, shell_h / 2]) rotate([0, 90, 0]) difference() {
                cylinder(d = 10, h = 8, center = true);
            }
        }
        // lens window, recessed 0.6 so the lens never touches a table
        translate([cam_pos[0], cam_pos[1], -1]) cylinder(d = cam_lens_d + 1.0, h = wall + 2);
        translate([cam_pos[0], cam_pos[1], -0.01]) cylinder(d = 11, h = 0.6);
        // USB-C plug through the -X wall
        translate([-1, usb_c[0] - plug_cut[0] / 2, usb_c[1] - plug_cut[1] / 2]) cube([wall + 2, plug_cut[0], plug_cut[1]]);
        // button plunger through the +Y wall
        translate([btn_c[0], outer[1] + 1, btn_c[1]]) rotate([90, 0, 0]) cylinder(d = 4.4, h = wall + 2);
        // charge LED light pipe hole (XIAO charge LED is next to the USB-C): 1.5 mm, -X wall
        translate([-1, usb_c[0] + 8.5, usb_c[1] + 1]) rotate([0, 90, 0]) cylinder(d = 1.5, h = wall + 2);
        // mic port (PDM mic on the Sense board, front side)
        translate([board_pos[0] + 17, board_pos[1] + 3, -1]) cylinder(d = 1.2, h = wall + 2);
        if (bail) translate([outer[0] / 2, outer[1] + 1.5, shell_h / 2]) rotate([0, 90, 0]) cylinder(d = 4, h = 10, center = true);
    }
    cam_pocket();
    // battery rail: a 1 mm ridge keeps the cell off the antenna and the JST wires out of the board gap
    translate([batt_pos[0] - 1.0, wall, wall]) cube([1.0, outer[1] - 2 * wall, 6]);
    // button pocket: two walls hold the 6x6 switch against the +Y wall
    for (dx = [-1, 1]) translate([btn_c[0] + dx * (3 + clr + 0.5) - 0.5, btn_body[1] - 1, wall]) cube([1, tact_6x6[2] + 1, 7]);
}

module lid_part() {
    difference() {
        lid(outer, mag_lid_t);
        magnet_pockets(mags);
    }
}

// Printed button cap: disc outside, stem through the 4.4 hole onto the switch plunger.
module button_cap() {
    cylinder(d = 8, h = 1.2);
    translate([0, 0, 1.2]) cylinder(d = 4.0, h = wall + 0.6);
}

module preview() {
    shell_part();
    translate([board_pos[0], board_pos[1], z_pcb_top]) mirror([0, 0, 1]) xiao_stack();
    translate([cam_pos[0] - cam_body[0] / 2, cam_pos[1] - cam_body[1] / 2, wall + 0.4 + cam_body[2]]) mirror([0, 0, 1]) camera_module();
    translate(batt_pos) battery(batt);
    color("#d4a017") translate(ant_pos) cube(antenna_flex);
    color("#eee") translate(jst_pos) cube(jst125);
    translate([btn_body[0], btn_body[1] + tact_6x6[2], btn_body[2]]) rotate([90, 0, 0]) tact();
    color("#9ad", 0.5) translate([0, 0, shell_h + 6]) lid_part();
    for (m = mags) color("#777") translate([m[0], m[1], shell_h + 6 - mag_h]) magnet();
    color("#e33") translate([btn_c[0], outer[1] + 1.2, btn_c[1]]) rotate([90, 0, 0]) button_cap();
}

if (part == "shell") shell_part();
else if (part == "lid") lid_part();
else if (part == "cap") button_cap();
else preview();

echo(str("outer envelope: ", outer[0], " x ", outer[1], " x ", total_depth, " mm"));
