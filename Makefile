roms := \
	pokered.gbc \
	pokeblue.gbc \
	pokeblue_debug.gbc
patches := \
	pokered.patch \
	pokeblue.patch

rom_obj := \
	audio.o \
	home.o \
	main.o \
	maps.o \
	ram.o \
	text.o \
	gfx/pics.o \
	gfx/sprites.o \
	gfx/tilesets.o

pokered_obj        := $(rom_obj:.o=_red.o)
pokeblue_obj       := $(rom_obj:.o=_blue.o)
pokeblue_debug_obj := $(rom_obj:.o=_blue_debug.o)
pokered_vc_obj     := $(rom_obj:.o=_red_vc.o)
pokeblue_vc_obj    := $(rom_obj:.o=_blue_vc.o)


### Build tools

ifeq (,$(shell command -v sha1sum 2>/dev/null))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

RGBASMFLAGS  ?= -Weverything -Wtruncation=1
RGBLINKFLAGS ?= -Weverything -Wtruncation=1
RGBFIXFLAGS  ?= -Weverything
RGBGFXFLAGS  ?= -Weverything


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: \
	all \
	red \
	blue \
	blue_debug \
	nemesis \
	nemesis_speedtest \
	nemesis_landon \
	red_vc \
	blue_vc \
	clean \
	tidy \
	compare \
	tools

all: $(roms)
red:        pokered.gbc
blue:       pokeblue.gbc
blue_debug: pokeblue_debug.gbc
red_vc:     pokered.patch
blue_vc:    pokeblue.patch

# The build friends get: the same ROM as `make blue`, restamped with the Nemesis
# cartridge title. Keep -c here -- it sets the CGB flag ($143 = $80), which is
# what makes the color palettes work on a Game Boy Color and on phone emulators.
# Without it rgbfix pads the title over that byte and the game falls back to
# whatever colors the emulator invents.
nemesis: pokeblue.gbc
	cp pokeblue.gbc "PKMN Nemesis.gbc"
	$(RGBFIX) -jsv -n 0 -k 01 -l 0x33 -m MBC3+RAM+BATTERY -r 03 -p 0x00 -c -t "PKMN NEMESIS" "PKMN Nemesis.gbc"

# The speed-test build, restamped so it can never be mistaken for the real one:
# its own filename AND its own cartridge title, which is what emulators key the
# .sav file off -- so a speed-test run can't overwrite the main Nemesis save.
# Build it with: make clean && make blue SPEEDTEST=1 && make nemesis_speedtest
nemesis_speedtest: pokeblue.gbc
	cp pokeblue.gbc "PKMN Nemesis SPEEDTEST.gbc"
	$(RGBFIX) -jsv -n 0 -k 01 -l 0x33 -m MBC3+RAM+BATTERY -r 03 -p 0x00 -c -t "NEMESIS SPDTEST" "PKMN Nemesis SPEEDTEST.gbc"

# Landon's test build. Its own filename and cartridge title so it cannot be
# confused with the real ROM and cannot share its save file.
# Build it with: make clean && make blue LANDOSPEEDTEST=1 && make nemesis_landon
nemesis_landon: pokeblue.gbc
	cp pokeblue.gbc "PKMN Nemesis LANDON.gbc"
	$(RGBFIX) -jsv -n 0 -k 01 -l 0x33 -m MBC3+RAM+BATTERY -r 03 -p 0x00 -c -t "NEMESIS LANDON" "PKMN Nemesis LANDON.gbc"

clean: tidy
	find gfx \
	     \( -iname '*.1bpp' \
	        -o -iname '*.2bpp' \
	        -o -iname '*.pic' \) \
	     -delete

tidy:
	$(RM) $(roms) \
	      $(roms:.gbc=.sym) \
	      $(roms:.gbc=.map) \
	      $(patches) \
	      $(patches:.patch=_vc.gbc) \
	      $(patches:.patch=_vc.sym) \
	      $(patches:.patch=_vc.map) \
	      $(patches:%.patch=vc/%.constants.sym) \
	      $(pokered_obj) \
	      $(pokeblue_obj) \
	      $(pokered_vc_obj) \
	      $(pokeblue_vc_obj) \
	      $(pokeblue_debug_obj) \
	      rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(roms) $(patches)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS += -Q8 -P includes.asm
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

$(pokered_obj):        RGBASMFLAGS += -D _RED
$(pokeblue_obj):       RGBASMFLAGS += -D _BLUE
$(pokeblue_debug_obj): RGBASMFLAGS += -D _BLUE -D _DEBUG

# Opt-in test build: `make blue TESTPARTY=1` starts the player with 5 test mons
# (given on first PC open). Default `make blue` stays clean.
ifdef TESTPARTY
$(pokeblue_obj):       RGBASMFLAGS += -D _TESTPARTY
endif

# Opt-in speed-test build: `make blue SPEEDTEST=1` starts the player with HM02
# (Fly), max cash, key items (Silph Scope + Master Ball), the field badges, and
# every town pre-flyable, so testers can reach mid/late-game content fast.
# Default `make blue` stays clean. Run after `make clean` (flag changes aren't
# auto-detected).
ifdef SPEEDTEST
$(pokeblue_obj):       RGBASMFLAGS += -D _SPEEDTEST
endif

# Landon's test build: `make blue LANDOSPEEDTEST=1`. Deliberately NOT built on
# top of SPEEDTEST -- he asked (2026-08-09) to test the game exactly as a player
# would, with one exception: he starts with $50,000 instead of $3,000. No box
# mons, no bag kit, no badges, no pre-flyable towns, no post-game unlock, and
# normal text speed. The only guarded code left is the wallet in
# init_player_data.asm.
ifdef LANDOSPEEDTEST
$(pokeblue_obj):       RGBASMFLAGS += -D _LANDOSPEEDTEST
endif
$(pokered_vc_obj):     RGBASMFLAGS += -D _RED -D _RED_VC
$(pokeblue_vc_obj):    RGBASMFLAGS += -D _BLUE -D _BLUE_VC

%.patch: %_vc.gbc %.gbc vc/%.patch.template
	tools/make_patch $*_vc.sym $^ $@

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
preinclude_deps := includes.asm $(shell tools/scan_includes includes.asm)
define DEP
$1: $2 $$(shell tools/scan_includes $2) $(preinclude_deps) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for objects (drop _red and _blue from asm file basenames)
$(foreach obj, $(pokered_obj), $(eval $(call DEP,$(obj),$(obj:_red.o=.asm))))
$(foreach obj, $(pokeblue_obj), $(eval $(call DEP,$(obj),$(obj:_blue.o=.asm))))
$(foreach obj, $(pokeblue_debug_obj), $(eval $(call DEP,$(obj),$(obj:_blue_debug.o=.asm))))
$(foreach obj, $(pokered_vc_obj), $(eval $(call DEP,$(obj),$(obj:_red_vc.o=.asm))))
$(foreach obj, $(pokeblue_vc_obj), $(eval $(call DEP,$(obj),$(obj:_blue_vc.o=.asm))))

endif


RGBLINKFLAGS += -d
pokered.gbc:        RGBLINKFLAGS += -p 0x00
pokeblue.gbc:       RGBLINKFLAGS += -p 0x00
pokeblue_debug.gbc: RGBLINKFLAGS += -p 0xff
pokered_vc.gbc:     RGBLINKFLAGS += -p 0x00
pokeblue_vc.gbc:    RGBLINKFLAGS += -p 0x00

RGBFIXFLAGS += -jsv -n 0 -k 01 -l 0x33 -m MBC3+RAM+BATTERY -r 03
pokered.gbc:        RGBFIXFLAGS += -p 0x00 -t "POKEMON RED"
pokeblue.gbc:       RGBFIXFLAGS += -p 0x00 -c -t "POKEMON BLUE"
pokeblue_debug.gbc: RGBFIXFLAGS += -p 0xff -t "POKEMON BLUE"
pokered_vc.gbc:     RGBFIXFLAGS += -p 0x00 -t "POKEMON RED"
pokeblue_vc.gbc:    RGBFIXFLAGS += -p 0x00 -t "POKEMON BLUE"

%.gbc: $$(%_obj) layout.link
	$(RGBLINK) $(RGBLINKFLAGS) -l layout.link -m $*.map -n $*.sym -o $@ $(filter %.o,$^)
	$(RGBFIX) $(RGBFIXFLAGS) $@


### Misc file-specific graphics rules

gfx/battle/move_anim_0.2bpp: tools/gfx += --trim-whitespace
gfx/battle/move_anim_1.2bpp: tools/gfx += --trim-whitespace

gfx/intro/blue_jigglypuff_1.2bpp: RGBGFXFLAGS += --columns
gfx/intro/blue_jigglypuff_2.2bpp: RGBGFXFLAGS += --columns
gfx/intro/blue_jigglypuff_3.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_1.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_2.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_3.2bpp: RGBGFXFLAGS += --columns
gfx/intro/gengar.2bpp: RGBGFXFLAGS += --columns
gfx/intro/gengar.2bpp: tools/gfx += --remove-duplicates --preserve=0x19,0x76

gfx/credits/the_end.2bpp: tools/gfx += --interleave --png=$<

gfx/slots/red_slots_1.2bpp: tools/gfx += --trim-whitespace
gfx/slots/blue_slots_1.2bpp: tools/gfx += --trim-whitespace

gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace
gfx/tilesets/reds_house.2bpp: tools/gfx += --preserve=0x48

gfx/trade/game_boy.2bpp: tools/gfx += --remove-duplicates


### Catch-all graphics rules

%.2bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@ || $$($(RM) $@ && false))

%.1bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) --depth 1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) --depth 1 -o $@ $@ || $$($(RM) $@ && false))

%.pic: %.2bpp
	tools/pkmncompress $< $@


### File extensions that are never generated and should be manually created

%.asm: ;
%.inc: ;
%.png: ;
%.pal: ;
%.bin: ;
%.blk: ;
%.bst: ;
%.rle: ;
