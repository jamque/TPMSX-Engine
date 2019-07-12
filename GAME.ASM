;------------------------------------
; Plantilla de Joc 48ks No BIOS
; V1.1
; Dec 2013-Jul 2019
;------------------------------------
TEST_BORDES=1	; Con solo que exista ya hace los bordes de pantalla en el TIMER

;------------------------------------
; Dades
;------------------------------------
	.BIOS
	.SIZE	48
;------------------------------------
; CONTINGUT PAGINA 0 (Antiga BIOS)
;------------------------------------
	.PAGE	0
	dw 0,0,0,0,0,0

	.ORG	38h	; Inici de la rutina de interrupcio
	db	0C3h
	dw	TIMER_R
;------------------------------------
; DADES FIXES (a ROM)  PAGE0
;------------------------------------
	; Pantalles
	; GFX
	; Datas
;------------------------------------
; Constants
;------------------------------------

 	.INCLUDE "LIB/_EQUS_.GEN"
	.INCLUDE "LIB/VNOTAS.GEN"
	.PAGE   1
	; CAPCELERA MANUAL per una ROM
	db	41h,42h
	dw	JOC
	dw	0,0,0,0,0,0
	db	"GAME"

;------------------------------------
; PROGRAMA - Inicialitzacio
;------------------------------------
	.INCLUDE "LIB/SET48K.GEN"
	;Librerias de Saphire y Ramones para situar los 48Ks ROM seguidos.

JOC:
	;nop
	di
	ld	SP,PILA

	; Screen 2,Sprites de 16x16
	call	SCREEN22		
	; Desactivacio del CLICK CLICK
	xor	A
	ld	[0F3DBh],A
	ld	[VBUFF_UPDATE],A	; Poso a 0 VBUFF_UPDATE
	; Posiciona la ROM de 48ks
	call	SET48K
	; Inicialitzacio del TIMER
	; No es fa el posicionar la Rutina de TIMER_R
	; pq ho fem per ROM adalt.
	; Nomes inicia TIMER_T
	call	TIMER_S	
	
RESTARTGAME:
; Preparo valors inicials del programa
	; LIMPIO SPRITES
	; VERSIO que sea la 0 y la tabla en el mismo SPRRAM (ahorro bytes)
	call	SPRT_INI		; Inicia Buffer Sprites RAM
	call	PT3_STOP
	; LIMPIO PANTALLA
	ld	D,0
	ld	HL,VBUFF	
	call	CLRSCR			; Inicia video a Tile 0
	
INIJOC:
	; Inicialitzacio dels TIMERS
	call	TIMERINI
	; DETECTA SI HI HA RATOLI, Sino emula CURSOR per Joystick
	;call	MOUSE_IS
	; Inicialitzacio del RATOLI
	;call	MOUSEINI
	; Inicialització de Variables del joc
	call	GAMEINI

	ei

;------------------------------------
; PROGRAMA - MAIN 
;------------------------------------
MAIN:
	halt
	call	MIRATECLA
	cp	27		; Surto del PRG si pulsen ESC
	jp	z,FIN
	
	call	GAMEMOTOR

	ld	A,[TIM_SPC]	; Control de Colisio de SPRITE
	cp	1
	call	z,SPRTCOL
	jp	MAIN
	
;------------------------------------
; PROGRAMA - Final de Programa
;------------------------------------

FIN:	
	di
	call	PT3_STOP
	jp	RESTARTGAME

;------------------------------------
; RUTINES - LIBRERIES
;------------------------------------
	; Poso cada funcio per separat aixi poso i trec la q uso y la que no

	.INCLUDE "LIB/CLRSCR.GEN"
	; Borra Buffer amb un Tile determinat
	.INCLUDE "LIB/COLORBR.GEN"
	; Canvia el color del Borde
	.INCLUDE "LIB/GETCURSORS.GEN"
	; Agafa els valors dels cursors + espai + M + Graph
	.INCLUDE "LIB/GETJOY.GEN"
	; Agafa els valors del joystick especificat a A
	.INCLUDE "LIB/IPBVRSALTER.GEN"
	; VOLCA buffer Sprite de 128 bytes A VRAM screen 1,2,3
	.INCLUDE "LIB/IWBVRM.GEN"
	; VOLCA B blocs de 8 bytes desde direccio RAM HL a la direccio VRAM DE
	.INCLUDE "LIB/MINIPSG.GEN"
	; Mini libreria para hacer efectos con el PSG
	.INCLUDE "LIB/MIRATECLA.GEN"
	; Control de teclat. Pasa de teclat a codi ascii
	; RAM:	CONTROL.RAM
	.INCLUDE "LIB/PSGMUTE.GEN"
	; Apaga PSG
	.INCLUDE "LIB/PT3PLAYER.GEN"
	; Player PT3
	; RAM:	PT3PLAYER.RAM
	.INCLUDE "LIB/SCREEN22.GEN" 
	; Posa Screen 2 i mode de Sprites 16 no ampliat
	.INCLUDE "LIB/SPRITES.GEN" 
	; Contiene dues rutinas
	; SPRT_INI :	Inicialitza la taula RAM de SPRITES
	; PUTSPRT : 	PUT SPRiTe com el de Basic a RAM SPRRAM
	; RAM:	VIDEO.RAM
	.INCLUDE "LIB/SPRTLD.GEN"
	; SPRiTes pattern LoaD a VRAM
	.INCLUDE "LIB/TECLA.GEN"
	; VOLCA l'estat del teclat (10bytes) a RAM TECLAT
	; RAM:	CONTROL.RAM
	.INCLUDE "LIB/TIMERS.GEN"
	; Control de timers y resets
	; RAM: TIMER.RAM
;------------------------------------------------
; MOTOR I TIMER 
;------------------------------------------------	
	.INCLUDE "GAMEmotor.GEN"
	.INCLUDE "GAMEtimer.GEN"
	; RAM:	TIMER.RAM

;------------------------------------
; DADES FIXES (a ROM) 
;------------------------------------
	; Pantalles
	; GFX
	; Datas
MUSIC_PT3:
	; MUSIC
	.INCBIN "DATA/MUSIC/prueba.pt3"
____PAGE_2_END:
;------------------------------------
; Variables : RAM
;------------------------------------
	.page	3	; RAM DADES
	;.ORG	0E000h ; Si es para 8ks, no empieza en Page3, sino polmedio.
____PAGE_3_RAM:	
PILA0:
	ds	256
PILA:	.byte
	; De SISTEMA
	.INCLUDE "RAM/CONTROL.RAM"
	.INCLUDE "RAM/PT3PLAYER.RAM"
	.INCLUDE "RAM/SET48K.RAM"
	.INCLUDE "RAM/TIMER.RAM"
	.INCLUDE "RAM/VIDEO.RAM"

	; De JOC en si
	.INCLUDE "RAM/game.RAM" 
____PAGE_3_RAM_END:

