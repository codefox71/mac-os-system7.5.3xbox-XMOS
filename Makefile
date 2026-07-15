CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra -std=c99

all: build/tiny68k build/hello_boot

build/tiny68k: src/tiny68k.c src/tiny68k_main.c src/tiny68k.h
	mkdir -p build
	$(CC) $(CFLAGS) -I src -o $@ src/tiny68k.c src/tiny68k_main.c

build/hello_boot: examples/hello_boot.c src/tiny68k.c src/tiny68k.h
	mkdir -p build
	$(CC) $(CFLAGS) -I src -o $@ examples/hello_boot.c src/tiny68k.c

clean:
	rm -rf build
