BASILACAK_PARCA = "MONTAJ"; 

// =======================================================

// --- TEMEL PARAMETRELER ---
THICKNESS = 4;
BASE_WIDTH = 140;
BASE_LENGTH = 260;
STANDOFF_H = 40; 
HOLE_R = 3.2/2; 
BUMPER_H = 40; 
HOOD_WIDTH = 140;
JOINT_Y = -BASE_LENGTH/2;
SAFETY_GAP = 0;

// Motor
MOTOR_LEN = 65;
MOTOR_WID = 23;
MOTOR_HGT = 18;
MOTOR_POS_X = BASE_WIDTH/2 - MOTOR_WID/2 + 4; 
MOTOR_POS_Y = BASE_LENGTH/2 - MOTOR_LEN/2 - 15;
WHEEL_DIAMETER = 70;
WHEEL_R = WHEEL_DIAMETER / 2;

// --- YARDIMCI MODÜLLER ---
module m3_hole(h = THICKNESS + 0.1) {
    cylinder(r = HOLE_R, h = h, center = true, $fn = 32);
}

module motor_mount_holes() {
    translate([0, 15, 0]) cube([10, 5, THICKNESS + 2], center=true);
    translate([0, MOTOR_LEN/2 + 5, 0]) m3_hole();
    translate([0, -MOTOR_LEN/2 - 5, 0]) m3_hole();
}

// --- ŞASİ TASARIMLARI ---
module lower_chassis_shape() {
    hull() {
        translate([ BASE_WIDTH/2 - 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([-BASE_WIDTH/2 + 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([ BASE_WIDTH/2 - 10, -BASE_LENGTH/2 + 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([-BASE_WIDTH/2 + 10, -BASE_LENGTH/2 + 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
    }
}

module upper_chassis_shape() {
    hull() {
        translate([ BASE_WIDTH/2 - 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([-BASE_WIDTH/2 + 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([ 0, JOINT_Y + 5, 0]) cube([BASE_WIDTH, 10, THICKNESS], center=true);
    }
}

// --- PORSCHE PANEL ---
module porsche_918_rear_panel() {
    PANEL_THICKNESS = 8; 
    PANEL_HEIGHT = STANDOFF_H - THICKNESS - 0.2; 
    difference() {
        union() {
            color("silver") hull() {
                translate([0, 0, 0]) cube([BASE_WIDTH - 20, PANEL_THICKNESS, PANEL_HEIGHT], center=true);
                translate([0, -2, 0]) cube([BASE_WIDTH - 10, PANEL_THICKNESS, PANEL_HEIGHT-5], center=true);
            }
            color("silver") for(x = [-30, -10, 10, 30]) {
                translate([x, 2, -PANEL_HEIGHT/2 + 2]) cube([2, PANEL_THICKNESS+2, 12], center=true);
            }
            color("gray") for(side = [-1, 1]) {
                translate([side * 35, -12, PANEL_HEIGHT/2 - 2]) cube([12, 20, 4], center=true);
                translate([side * 35, -12, -PANEL_HEIGHT/2 + 2]) cube([12, 20, 4], center=true);
            }
        }
        for(side = [-1, 1]) {
            translate([side * 40, 2, -5]) cube([35, PANEL_THICKNESS, 12], center=true);
        }
        translate([0, 2, -10]) cube([45, PANEL_THICKNESS, 12], center=true);
        for(side = [-1, 1]) {
            translate([side * 35, -16, PANEL_HEIGHT/2 - 2]) cylinder(r=1.6, h=10, center=true, $fn=16);
            translate([side * 35, -16, -PANEL_HEIGHT/2 + 2]) cylinder(r=1.6, h=10, center=true, $fn=16);
        }
    }
    color([0.1, 0.1, 0.1]) for(side = [-1, 1]) {
        translate([side * 40, 0.1, -5]) cube([33, PANEL_THICKNESS-2, 10], center=true);
    }
    translate([0, 0.5, -10]) color("white") cube([40, 1, 10], center=true);
    color([0.2, 0.2, 0.2]) translate([0, 0, 8]) rotate([90, 0, 0]) { 
        translate([8, 0, -4]) cylinder(r=5, h=10, center=true, $fn=24); 
        translate([-8, 0, -4]) cylinder(r=5, h=10, center=true, $fn=24); 
    }
    LAMP_Y = 4; LAMP_Z = 8; 
    for(side = [-1, 1]) {
        translate([side * 40, LAMP_Y, LAMP_Z]) {
            color([1, 0, 0]) difference() {
                rotate([90, 0, 0]) scale([1.8, 0.8, 1]) cylinder(r=10, h=4, center=true, $fn=64);
                rotate([90, 0, 0]) scale([1.8, 0.8, 1]) cylinder(r=8, h=5, center=true, $fn=64);
            }
            color("black") translate([0, -0.5, 0]) 
            rotate([90, 0, 0]) scale([1.8, 0.8, 1]) cylinder(r=7.8, h=2, center=true, $fn=32);
        }
    }
}

// --- ÇAMURLUKLAR ---
module sport_fenders() {
    FENDER_R_IN = WHEEL_R + 4; 
    FENDER_THICK = 6;            
    FENDER_WIDTH = 28;          
    WHEEL_Z_OFFSET = -24;
    WHEEL_SHIFT_X = 20;

    color("green")
    for(mx = [-1, 1]) {
        for(my = [-1, 1]) {
            translate([mx * MOTOR_POS_X, my * MOTOR_POS_Y, 0]) {
                difference() {
                    union() {
                        translate([mx * WHEEL_SHIFT_X, 0, WHEEL_Z_OFFSET]) rotate([0, 90, 0])
                            cylinder(r=FENDER_R_IN + FENDER_THICK, h=FENDER_WIDTH, center=true, $fn=64);
                    }
                    translate([mx * (WHEEL_SHIFT_X + FENDER_THICK/2), 0, WHEEL_Z_OFFSET]) rotate([0, 90, 0])
                        cylinder(r=FENDER_R_IN, h=FENDER_WIDTH + FENDER_THICK + 10, center=true, $fn=64);
                    translate([0, 0, WHEEL_Z_OFFSET + 10 - 50]) cube([300, 200, 100], center=true);
                    translate([mx * (-90), 0, -50]) cube([40, 200, 100], center=true);
                }
                
                // İNCE BAĞLANTI YERİ
                translate([mx * 3, 0, 10]) cube([8, 70, 20], center=true);

                color("black")
                for(angle = [30, 60, 90, 120, 150]) {
                    translate([mx * WHEEL_SHIFT_X, 0, WHEEL_Z_OFFSET]) rotate([angle, 0, 0])
                    translate([0, FENDER_R_IN + FENDER_THICK - 0.5, mx * (FENDER_WIDTH/2 - 2)]) rotate([0,90,0])
                        cylinder(r=1.5, h=2, center=true, $fn=16);
                }
            }
        }
    }
}

// --- ANA PARÇALAR ---
module lower_chassis() {
    difference() {
        translate([0,0,THICKNESS/2]) lower_chassis_shape();
        translate([-MOTOR_POS_X, MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([MOTOR_POS_X, MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([-MOTOR_POS_X, -MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([MOTOR_POS_X, -MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([0, 0, 0]) cube([20, 40, 20], center=true);
        for(i=[-60:40:60]) { translate([0, i, 0]) cube([BASE_WIDTH-60, 10, 20], center=true); }
        translate([BASE_WIDTH/2 - 25, -BASE_LENGTH/2 + 5, 0]) m3_hole();
        translate([-BASE_WIDTH/2 + 25, -BASE_LENGTH/2 + 5, 0]) m3_hole();
        // Ön taraf bağlantı delikleri
        translate([35, 119, 0]) m3_hole();
        translate([-35, 119, 0]) m3_hole();
    }
}

module upper_chassis() {
    union() {
        difference() {
            translate([0,0,THICKNESS/2]) upper_chassis_shape();
            translate([-20, 25, 0]) m3_hole(h=20);
            translate([20, 25, 0]) m3_hole(h=20);
            translate([-20, -25, 0]) m3_hole(h=20);
            translate([20, -25, 0]) m3_hole(h=20);
            translate([0, BASE_LENGTH/2 - 40, 0]) cube([30, 10, 20], center=true); 
            translate([0, -BASE_LENGTH/2 + 40, 0]) cube([30, 10, 20], center=true);
            // Ön taraf bağlantı delikleri
            translate([35, 119, 0]) m3_hole();
            translate([-35, 119, 0]) m3_hole();
        }
        translate([0,0,THICKNESS/2]) sport_fenders(); 
    }
}

module spoiler() {
    MOUNT_X = 40; MOUNT_Y = BASE_LENGTH/2 - 10; WING_H = 35;
    translate([0, 0, 0]) {
        color("black")
        for(side = [-1, 1]) {
            translate([side * MOUNT_X, MOUNT_Y, 0]) hull() {
                translate([0,0,0]) cube([10, 25, 2], center=true);
                translate([0, 20, WING_H]) rotate([0,90,0]) cylinder(r=3, h=4, center=true);
            }
        }
        color([0.2, 0.2, 0.2]) translate([0, MOUNT_Y + 15, WING_H]) rotate([-10, 0, 0]) {
            difference() {
                hull() {
                    translate([0, -10, 0]) rotate([0,90,0]) cylinder(r=5, h=20, center=true);
                    translate([0, 25, 2])  rotate([0,90,0]) cylinder(r=1, h=20, center=true);
                    for(s = [-1, 1]) {
                        translate([s * 82, -15, -2]) rotate([0,90,0]) cylinder(r=3, h=2, center=true);
                        translate([s * 85, 30, 4])   rotate([0,90,0]) cylinder(r=0.5, h=2, center=true);
                    }
                }
                translate([0, 5, 1]) rotate([0, 0, 180]) linear_extrude(4)
                text("Ege Gokmen", size=10, font="Liberation Sans:style=Bold", halign="center", valign="center", spacing=1.1);
            }
            color("black") for(s = [-1, 1]) {
                translate([s * 85, 0, 0]) rotate([0, 0, s * -5]) hull() {
                    translate([0, -20, -8]) cube([1.5, 10, 15], center=true);
                    translate([0, 35, 5])   cube([1.5, 5, 15], center=true);
                    translate([0, 5, 0])    cube([1.5, 40, 2], center=true);
                }
            }
        }
    }
}

// --- TAMPON PARÇASI (BURUN AŞAĞI, SADECE ÜST DİL VAR) ---
module bumper_hood_pure_nose_down() {
    // 1. GÖRÜNEN YÜZEY
    difference() {
        color("blue") union() {
            hull() {
                difference() {
                    translate([0, -20, 2]) cylinder(r=45, h=4, center=true, $fn=64);
                    translate([0, 500, 0]) cube([1000, 1000, 100], center=true);
                }
                translate([0, -0.5, 2]) cube([HOOD_WIDTH, 1, 4], center=true);
            }
            translate([0, -10, 6]) hull() {
                translate([0, -5, 0]) cylinder(r=25, h=4, center=true);
                translate([0, 5, 0]) cube([40, 1, 4], center=true);
            }
        }
        // Izgaralar
        union() {
            for(side = [-1, 1]) {
                translate([side * 35, -10, 3]) rotate([15, 0, 0]) cube([30, 8, 10], center=true);
            }
            translate([0, -20, 5]) difference() {
                cube([40, 10, 6], center=true);
                translate([0, -5, 0]) rotate([20,0,0]) cube([35, 10, 6], center=true);
            }
        }
    }
    
    // 2. ÜST BAĞLANTI DİLİ (Şasiye giren kısım)
    color("darkblue")
    translate([0, 15, 0]) { 
         difference() {
            translate([0, 0, 0]) cube([80, 30, THICKNESS], center=true); 
            translate([35, 5, 0]) cylinder(r=HOLE_R, h=20, center=true, $fn=32);
            translate([-35, 5, 0]) cylinder(r=HOLE_R, h=20, center=true, $fn=32);
        }
    }
}

module visualize_full_assembly() {
    rotate([0, 0, 180]) {
        color("gray") lower_chassis();
        translate([0, 0, STANDOFF_H]) color("darkred") upper_chassis();
        
        color("silver")
        for (x = [-BASE_WIDTH/2 + 20, BASE_WIDTH/2 - 20]) {
            for (y = [-BASE_LENGTH/2 + 20, BASE_LENGTH/2 - 20]) {
                translate([x, y, STANDOFF_H/2 + THICKNESS])
                difference() {
                    cylinder(r=4, h=STANDOFF_H, center=true, $fn=16);
                    m3_hole(h=STANDOFF_H+1);
                }
            }
        }
        
        // --- TAMPON MONTAJI (DÜZELTİLDİ) ---
        // Artık boşluk (-8) yok. Tam şasi sınırında (-BASE_LENGTH/2).
        translate([0, -BASE_LENGTH/2, STANDOFF_H + THICKNESS]) 
            rotate([90, 0, 0]) // BURNU AŞAĞI BAKIYOR
            bumper_hood_pure_nose_down();

        translate([0, 0, STANDOFF_H + THICKNESS]) spoiler();
        
        REAR_Y = BASE_LENGTH/2; 
        PANEL_THICKNESS = 8;
        OFFSET_Y = 5;
        translate([0, REAR_Y - PANEL_THICKNESS/2 + OFFSET_Y, THICKNESS + (STANDOFF_H - THICKNESS)/2])
        porsche_918_rear_panel();
        
        Z_POS = THICKNESS + MOTOR_HGT/2;
        translate([MOTOR_POS_X, MOTOR_POS_Y, Z_POS]) { color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true); translate([10 + MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true); }
        translate([-MOTOR_POS_X, MOTOR_POS_Y, Z_POS]) { color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true); translate([-10 - MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true); }
        translate([MOTOR_POS_X, -MOTOR_POS_Y, Z_POS]) { color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true); translate([10 + MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true); }
        translate([-MOTOR_POS_X, -MOTOR_POS_Y, Z_POS]) { color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true); translate([-10 - MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true); }
    }
}

// =======================================================
// BASKI MANTIĞI
// =======================================================
if (BASILACAK_PARCA == "MONTAJ") {
    visualize_full_assembly();
} 
else if (BASILACAK_PARCA == "ALT_SASE") {
    lower_chassis();
} 
else if (BASILACAK_PARCA == "UST_SASE") {
    upper_chassis();
} 
else if (BASILACAK_PARCA == "PANEL") {
    rotate([90, 0, 0]) porsche_918_rear_panel();
} 
else if (BASILACAK_PARCA == "SPOILER") {
    rotate([180, 0, 0]) spoiler();
} 
else if (BASILACAK_PARCA == "TAMPON") {
    // Baskı için yatık veriyoruz
    bumper_hood_pure_nose_down();
}