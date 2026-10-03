// ---------------------------------------------------------------------------
// CO2 sensor case: Sensirion SCD41 breakout + Wemos D1 mini
// By Grant Emsley, https://www.emsley.ca
// Licensed CC BY 4.0: https://creativecommons.org/licenses/by/4.0/
//
// Modelled on my boards. D1 mini clones and SCD41 breakouts vary, so measure
// yours against the Boards section below before printing, and print the
// test slices (part = "test_...") to check the fits first.
//
// Sensirion SCD41 breakout + Wemos D1 mini (no headers), joined by 4 wires.
// One stick, flat back (tape to a wall, or lie it on its back on a desk):
//   pod     = SCD41 at the bottom, small dead volume, grille over the can,
//             slots in both sides and the floor. Its roof (with the wire
//             hole) is part of the pod lid, an L of front + roof (v2,
//             2026-10-01: the body's slotted roof was too weak).
//   neck    = 40 mm between them: two side bars, closed at the front by a
//             snap-in vented cover. The USB plug hangs down in it; the SCD41
//             wires run up it. Vented (cover slots + bar slots) so it stays at
//             room temperature; the pod's own wire hole is sealed.
//   chamber = D1 mini standing USB-end down at the top. The plug goes up
//             through a 13 x 9 floor opening (takes most straight
//             micro-USB plugs). Intakes low in the
//             side walls, exhaust in the roof and the upper front.
// Below the plug the cable jogs back into a groove in the back face and runs
// behind the pod (solid wall, no path into the pod) to the bottom edge.
//
// Parts: body (prints on its back); pod_lid, esp_lid, neck_cover (print face
// down). The neck cover snaps in with in-plane flex fins
// and comes off with a flat screwdriver in the notch at its bottom edge.
// Both lids slide down in 45-degree tongue grooves in the side walls: the pod
// lid from the neck, the ESP lid from the top. Gravity keeps them seated on
// the wall; lying flat, the hold-down squeeze keeps them put.
//
// Assembly:
//   1. Solder ~10 cm wires into the SCD41 holes, entering from the can side,
//      soldered on the back (keep the back joints under ~1.2 mm: the rails
//      are 1.3). Thread the wires through the pod lid's roof hole and the
//      chamber floor wire hole before soldering the other ends to the D1
//      (3V3, G, D2, D1).
//   2. Drop the SCD41 in the pod on its edge rails, can toward the front.
//   3. D1: USB end down, ESP-12 toward the front. Tilt its bottom edge into
//      the floor groove, then swing the top back against the stop.
//   4. Slide the ESP lid down from the top and the pod lid down from the neck.
//      Lay the wires down the middle of the neck, then press the neck cover in.
//      (To open the pod later: neck cover off first, then the pod lid slides up.)
//   5. Plug the USB cable in from below, press the cable into the back groove.
//   6. Seal the pod lid's roof hole and the chamber floor wire hole around the wires
//      (hot glue or putty), so neither chamber's air reaches the pod.
//
// Frame (wall pose): x across (centred), y out from the wall (back face y=0),
// z up (pod bottom z=0).
// ---------------------------------------------------------------------------

part = "assembly";  // assembly, body, pod_lid, esp_lid, neck_cover, print_all,
                    // test_pod, test_usb, test_top, test_esp_lid_top, test_neck

$fn = 40;
e = 0.01;

// ---- Boards ---------------------------------------------------------------
scd   = [15.8, 21.7, 1.5];   // SCD41 breakout: width, length, PCB thickness
can   = [10.1, 6.6];         // SCD41 can: side, height above the PCB top face
can_z = 1.5;                 // can's lower edge above the PCB's can-end edge
d1    = [25.5, 34.67, 1.0];  // D1 mini: width, length (measured on mine), PCB
usb_off  = 1.4;              // socket centreline behind the D1's back face
                             // (socket is on the face opposite the ESP-12)
esp_ant  = 0.8;              // ESP-12 antenna PCB in front of the D1 front face
                             // at the antenna end (assumed flush with the end)

// ---- Fits (clearances that worked on my printer; tune for yours) ----------
clr_pcb  = 0.2;    // SCD41 in its pocket, per side
clr_d1   = 0.25;   // D1 across, per side
clr_d1_z = 0.3;    // D1 lengthwise, total
clr_tg   = 0.25;   // lid tongue in its groove, per face
clr_lid  = 0.15;   // lid plate edge to wall
squeeze  = 0.3;    // hold-down ribs reach past the nominal board face

// ---- Shell ----------------------------------------------------------------
wall   = 2.0;
side   = 3.4;       // side walls that carry a lid groove
lid_t  = 2.0;
tongue = 1.2;       // lid tongue reach (45-degree face toward the front)
D      = 20.3;      // overall depth
lid_y  = D - lid_t; // back face of both lids

// ---- Cable ----------------------------------------------------------------
usb_open   = [13, 9];   // x, y
usb_open_r = 2;
groove     = [5.5, 5.5];// back-face cable groove, width x depth (3-5 mm cables)
neck       = 40;        // plug overmould up to ~30 mm + the jog into the groove

// ---- Pod (SCD41) -------------------------------------------------------------
pod_back  = groove[1] + 1.2;              // pocket back face (skin over groove)
pod_in    = [scd[0] + 2*clr_pcb, scd[1] + 2*clr_pcb];
pod_w     = pod_in[0] + 2*side;
scd_proud = 0.7;   // test fit 2026-10-01: the real board front sat 0.7 proud of
                   // the model, so the lid ribs would have over-pressed it.
                   // The rails drop by this much; the ribs and grille don't move.
standoff  = 2.0 - scd_proud;              // edge rails behind the PCB (1.3)
rail_w    = 1.2;
pcb_y     = pod_back + standoff;          // PCB back face (nominal)
pcb_front = pcb_y + scd[2] + scd_proud;   // real board front, where the ribs press
pod_floor = 2.0;
pod_h     = pod_floor + pod_in[1] + wall; // roof (on the lid) = wall
wire_d    = 5;                            // round wire hole: pod lid roof, chamber floor (v3)

// ---- Chamber (D1) ------------------------------------------------------------
ch_in   = [d1[0] + 2*clr_d1, 0];
ch_w    = ch_in[0] + 2*side;
d1_y    = 7.4;                  // D1 back face (puts the plug hole 1.5 in from the back)
usb_y   = d1_y - usb_off;
floor_t = 3.0;
slot_d  = 1.5;                  // floor groove depth for the D1's bottom edge
slot_w  = d1[2] + 0.6;          // room to tilt the board in
z_cf    = pod_h + neck;         // chamber floor bottom
z_f     = z_cf + floor_t;       // chamber floor top
z_roof  = z_f - slot_d + d1[1] + clr_d1_z;   // roof underside
z_top   = z_roof + wall;
lip_y   = d1_y + d1[2] + esp_ant - 0.2;       // ESP lid lip back face (0.2 squeeze)
stub_y  = lip_y - 0.3;                        // fixed roof stub ends here
lip     = [12, 3.0];            // ESP lid lip at the antenna end: width, drop
stop    = [12, 4];              // back stop behind the D1's antenna end: width, drop (stays in the bare antenna section)

// ---- Neck bars (outside the pod lid's ribs + tongues when it slides up) ----
bar_x0  = pod_in[0]/2 + e;      // inner face
bar_y1  = lid_y - 0.3;

// ---- Neck cover: snap-in, flex fins -------------------------------------------
// Two blocks behind the cover plate sit just inside the bars; each carries two
// in-plane fins (in recesses) whose tips spring into a groove in the bar's
// inner face. Groove mouth face (toward the front) is 45 degrees: holds the
// cover, prints clean, and a pry at the bottom notch levers it out.
nk_clr    = 0.3;                // block side to bar face
nk_px     = bar_x0 - nk_clr;    // block outer faces, |x|
nk_blk    = 2.5;                // block thickness across
nk_y0     = 10.8;               // block back face: clear of a 9-thick plug (y <= 10.5)
nk_t      = 0.8;                // fin thickness
nk_len    = 7.0;                // fin root to tip
nk_rec    = 1.0;                // recess the fin folds into
nk_reach  = 1.2;                // tip past the block side, free
nk_gd     = 1.0;                // groove depth into the bar
nk_fy     = [nk_y0 + 0.5, bar_y1 - 1.8];       // fins' extent along y
nk_lead   = nk_reach + nk_clr + 0.2;           // 45-degree lead-in at the deep end
nk_gy     = [nk_fy[0] + nk_lead - 0.6, nk_fy[1] + nk_gd];  // groove at the bar face
nk_dz     = sqrt(nk_len*nk_len - pow(nk_rec + nk_reach, 2));
nk_zmid   = (pod_h + z_cf - 8) / 2;            // middle of the straight neck
nk_root   = [nk_zmid - 1.5, nk_zmid + 1.5];    // lower fin points down, upper up
nk_notch  = [8, 1.2, 1.2];                     // pry notch: across, tall, deep

assert(nk_reach - nk_clr < nk_gd, "neck fin tips would bottom in the groove");
assert(nk_gy[1] < bar_y1 - 0.6, "neck groove breaks out of the bar front");
assert(nk_y0 > usb_y + usb_open[1]/2, "neck cover blocks would hit the plug");

echo(str("Overall: ", ch_w, " W x ", z_top, " H x ", D, " D; pod ", pod_w,
         " W; can top z ~", pod_floor + clr_pcb + can_z + can[0],
         "; chamber floor z ", z_f));

// ---------------------------------------------------------------------------
module rrect(size, r) {   // 2D rounded rectangle, centred
    offset(r = r) offset(delta = -r) square(size, center = true);
}

// Tongue profile (x = outward from the lid edge, y) and its groove.
module tongue_2d(c = 0) {
    polygon([[-1 - c, lid_y - c], [tongue + c * 1.4, lid_y - c],
             [-1 - c, lid_y + tongue + 1 + c * 1.4]]);
}
// Groove cut in a side wall whose inner face is at |x| = xi, from z0 to z1.
module lid_grooves(xi, z0, z1) {
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
        translate([xi, 0, z0]) linear_extrude(z1 - z0) tongue_2d(clr_tg);
}
module lid_tongues(xi, z0, z1) {
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
        translate([xi - clr_lid, 0, z0]) linear_extrude(z1 - z0)
            intersection() { tongue_2d(0); translate([0, lid_y]) square([tongue, tongue]); }
}

// Vertical slots through a side wall (running along y), both sides.
module side_slots(xo, zs, y0, y1, h = 2) {
    for (z = zs) translate([-xo - 1, y0, z]) cube([2*xo + 2, y1 - y0, h]);
}

// Cable groove profile (x across, y into the back): straight sides, a
// semicircular top, and 1 mm fillets at the mouth.
groove_r = 1.0;
module groove_2d() {
    gw = groove[0]; gd = groove[1];
    hull() {
        translate([-gw/2, -e]) square([gw, e]);
        translate([0, gd - gw/2]) circle(d = gw);
    }
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0])
        difference() {
            translate([gw/2 - e, -e]) square([groove_r + e, groove_r + e]);
            translate([gw/2 + groove_r, groove_r]) circle(r = groove_r);
        }
}

// ---------------------------------------------------------------------------
module pod() {
    difference() {
        translate([-pod_w/2, 0, 0]) cube([pod_w, D, pod_h]);
        // pocket, open to the front and the top (the roof is part of the lid)
        translate([-pod_in[0]/2, pod_back, pod_floor]) cube([pod_in[0], D, pod_h]);
        lid_grooves(pod_in[0]/2, pod_floor, pod_h + e);
        // side slots (low, where the can is), floor slots
        side_slots(pod_w/2, [4, 8, 12], pcb_y, lid_y - 1);
        for (x = [-5, 0, 5]) translate([x - 1, pod_back + 1, -1]) cube([2, lid_y - pod_back - 2, pod_floor + 2]);
        // cable groove in the back face, full pod height. v4: round-topped
        // (no sharp inner corners to concentrate stress, and as printed back
        // down it's an arch instead of a 5.5 mm flat bridge), with 1 mm
        // rounded edges where it meets the back face.
        translate([0, 0, -1]) linear_extrude(pod_h + 2) groove_2d();
        // fingernail notch under the lid's bottom edge
        translate([-4, D - 1.5, pod_floor - 1.2]) cube([8, 1.5 + e, 1.2 + e]);
    }
    // edge rails behind the PCB
    for (s = [-1, 1])
        translate([s > 0 ? pod_in[0]/2 - rail_w : -pod_in[0]/2, pod_back - e, pod_floor - e])
            cube([rail_w, standoff + e, pod_in[1] - 0.3 + e]);   // clear of the lid's roof
}

module neck_bars() {
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
        difference() {
            union() {
                translate([bar_x0, 0, pod_h - e]) cube([pod_w/2 - bar_x0, bar_y1, neck + 2*e]);
                // the bars flare out to the chamber's width over the last 8 mm
                hull() {
                    translate([bar_x0, 0, z_cf - 8]) cube([pod_w/2 - bar_x0, bar_y1, e]);
                    translate([bar_x0, 0, z_cf - e]) cube([ch_w/2 - bar_x0, bar_y1, e]);
                }
            }
            // groove for the neck cover's fin tips; mouth face 45 degrees
            hull() {
                translate([bar_x0 - e, nk_gy[0], pod_h]) cube([e, nk_gy[1] - nk_gy[0], z_cf - 8 - pod_h]);
                translate([bar_x0 + nk_gd - e, nk_gy[0], pod_h]) cube([e, nk_gy[1] - nk_gd - nk_gy[0], z_cf - 8 - pod_h]);
            }
            // side vents through the bars, behind the cover blocks
            for (z = [pod_h + 4 : 6 : z_cf - 12]) translate([bar_x0 - 1, 2, z]) cube([pod_w/2 - bar_x0 + 2, nk_y0 - 3, 2]);
        }
}

module chamber() {
    difference() {
        translate([-ch_w/2, 0, z_cf]) cube([ch_w, D, z_top - z_cf]);
        // cavity (back wall = wall)
        translate([-ch_in[0]/2, wall, z_f]) cube([ch_in[0], D, z_roof - z_f]);
        // roof is a stub at the back; the ESP lid's flange closes the rest
        translate([-ch_in[0]/2, stub_y, z_f]) cube([ch_in[0], D, z_top]);
        lid_grooves(ch_in[0]/2, z_f, z_top + e);
        // USB opening
        translate([0, usb_y, z_cf - 1]) linear_extrude(floor_t + 2) rrect(usb_open, usb_open_r);
        // floor groove for the D1's bottom edge, either side of the opening
        for (s = [-1, 1]) translate([s > 0 ? usb_open[0]/2 : -ch_in[0]/2, d1_y - (slot_w - d1[2])/2, z_f - slot_d])
            cube([ch_in[0]/2 - usb_open[0]/2, slot_w, slot_d + e]);
        // wire hole in front of the opening
        translate([0, usb_y + usb_open[1]/2 + 1 + wire_d/2, z_cf - 1]) cylinder(d = wire_d, h = floor_t + 2);
        // low side intakes (at or above the floor, not in the neck)
        side_slots(ch_w/2, [z_f + 1.5, z_f + 5.5], wall + 2, lid_y - 1);
        // roof stub exhaust (behind the board)
        for (x = [-11, -8, 8, 11]) translate([x - 1, wall + 0.5, z_roof - 1]) cube([2, d1_y - wall - 1, wall + 2]);
    }
    // back stop behind the D1's antenna end (clear of the chamfered corners)
    translate([-stop[0]/2, wall - e, z_roof - stop[1]]) cube([stop[0], d1_y - 0.1 - wall + e, stop[1] + e]);
}

module body() {
    pod();
    neck_bars();
    chamber();
}

// ---------------------------------------------------------------------------
module pod_lid() {
    w = pod_in[0] - 2*clr_lid;
    z0 = pod_floor; z1 = pod_h;
    difference() {
        union() {
            translate([-w/2, lid_y, z0]) cube([w, lid_t, z1 - z0]);
            lid_tongues(pod_in[0]/2, z0, z1);
            // roof: an L with the front plate, carries the wire hole. It sits
            // 0.2 above the PCB's top edge, so it also keeps the board down.
            translate([-w/2, pod_back + 0.2, z1 - wall]) cube([w, lid_y - pod_back - 0.2 + e, wall]);
            // hold-down ribs on the PCB's long edges (clear of the can)
            for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
                difference() {
                    translate([w/2 - rail_w, pcb_front - squeeze, z0 + 0.3])
                        cube([rail_w, lid_y - pcb_front + squeeze + e, z1 - wall - z0 - 0.3 + e]);   // up into the roof
                    // 1 mm lead-in at the bottom so the rib rides onto the PCB
                    translate([0, pcb_front - squeeze, z0 + 0.3]) rotate([45, 0, 0])
                        cube([w, 1.5, 1.5], center = true);
                }
        }
        // grille over the can: 3 round-ended 2.6 mm slots, 2.4 mm bars (v3:
        // the 4 x 2 mm slots with 1.5 mm bars printed messy)
        for (x = [-5, 0, 5])
            translate([x, lid_y - 1, 0]) rotate([-90, 0, 0]) linear_extrude(lid_t + 2)
                hull() for (z = [z0 + 1 + 1.3, z0 + 14 - 1.3]) translate([0, -z]) circle(d = 2.6);
        // wire hole in the roof, above the pads (thread the wires through
        // before soldering; seal after)
        translate([0, pcb_front + 0.5 + wire_d/2, z1 - wall - 1]) cylinder(d = wire_d, h = wall + 2);
    }
}

module esp_lid() {
    w = ch_in[0] - 2*clr_lid;
    z0 = z_f; z1 = z_top;
    difference() {
        union() {
            translate([-w/2, lid_y, z0]) cube([w, lid_t, z1 - z0]);
            lid_tongues(ch_in[0]/2, z0, z1);
            // flange that closes the roof in front of the stub
            translate([-w/2, lip_y, z_roof]) cube([w, lid_y - lip_y + e, wall]);
            // lip that holds the D1's antenna end back against the stop
            difference() {
                // 45-degree gusset on the front face: prints unsupported face down
                hull() {
                    translate([-lip[0]/2, lip_y, z_roof - lip[1]]) cube([lip[0], 2, e]);
                    translate([-lip[0]/2, lip_y, z_roof]) cube([lip[0], 2 + lip[1], e]);
                }
                translate([0, lip_y, z_roof - lip[1]]) rotate([45, 0, 0]) cube([lip[0] + 1, 1.4, 1.4], center = true);
            }
        }
        // exhaust through the flange
        for (x = [-10, -6, -2, 2, 6, 10]) translate([x - 1, lip_y + 2.5, z_roof - 1]) cube([2, lid_y - lip_y - 3.5, wall + 2]);
        // (v3: no front slots - the roof and stub carry the exhaust)
    }
}

// One neck-cover fin on the +x block: root in the recess, tip out past the
// block side, 45-degree lead-in at its deep (wall-side) end.
module nk_fin(zr, dz) {
    intersection() {
        translate([0, nk_fy[1], 0]) rotate([90, 0, 0]) linear_extrude(nk_fy[1] - nk_fy[0])
            hull() {
                translate([nk_px - nk_rec - nk_t/2, zr]) circle(d = nk_t, $fn = 16);
                translate([nk_px + nk_reach - nk_t/2, zr + dz*nk_dz]) circle(d = nk_t, $fn = 16);
            }
        hull() {
            translate([0, nk_fy[0] + nk_lead, -50]) cube([nk_px + nk_reach, nk_fy[1] - nk_fy[0] - nk_lead + 1, 200]);
            translate([0, nk_fy[0], -50]) cube([nk_px - nk_clr, e, 200]);
        }
    }
}

module neck_cover() {
    z0 = pod_h + 0.15; z1 = z_cf - 0.15;
    difference() {
        union() {
            // plate, following the bars' flare at the top
            translate([-pod_w/2, lid_y, z0]) cube([pod_w, lid_t, z_cf - 8 - z0 + e]);
            hull() {
                translate([-pod_w/2, lid_y, z_cf - 8]) cube([pod_w, lid_t, e]);
                translate([-ch_w/2, lid_y, z1 - e]) cube([ch_w, lid_t, e]);
            }
            // fin blocks just inside the bars
            for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
                translate([nk_px - nk_blk, nk_y0, nk_root[0] - nk_dz - 2])
                    cube([nk_blk, lid_y - nk_y0 + e, 2*nk_dz + 7]);
        }
        // recesses the fins fold into
        for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
            for (i = [0, 1]) {
                zr = nk_root[i]; dz = i == 0 ? -1 : 1;
                za = min(zr, zr + dz*nk_dz) - 0.8; zb = max(zr, zr + dz*nk_dz) + 0.8;
                translate([nk_px - nk_rec, nk_fy[0] - 0.4, za]) cube([nk_rec + 1, nk_fy[1] - nk_fy[0] + 1, zb - za]);
            }
        // (v3: solid front - the bars' side slots vent the neck)
        // pry notch at the bottom edge, front face
        translate([-nk_notch[0]/2, D - nk_notch[2], z0 - e]) cube([nk_notch[0], nk_notch[2] + e, nk_notch[1] + e]);
    }
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0]) {
        nk_fin(nk_root[0], -1);
        nk_fin(nk_root[1], 1);
    }
}

// ---- ghosts ---------------------------------------------------------------
module ghosts() {
    color("royalblue") translate([-scd[0]/2, pcb_y, pod_floor + clr_pcb]) cube([scd[0], scd[2], scd[1]]);
    color("silver") translate([-can[0]/2, pcb_front, pod_floor + clr_pcb + can_z]) cube([can[0], can[1], can[0]]);
    color("steelblue") translate([-d1[0]/2, d1_y, z_f - slot_d]) cube([d1[0], d1[2], d1[1]]);
    color("gray") translate([-8, d1_y + d1[2], z_f + 12]) cube([16, 3.2, 17]);
    color("black") translate([-5.5, usb_y - 4, z_f - slot_d - 26]) cube([11, 8, 26]);
}

// ---- print orientations -----------------------------------------------------
module body_print()    { rotate([90, 0, 0]) body(); }              // back face down
module lid_print(z0)   { translate([0, 0, D]) rotate([-90, 0, 0]) translate([0, 0, -z0]) children(); }

module slice(z0, z1) {
    intersection() { children(); translate([-50, -1, z0]) cube([100, D + 2, z1 - z0]); }
}

if (part == "assembly") { body(); pod_lid(); esp_lid(); neck_cover(); %ghosts(); }
else if (part == "body") body_print();
else if (part == "pod_lid") lid_print(pod_floor) pod_lid();
else if (part == "esp_lid") lid_print(z_f) esp_lid();
else if (part == "neck_cover") lid_print(pod_h) neck_cover();
else if (part == "print_all") {
    body_print();
    translate([35, 0, 0]) lid_print(pod_floor) pod_lid();
    translate([60, 0, 0]) lid_print(z_f) esp_lid();
    translate([95, 0, 0]) lid_print(pod_h) neck_cover();
}
else if (part == "test_neck") rotate([90, 0, 0]) slice(pod_h - 1, z_cf - 8) body();
else if (part == "test_neck_cover") lid_print(pod_h) slice(pod_h - 1, z_cf - 8) neck_cover();
else if (part == "test_pod") rotate([90, 0, 0]) slice(0, pod_h + 4) body();
else if (part == "test_usb") rotate([90, 0, 0]) slice(z_cf - 4, z_f + 10) body();
else if (part == "test_top") rotate([90, 0, 0]) slice(z_top - 12, z_top) body();
else if (part == "test_esp_lid_top") lid_print(z_top - 12) slice(z_top - 12, z_top) esp_lid();
