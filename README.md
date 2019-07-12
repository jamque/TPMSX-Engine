# TPMSX-Engine
Assembler MSX Z80 Code for ROM Games by ThePetsMode

## Notes
- Use https://github.com/Fubukimaru/asMSX as Assembler.
- Comments are in mixed language, sometimes in Català, Castellano and English.
- This code plays a PT3 file and show a Blue screen with some colors at the bottom of the screen. Put some PT3 music file in DATA/MUSIC to compile.

What's new:
---

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
