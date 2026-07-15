#include "tiny68k.h"

#include <stdio.h>

int main(int argc, char **argv) {
    Tiny68kMachine machine;

    if (argc < 2) {
        fprintf(stderr, "usage: %s <image-file>\n", argv[0]);
        return 1;
    }

    tiny68k_init(&machine);
    if (!tiny68k_load_image(&machine, argv[1])) {
        fprintf(stderr, "failed to load image: %s\n", argv[1]);
        return 1;
    }

    tiny68k_init_video(&machine);
    tiny68k_init_keyboard(&machine);
    tiny68k_print_status(&machine);
    return 0;
}
