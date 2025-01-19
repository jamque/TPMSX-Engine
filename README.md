# TPMSX-Engine
Assembler MSX Z80 Code for ROM Games by ThePetsMode

## Notes
- Use https://github.com/Fubukimaru/asMSX as Assembler.
- Comments are in Catalan. My native language.
- Variable names in English.
- This code plays a PT3 file and show a Blue screen with some colors at the bottom of the screen. Put some PT3 music file in DATA/MUSIC to compile.

What's new:
---

---

2025-01

- Zilog Syntax. No more custom ASMSX Syntax with [ ]
- ASMSX version 1.0.1 or above compatible
- Files removed:
  - LIB/PLY41RUT.GEN - Replaced with new version 4.2
  - LIB/SCREEN21.GEN
  - LIB/SCREEN22.GEN
  - LIB/TILE2SP.GEN
  - LIB/TILE2SP8x8.GEN
  - RAM/PLY41RUT.RAM
- New system to access VDP with MACROS and keep a copy og VDP registers in RAM.
- Added support libraries for JOYMEGA 3 and 6 buttons
- Added support libraries for Trilotracker
- Updates LIB/_EQUS_.GEN for MSX2 VDP
- Legacy files used in Hans' Adventure:
  - LIB/DU.GEN
  - LIB/FIRE_SCN.GEN
- Some new LIB files for MSX2 Stuff VDP 9938
  - LIB/CHECKMSX2.GEN
  - LIB/CLRSCR5.GEN
  - LIB/COMVDP.GEN
  - LIB/LOADSC5.GEN
  - LIB/MEGAROM.GEN
  - LIB/MSX2_PUTPAL.GEN
  - LIB/MSX2_SCREEN.GEN
  - LIB/MSX2_SPRLDPOS.GEN
  - LIB/MSX2_SPRLDPOS_FROMBANK.GEN
  - LIB/SETPAGEVIEW.GEN
  - LIB/SPRITES2.GEN
  - RAM/VIDEO_MSX2.RAM

New Libraries files added:

* LIB/CHECKMSX2.GEN

Test if you are running on a MSX2 or not.

* LIB/CLRSCR5.GEN

Clear Screen 5 page with VDP Command in MSX2.

* LIB/CLRSCR_SLI.GEN

Slide to Right in Tile ID:0 in Screen 2-4. Using SLIDERI

* LIB/COMVDP.GEN

Exec a VDP command in MSX2.

* LIB/GETJOYMEGA3.GEN
* LIB/GETJOYMEGA6.GEN

Reads JOYMEGA joysticks.

* LIB/GETWASD.GEN

Get WASD as Player 2 controls format.

* LIB/IPBVRM.GEN

Interrupt pub buffer videoram.

* LIB/IRBVRM.GEN

Read Bloq Video RaM.

* LIB/KEY2JOY.GEN

Copy keyboard for play a game (cursors/Space/M or Graph) to Joystick variable.

* LIB/LOADGFX.GEN

Load a full screen GFX in Screen 2.

* LIB/LOADSC5.GEN

Load a full screen GFX in Screen 5.

* LIB/MEGAROM.GEN

Prepare some variabler to load Screen 5 images from Konami4 Megarom pages

* LIB/MULT.GEN

MUL 8 bits x 8 bits.

* LIB/MSX2_PUTPAL.GEN

Palette MSX2 Routines

* LIB/MSX2_SCREEN.GEN

V9938 MSX2 Routines to set screen parameters

* LIB/MSX2_SPRLDPOS_FROMBANK.GEN

SPRiTes pattern LoaD to POSition

* LIB/MSX2_SPRLDPOS_FROMBANK.GEN

SPRiTes pattern LoaD FROM a ROM BANK label to POSition

* LIB/PLY42RUT.GEN

New version of ZMA Player by The Pets Mode.

* LIB/PUTGFX_TILETRANS.GEN

Copy tiles to VRAM Screen 2 without a ID tile as transparent.

* LIB/RANDOM.GEN

Generates a good random number.

* LIB/SETPAGEVIEW.GEN

Set Page view in screen 5 VDP 9938 MSX2

* LIB/SCREEN.GEN

New libary to change screen mode, On/Off and solid 0 color in MSX2.

* LIB/SLOT3ROM.GEN

For use 64ks ROMS by Imanok.

* LIB/SPRITES2.GEN

PUT SPRITE for MSX2 (Screen4...8).

* LIB/SPRLDPOS.GEN

SPRiTes pattern LoaD to POSition.

* LIB/TTREPLAY.GEN
* LIB/TTREPLAYDAT.GEN
* LIB/TTSCCDETECT.GEN
* LIB/TTvoltable_combined.bin
* RAM/TTREPLAY.RAM

Replays for SCC+PSG TriloTracker re-player v0.3.1.
SCC-search v1.0 by Alwin Henseler.

* SRC/MACROS.ASM

A collection of Macros Added (Use ASMSX version 1.0.1 or above).

---

2019-07

* LIB/PT3PLAYER.GEN
* RAM/PT3PLAYER.RAM

Added PT3_SECOND and PT3_FRAME for music control

* LIB/SLIDERI.GEN

Fade to Right (tile to tile) HAVE HALTS inside!

* LIB/SPRT16HFLIP.GEN

Flip Sprite pattern data horizontaly in RAM

* GAMETIMER.GEN

Adding and control PT3_SECOND and PT3_FRAME for music

* GAMEMOTOR.GEN

Initialize PT3_PATTERN_POS, PT3_SECOND and PT3_FRAME

* GAME.ASM

Init VBUFF_UPDATE to 0.

Call to PT3_STOP before game starts
____PAGE3 tags for best debug

---

2017:
First Version
