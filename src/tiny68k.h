#ifndef TINY68K_H
#define TINY68K_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    uint8_t memory[1024 * 1024];
    uint32_t d0;
    uint32_t d1;
    uint32_t a0;
    int video_initialized;
    int keyboard_initialized;
    char boot_banner[64];
    char last_message[128];
} Tiny68kMachine;

void tiny68k_init(Tiny68kMachine *machine);
int tiny68k_load_image(Tiny68kMachine *machine, const char *path);
void tiny68k_init_video(Tiny68kMachine *machine);
void tiny68k_init_keyboard(Tiny68kMachine *machine);
void tiny68k_set_boot_banner(Tiny68kMachine *machine, const char *banner);
void tiny68k_print_status(const Tiny68kMachine *machine);

#ifdef __cplusplus
}
#endif

#endif
