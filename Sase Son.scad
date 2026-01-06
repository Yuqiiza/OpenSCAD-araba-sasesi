// --- TEMEL PARAMETRELER ---
THICKNESS = 4;        // Plaka kalınlığı
BASE_WIDTH = 140;     // Şasi Genişliği
BASE_LENGTH = 260;    // Şasi Uzunluğu
STANDOFF_H = 40;      // Katlar arası yükseklik
HOLE_R = 3.2/2;       // M3 vida yarıçapı
BUMPER_H = 40;        // Tampon Yüksekliği
HOOD_WIDTH = 140;     // Kaput Genişliği

// BİRLEŞME NOKTASI AYARLARI
JOINT_Y = -BASE_LENGTH/2;
SAFETY_GAP = 0;

// TT Motor Ölçüleri
MOTOR_LEN = 65;
MOTOR_WID = 23;
MOTOR_HGT = 18;

// Tekerlek
WHEEL_DIAMETER = 70;
WHEEL_R = WHEEL_DIAMETER / 2; // 35mm

// *** MOTOR YERLEŞİMİ ***
MOTOR_POS_X = BASE_WIDTH/2 - MOTOR_WID/2 + 4; 
MOTOR_POS_Y = BASE_LENGTH/2 - MOTOR_LEN/2 - 15;

// --- YARDIMCI MODÜLLER ---
module m3_hole(h = THICKNESS + 0.1) {
    cylinder(r = HOLE_R, h = h, center = true, $fn = 32);
}

module motor_mount_holes() {
    translate([0, 15, 0]) cube([10, 5, THICKNESS + 2], center=true);
    translate([0, MOTOR_LEN/2 + 5, 0]) m3_hole();
    translate([0, -MOTOR_LEN/2 - 5, 0]) m3_hole();
}

// --- ŞASİ ŞEKİLLERİ ---
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
        // Arka kısımlar
        translate([ BASE_WIDTH/2 - 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        translate([-BASE_WIDTH/2 + 10, BASE_LENGTH/2 - 10, 0]) cylinder(r=10, h=THICKNESS, center=true, $fn=32);
        // Ön taraf (DÜZ DUVAR)
        translate([ 0, JOINT_Y + 5, 0]) cube([BASE_WIDTH, 10, THICKNESS], center=true);
    }
}

// --- SPOR ÇAMURLUKLAR (70MM GENİŞLİK) ---
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
                // 1. ÇAMURLUK GÖVDESİ
                difference() {
                    union() {
                        translate([mx * WHEEL_SHIFT_X, 0, WHEEL_Z_OFFSET]) rotate([0, 90, 0])
                            cylinder(r=FENDER_R_IN + FENDER_THICK, h=FENDER_WIDTH, center=true, $fn=64);
                    }
                    translate([mx * (WHEEL_SHIFT_X + FENDER_THICK/2), 0, WHEEL_Z_OFFSET]) rotate([0, 90, 0])
                        cylinder(r=FENDER_R_IN, h=FENDER_WIDTH + FENDER_THICK + 10, center=true, $fn=64);
                    translate([0, 0, WHEEL_Z_OFFSET + 10 - 50])
                        cube([300, 200, 100], center=true);
                    translate([mx * (-90), 0, -50])
                         cube([40, 200, 100], center=true);
                }
                // 2. BAĞLANTI BLOĞU (70MM)
                translate([mx * 3, 0, 10])
                    cube([8, 70, 20], center=true);
                // Perçinler
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

// --- MODÜLLER ---
module lower_chassis() {
    difference() {
        translate([0,0,THICKNESS/2]) lower_chassis_shape();
        translate([-MOTOR_POS_X, MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([MOTOR_POS_X, MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([-MOTOR_POS_X, -MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([MOTOR_POS_X, -MOTOR_POS_Y, 0]) motor_mount_holes();
        translate([0, 0, 0]) cube([20, 40, 20], center=true);
        for(i=[-60:40:60]) {
             translate([0, i, 0]) cube([BASE_WIDTH-60, 10, 20], center=true);
        }
        translate([BASE_WIDTH/2 - 25, -BASE_LENGTH/2 + 5, 0]) m3_hole();
        translate([-BASE_WIDTH/2 + 25, -BASE_LENGTH/2 + 5, 0]) m3_hole();
    }
}

module upper_chassis() {
    translate([0, 0, STANDOFF_H])
    union() {
        difference() {
            translate([0,0,THICKNESS/2]) upper_chassis_shape();
            translate([-20, 25, 0]) m3_hole(h=20);
            translate([20, 25, 0]) m3_hole(h=20);
            translate([-20, -25, 0]) m3_hole(h=20);
            translate([20, -25, 0]) m3_hole(h=20);
            translate([0, BASE_LENGTH/2 - 40, 0]) cube([30, 10, 20], center=true);
            translate([0, -BASE_LENGTH/2 + 40, 0]) cube([30, 10, 20], center=true);
        }
        translate([0,0,THICKNESS/2]) sport_fenders(); 
    }
}

module standoffs() {
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
}

// --- TAMPON (DELİKLER KAPALI) ---
module bumper_base_shape() {
    color([0.1, 0.1, 0.1])
    union() {
        hull() {
            translate([BASE_WIDTH/2 - 5, -BASE_LENGTH/2 - 8, BUMPER_H/2])
                cylinder(r=8, h=BUMPER_H, center=true, $fn=32);
            translate([-BASE_WIDTH/2 + 5, -BASE_LENGTH/2 - 8, BUMPER_H/2])
                cylinder(r=8, h=BUMPER_H, center=true, $fn=32);
            translate([0, -BASE_LENGTH/2 - 20, BUMPER_H/2])
                cylinder(r=45, h=BUMPER_H, center=true, $fn=64);
            translate([0, -BASE_LENGTH/2 + 2, BUMPER_H/2])
                cube([BASE_WIDTH, 4, BUMPER_H], center=true);
        }
        color("black") translate([0, -BASE_LENGTH/2 - 12, 1])
        hull() {
            translate([BASE_WIDTH/2, 0, 0]) cylinder(r=5, h=2, center=true);
            translate([-BASE_WIDTH/2, 0, 0]) cylinder(r=5, h=2, center=true);
            translate([0, -15, 0]) cylinder(r=50, h=2, center=true, $fn=64);
        }
    }
}

module bumper_cuts() {
    union() {
        translate([0, -BASE_LENGTH/2 - 25, BUMPER_H/2]) rotate([-5, 0, 0])
        hull() {
            translate([0, 0, 0]) cube([70, 20, 25], center=true);
            translate([0, -5, 0]) cube([60, 20, 25], center=true);
        }
        for(side = [-1, 1]) {
            translate([side * 55, -BASE_LENGTH/2 - 15, BUMPER_H/2])
            rotate([0, side * 10, -side * 15]) cube([25, 20, 20], center=true);
        }
        translate([0, -BASE_LENGTH/2 - 30, BUMPER_H + 3])
            rotate([45, 0, 0]) cube([160, 20, 20], center=true);

        // *** SENSÖR DELİKLERİ İPTAL EDİLDİ ***

        // Şasi delikleri
        translate([BASE_WIDTH/2 - 25, -BASE_LENGTH/2 + 5, 10]) cylinder(r=1.6, h=50, center=true, $fn=32);
        translate([-BASE_WIDTH/2 + 25, -BASE_LENGTH/2 + 5, 10]) cylinder(r=1.6, h=50, center=true, $fn=32);
        // Kaput delikleri
        translate([50, -BASE_LENGTH/2 - 15, BUMPER_H]) cylinder(r=1.6, h=20, center=true, $fn=16);
        translate([-50, -BASE_LENGTH/2 - 15, BUMPER_H]) cylinder(r=1.6, h=20, center=true, $fn=16);
    }
}

module bumper_slats() {
    color("black") translate([0, -BASE_LENGTH/2 - 22, BUMPER_H/2]) rotate([-5, 0, 0])
    union() {
        cube([68, 2, 2], center=true);
        translate([0, 0, 8]) cube([72, 2, 2], center=true);
        translate([0, 0, -8]) cube([64, 2, 2], center=true);
        translate([0, 5, 0]) cube([75, 4, 28], center=true);
    }
}

module bumper_final() {
    union() {
        difference() {
            bumper_base_shape();
            bumper_cuts();
        }
        bumper_slats();
    }
}

// --- SPOILER ---
module spoiler() {
    MOUNT_X = 40;
    MOUNT_Y = BASE_LENGTH/2 - 10;
    WING_H = 35;
    SPOILER_BASE_Z = STANDOFF_H + THICKNESS;

    translate([0, 0, SPOILER_BASE_Z]) {
        color("black")
        for(side = [-1, 1]) {
            translate([side * MOUNT_X, MOUNT_Y, 0]) {
                hull() {
                    translate([0,0,0]) cube([10, 25, 2], center=true);
                    translate([0, 20, WING_H]) rotate([0,90,0]) cylinder(r=3, h=4, center=true);
                }
            }
        }
        color([0.2, 0.2, 0.2])
        translate([0, MOUNT_Y + 15, WING_H]) rotate([-10, 0, 0]) {
            difference() {
                hull() {
                    translate([0, -10, 0]) rotate([0,90,0]) cylinder(r=5, h=20, center=true);
                    translate([0, 25, 2])  rotate([0,90,0]) cylinder(r=1, h=20, center=true);
                    for(s = [-1, 1]) {
                        translate([s * 82, -15, -2]) rotate([0,90,0]) cylinder(r=3, h=2, center=true);
                        translate([s * 85, 30, 4])   rotate([0,90,0]) cylinder(r=0.5, h=2, center=true);
                    }
                }
                translate([0, 5, 1])
                rotate([0, 0, 180])
                linear_extrude(4)
                text("Ege Gokmen", size=10, font="Liberation Sans:style=Bold", halign="center", valign="center", spacing=1.1);
            }
            color("black")
            for(s = [-1, 1]) {
                translate([s * 85, 0, 0]) rotate([0, 0, s * -5]) {
                    hull() {
                        translate([0, -20, -8]) cube([1.5, 10, 15], center=true);
                        translate([0, 35, 5])   cube([1.5, 5, 15], center=true);
                        translate([0, 5, 0])    cube([1.5, 40, 2], center=true);
                    }
                }
            }
        }
    }
}

// --- KAPUT ---
HOOD_START_Z = BUMPER_H;
LIMIT_Y = (JOINT_Y - SAFETY_GAP);

module hood_body() {
    color("blue")
    union() {
        hull() {
            difference() {
                translate([0, -BASE_LENGTH/2 - 20, 2])
                    cylinder(r=45, h=4, center=true, $fn=64);
                translate([0, LIMIT_Y + 500, 0])
                    cube([1000, 1000, 100], center=true);
            }
            translate([0, LIMIT_Y - 0.5, 2])
                cube([HOOD_WIDTH, 1, 4], center=true);
        }
        translate([0, -BASE_LENGTH/2 - 10, 6])
        hull() {
            translate([0, -5, 0]) cylinder(r=25, h=4, center=true);
            translate([0, 5, 0]) cube([40, 1, 4], center=true);
        }
    }
}

module hood_cuts() {
    union() {
        for(side = [-1, 1]) {
            for(i = [0]) {
                translate([side * 35, -BASE_LENGTH/2 - 10, 3])
                rotate([15, 0, 0]) cube([30, 8, 10], center=true);
            }
        }
        translate([0, -BASE_LENGTH/2 - 20, 5]) difference() {
            cube([40, 10, 6], center=true);
            translate([0, -5, 0]) rotate([20,0,0]) cube([35, 10, 6], center=true);
        }
        translate([50, -BASE_LENGTH/2 - 15, 0]) cylinder(r=1.6, h=20, center=true, $fn=16);
        translate([-50, -BASE_LENGTH/2 - 15, 0]) cylinder(r=1.6, h=20, center=true, $fn=16);
    }
}

module hood_final() {
    translate([0, 0, HOOD_START_Z])
    difference() {
        hood_body();
        hood_cuts();
    }
}

// --- GÖRSELLEŞTİRME (DÜZELTİLDİ) ---
module visualize_motors_wheels() {
    Z_POS = THICKNESS + MOTOR_HGT/2;
    // TEKERLEKLERİ 14MM + YARI GENİŞLİK KADAR DIŞARI İTİYORUZ (Z-FIGHTING YOK)
    WHEEL_OFFSET = 14; 
    
    translate([MOTOR_POS_X, MOTOR_POS_Y, Z_POS]) {
        color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true);
        translate([WHEEL_OFFSET + MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true);
    }
    translate([-MOTOR_POS_X, MOTOR_POS_Y, Z_POS]) {
        color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true);
        translate([-WHEEL_OFFSET - MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true);
    }
    translate([MOTOR_POS_X, -MOTOR_POS_Y, Z_POS]) {
        color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true);
        translate([WHEEL_OFFSET + MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true);
    }
    translate([-MOTOR_POS_X, -MOTOR_POS_Y, Z_POS]) {
        color("yellow") cube([MOTOR_WID, MOTOR_LEN, MOTOR_HGT], center=true);
        translate([-WHEEL_OFFSET - MOTOR_WID/2, 0, 0]) rotate([0,90,0]) color("black") cylinder(r=WHEEL_R, h=25, center=true);
    }
}

// --- MONTAJ ---
rotate([0, 0, 180]) {
    union() {
        color("gray") lower_chassis();
        color("darkred") upper_chassis();
        standoffs();
        bumper_final();
        hood_final();
        spoiler();
        visualize_motors_wheels();
    }
}