CC := gcc
CFLAGS := -DSOKOL_GLES2 -DSOKOL_FORCE_EGL -DLOG_USE_COLOR
CDEPS := -lm -pthread $(shell pkg-config --libs xi x11 egl glesv2 xcursor)
CSOURCE := *.c lib/*.c -I.

CORES   = $(shell getconf _NPROCESSORS_ONLN)
MAKEFLAGS := -j $(CORES)

lua-boot:
	xxd -i boot.lua > lua_boot.h

shaders:
	sokol-shdc -i shader.glsl -o shader.h -l glsl100:hlsl5:metal_macos

demo:
	tcc $(CSOURCE) $(CDEPS) $(CFLAGS) -DSTBI_NO_SIMD -o meshbox.debug
	./meshbox.debug demo

demo-zip:
	tcc $(CSOURCE) $(CDEPS) $(CFLAGS) -DSTBI_NO_SIMD -o meshbox.debug
	zip -j data.bin demo/*
	./meshbox.debug
#	rm data.bin

debug: lua-boot
	gcc $(CSOURCE) $(CDEPS) $(CFLAGS) -ggdb -o meshbox

splash: lua-boot shaders
	tcc $(CSOURCE) $(CDEPS) $(CFLAGS) -DSTBI_NO_SIMD -o meshbox.debug
	./meshbox.debug demo

release: lua-boot
	gcc $(CSOURCE) $(CDEPS) $(CFLAGS) -Os -o meshbox

.PHONY: demo
