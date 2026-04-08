include <BOSL2/std.scad>

/* [Quality] */
$fn = 96;

/* [Lens Dimensions] */
LensWidth = 40;
LensHeight = 37;
LensDepth = 9;
LensCornerRadius = 8;
LensNotch = true;
LensNotchWidth = 9;
LensNotchDepth = 1.5;

/* [Box] */
BoxWallThickness = 1; // 0.1
BoxLipDepth = 3;
BoxLidGap = 0.2; // [0.1:0.1:0.5]

/* [Parts Layout] */
ShowBase = true;
ShowLid = true;
PartsGap = 10;

module RoundedBox(w, l, h, r) {
   cuboid([w, l, h],
        rounding=r,
        edges = [
            LEFT + FRONT,
            LEFT + BACK,
            RIGHT + FRONT,
            RIGHT + BACK,
        ],
    );
}

// Base
BoxLipWidth = LensWidth + BoxWallThickness * 4;
BoxLipHeight = LensHeight + BoxWallThickness * 4;
BaseOuterWidth = LensWidth + BoxWallThickness * 2;
BaseOuterHeight = LensHeight + BoxWallThickness * 2;
BaseOuterDepth = LensDepth + BoxWallThickness;
if (ShowBase) {
    translate([-PartsGap / 2, 0, 0])
    translate([-BoxLipWidth / 2, 0, BaseOuterDepth / 2])
    difference() {
        union() {
            // Main body
            RoundedBox(BaseOuterWidth, BaseOuterHeight, BaseOuterDepth, LensCornerRadius);
            // Lip
            translate([0, 0, -LensDepth / 2 + BoxWallThickness])
            RoundedBox(BoxLipWidth, BoxLipHeight, BoxLipDepth, LensCornerRadius);
        }
        // Cavity
        translate([0, 0, BoxWallThickness / 2 + 0.01])
        RoundedBox(LensWidth, LensHeight, LensDepth, LensCornerRadius);
        // Notch opening
        if (LensNotch) {
            translate([-LensNotchWidth / 2, LensHeight / 2 - 0.01, BaseOuterDepth / 2 - LensNotchDepth + 0.01])
            cube([LensNotchWidth, BoxWallThickness + 0.02, LensNotchDepth]);
        }
    }
}

// Lid
LidOuterWidth = LensWidth + BoxWallThickness * 4;
LidOuterHeight = LensHeight + BoxWallThickness * 4;
LidOuterDepth = LensDepth + BoxWallThickness * 2 - BoxLipDepth;
LidInnerWidth = BaseOuterWidth + BoxLidGap;
LidInnerHeight = BaseOuterHeight + BoxLidGap;
LidInnerDepth = BaseOuterDepth - BoxLipDepth;
if (ShowLid) {
    translate([PartsGap / 2, 0, 0])
    translate([LidOuterWidth / 2, 0, LidOuterDepth / 2])
    difference() {
        // Main body
        RoundedBox(LidOuterWidth, LidOuterHeight, LidOuterDepth, LensCornerRadius);
        // Cavity
        translate([0, 0, BoxWallThickness / 2 + 0.01]) 
        RoundedBox(LidInnerWidth, LidInnerHeight, LidInnerDepth, LensCornerRadius);
        // Notch opening
        if (LensNotch) {
            translate([-LensNotchWidth / 2, LidInnerHeight / 2 - 0.01, -(LidInnerDepth - BoxWallThickness) / 2 + 0.01])
            cube([LensNotchWidth, BoxWallThickness + 0.02, LidInnerDepth]);
        }
    }
}