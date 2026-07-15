#include <stdio.h>
#include "../src/tiny68k.h"

int main(void) {
    Tiny68kMachine machine;
    tiny68k_init(&machine);
    tiny68k_load_image(&machine, "example.img");
    tiny68k_init_video(&machine);
    tiny68k_init_keyboard(&machine);
    tiny68k_set_boot_banner(&machine, "Mac System 7.5.3");
    tiny68k_print_status(&machine);
    return 0;
}
