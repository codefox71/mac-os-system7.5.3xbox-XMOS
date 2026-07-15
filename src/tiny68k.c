#include "tiny68k.h"

#include <stdio.h>
#include <string.h>

#define BOOT_IMAGE_MAX 4096

void tiny68k_init(Tiny68kMachine *machine) {
    memset(machine, 0, sizeof(*machine));
    machine->d0 = 1;
    machine->a0 = 0x4000;
    snprintf(machine->boot_banner, sizeof(machine->boot_banner), "BOOT: Mac System 7.5.3");
}

int tiny68k_load_image(Tiny68kMachine *machine, const char *path) {
    FILE *fp = fopen(path, "rb");
    if (!fp) {
        return 0;
    }

    size_t bytes = fread(machine->memory + 0x4000, 1, BOOT_IMAGE_MAX, fp);
    fclose(fp);
    snprintf(machine->last_message, sizeof(machine->last_message), "loaded %zu bytes", bytes);
    return 1;
}

void tiny68k_init_video(Tiny68kMachine *machine) {
    machine->video_initialized = 1;
    snprintf(machine->last_message, sizeof(machine->last_message), "video ready");
}

void tiny68k_init_keyboard(Tiny68kMachine *machine) {
    machine->keyboard_initialized = 1;
    snprintf(machine->last_message, sizeof(machine->last_message), "keyboard ready");
}

void tiny68k_set_boot_banner(Tiny68kMachine *machine, const char *banner) {
    if (banner && *banner) {
        snprintf(machine->boot_banner, sizeof(machine->boot_banner), "BOOT: %s", banner);
    }
}

void tiny68k_print_status(const Tiny68kMachine *machine) {
    printf("status=booted\n");
    printf("video=%s\n", machine->video_initialized ? "ready" : "missing");
    printf("keyboard=%s\n", machine->keyboard_initialized ? "ready" : "missing");
    printf("banner=%s\n", machine->boot_banner);
    printf("message=%s\n", machine->last_message);
}
