include <threads.scad>

// This pole attachment makes it a little easier to scrape gutters you can't otherwise reach.

// Number of tines around full perimeter before halving
number_of_tines = 10;
// Height of the whole attachment
// - Raise this to make the interior angle printable
attachment_height = 80;
// Radius of the whole attachment
// - Size to your gutter
attachment_width = 70;
// Depth of the tine extending from the cone
// - Increase to extend how much you can scrape up without breaking the tips off
tine_depth = 10;
// Thickness of the tine tip
// - Increase to make tines stronger if they brake off with scraping
tine_thickness = 3;
// Width of chamfer on tines
// - Size to adjust the pointiness of the tips
tine_chamfer = 30;
// Width of cutout between tines
// - Size to adjust strength of the tines
tine_seperation = 5;
// How offcenter the pole is to the main cone
// - Size to fit your gutter and ensure the last tines get cut off in a reasonable spot
pole_offset = 10;
// Radius of pole attachment
// - Increase to strengthen pole attachment
pole_thickness = 17;
// Length of pole threads
// - Fit to the thread length on your pole
thread_length_in = .75;
// Height of tine support cone
// - Derived - adjust other parameters until printable without supports
support_height = attachment_height - thread_length_in * 27;

module pole_thread() {
    translate([0,-pole_offset,0]) {
        difference() {
            // Pole mount
            cylinder(attachment_height, r=pole_thickness, center=false);
            // Cut Threads
            translate([0,0,attachment_height]) {
                rotate([0,180,0]) {
                    // Scale threads to fit after printing expansion
                    scale([1.05,1.05,1.05]) {
                        // Hose Thread
                        //english_thread (diameter=1.0625, threads_per_inch=11.5, length=thread_length_in,internal=true);
                        // Pole Thread
                        english_thread (diameter=0.78, threads_per_inch=5, length=thread_length_in,internal=true, square=true, leadin=2);
                    }
                }
            }
        }
    }
}

difference() {
    union() {
        // Flat plate
        cylinder(tine_thickness,r=attachment_width,center=false);
        // Outer Cone
        cylinder(support_height,r1=attachment_width - tine_depth,r2=5,center=false);
        // Threads at the top
        pole_thread();
    }
    // Inner Cone
    cylinder(support_height-10,r1=attachment_width-tine_depth-1,r2=0,center=false);
    // Tines
    for (i = [0 : number_of_tines]) {
        rotate([0, 0, i * (360 / number_of_tines)]) {
            translate([0,attachment_width,0]) {
                rotate([0,0,45]) {
                    // Chamfer Tines
                    cube([tine_chamfer,tine_chamfer,200], center=true);
                    
                }
                // Cutout between tines
                scale([tine_seperation,attachment_width * 2/5,1]) {
                    cylinder(200, r=1, center=false, $fn=32);
                }
            }
        }
    }
    // Cut half-off
    translate([-200,pole_thickness - pole_offset,0]) {
        cube(size=400);
    }
}

