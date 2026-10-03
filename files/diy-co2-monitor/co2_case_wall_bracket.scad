// ---------------------------------------------------------------------------
// Wall bracket for the CO2 sensor case (co2_sensor_case.scad)
// By Grant Emsley, https://www.emsley.ca
// Licensed CC BY 4.0: https://creativecommons.org/licenses/by/4.0/
//
// Needs co2_sensor_case.scad in the same folder: every case dimension comes
// from it, so a change to the case carries through to the bracket.
//
// The case has to come off the wall now and then to be calibrated outdoors,
// so the tape goes on this bracket instead of on the case.
//
//   plate  = 3 mm backplate, taped to the wall. Same outline as the case
//            (pod-wide at the bottom, wider at the chamber), so it hides
//            behind it. It also closes the case's back cable groove, so the
//            USB cable stays in it and leaves at the bottom edge as before.
//   seats  = two wedges under the case's shoulders (where the neck flares out
//            to the chamber). The case's weight and the cable's pull sit on
//            these, in shear, not on the snap.
//   arms   = two flex arms beside the chamber, above its side intakes, with a
//            hook over each side wall's front edge. Push the case straight
//            back onto the plate and they click over; pull it straight off
//            (45-degree hook faces both ways) to remove it.
//
// Nothing covers a vent: pod side and floor slots, neck bar slots, chamber
// intakes and the roof exhaust are all clear. The lids are untouched.
//
// Prints plate-down (tape face is the bed face), no supports.
// Frame and all case dimensions come from the case file (case frame: x across,
// y out from the wall with the case back at y = 0, z up, pod bottom z = 0).
// ---------------------------------------------------------------------------

include <co2_sensor_case.scad>
part = "none";       // silences the case file's own output
view = "bracket";    // bracket, assembly, print, test_snap, check_seated, check_sweep

$fn = 40;

pt     = 3.0;        // plate thickness
c_side = 0.3;        // case side to arm / seat, per side
c_seat = 0.2;        // shoulder to seat
arm_t  = 1.6;        // arm thickness across (the flexing direction)
arm_z  = [83, 99];   // arm span: above the chamber intakes (top at z_f + 7.5)
hook   = 1.0;        // hook reach over the side wall's front face (wall is 3.4)
play   = 0.2;        // case front face to the hook face, at the case's edge

xa     = ch_w/2 + c_side;            // arm inner face
xo     = xa + arm_t;                 // bracket outer face
rt     = c_side + hook;              // hook depth from the arm face
yh     = D + play - c_side;          // hook face starts here on the arm face
y_arm  = yh + 2*rt + 0.4;            // arm front end

// shoulder: bar outer face from (pod_w/2, z_cf - 8) to (ch_w/2, z_cf)
function flare(x) = (z_cf - 8) + (x - pod_w/2) * 8 / ((ch_w - pod_w)/2);
xs     = pod_w/2 + c_side;           // seat inner face
z_seat = 57;                         // seat bottom: clear of the top neck bar vent (z 54.1-56.1)
z_wide = z_seat - (xo - pod_w/2);    // plate starts widening here (45 degrees)

assert(z_seat > z_cf - 12 + 2, "seat would cover the neck bar vents");
assert(arm_z[0] > z_f + 5.5 + 2 + 2, "arms would cover the chamber intakes");
assert(arm_z[1] < z_top, "arms above the case top");
echo(str("Bracket: ", 2*xo, " W x ", z_top, " H; arm deflection to pass ", hook,
         " mm; seat top z ", flare(xs) - c_seat));

module rr2(p0, p1, r) {   // 2D rounded rectangle from corner p0 to corner p1
    translate(p0 + [r, r]) offset(r = r) square(p1 - p0 - [2*r, 2*r]);
}

module plate() {
    // outline in x/z, extruded back from y = 0
    translate([0, 0, 0]) rotate([90, 0, 0]) linear_extrude(pt)
        offset(r = 2) offset(delta = -2)
            polygon([[-pod_w/2, 0], [pod_w/2, 0], [pod_w/2, z_wide], [xo, z_seat],
                     [xo, z_top], [-xo, z_top], [-xo, z_seat], [-pod_w/2, z_wide]]);
}

module seats() {
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
        translate([0, D - 1, 0]) rotate([90, 0, 0]) linear_extrude(D - 1 + e)
            polygon([[xs, z_seat], [xs, flare(xs) - c_seat],
                     [xa, flare(xa) - c_seat], [xo, flare(xa) - c_seat], [xo, z_seat]]);
}

module arms() {
    for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0, 0])
        translate([0, 0, arm_z[0]]) linear_extrude(arm_z[1] - arm_z[0])
            polygon([[xa, -e], [xo, -e], [xo, y_arm - 0.6], [xo - 0.6, y_arm],
                     [xa, y_arm],
                     [xa - rt, yh + rt + 0.4],     // 45-degree lead-in
                     [xa - rt, yh + rt],
                     [xa, yh]]);                   // 45-degree hook face
}

module bracket() { plate(); seats(); arms(); }

// The whole case as one solid, seated.
module case_solid() { body(); pod_lid(); esp_lid(); neck_cover(); }

// Print plate-down: the wall face (y = -pt) goes to the bed.
module print_pose() { translate([0, 0, pt]) rotate([90, 0, 0]) children(); }

if (view == "bracket") bracket();
else if (view == "assembly") { color("orange") bracket(); color("steelblue") case_solid(); }
else if (view == "print") print_pose() bracket();
// short slice through the arms, to try the snap on the real case first
else if (view == "test_snap") print_pose()
    intersection() { bracket(); translate([-50, -pt - 1, arm_z[0] - 2]) cube([100, 40, arm_z[1] - arm_z[0] + 4]); }
// both checks must render empty
else if (view == "check_seated") intersection() { bracket(); case_solid(); }
else if (view == "check_sweep")   // case pushed in from 30 mm out; arms excluded (they flex by design)
    intersection() { union() { plate(); seats(); }
                     minkowski() { case_solid(); cube([0.01, 30, 0.01]); } }
