;------------------------------------
; Plantilla de Joc 48ks No BIOS
; ZILOG Compatible
; V2.0
; Dec 2013-Jul 2019-Gen-2022
;------------------------------------
TEST_BORDES= 1	; Amb nomes que existeixi ja fa les bores de la pantalla al TIMER
USE_SCREEN = 2
FPS_MUSIC = 60 ; 50 o 60 Hz
;------------------------------------
; Dades
;------------------------------------
	ZILOG
	ROM
	BIOS
	SIZE	48
;------------------------------------
; Constants (No ocupan ROM)
;------------------------------------
	INCLUDE "LIB/_EQUS_.GEN"
	INCLUDE "LIB/VNOTAS.GEN"
___END_PAGE_0:

;------------------------------------
; Macros (No ocupan ROM)
;------------------------------------
	INCLUDE "SRC/MACROS.ASM"
	INCLUDE "LIB/MACROSVDP.ASM"

;------------------------------------
; CONTINGUT PAGINA 0 (Antiga BIOS)
;------------------------------------
	PAGE	0
	db 0

	ORG	38h	; Inici de la rutina de interrupcio
	db	0C3h
	dw	TIMER_R
;------------------------------------
; DADES FIXES (a ROM)  PAGE 0
;------------------------------------
	; Pantalles
	; GFX
	; Datas

;------------------------------------
; PAGE 1
;------------------------------------
	PAGE   1
	; CAPCELERA MANUAL per una ROM
	db	41h,42h
	dw	JOC
	db	"GAME"

;------------------------------------
; PROGRAMA - Inicialitzacio
;------------------------------------
	INCLUDE "LIB/SET48K.GEN"
	;Librerias de Saphire y Ramones para situar los 48Ks ROM seguidos.

JOC:
	ei
	halt	; Frame de espera per sincro. Ultima pasada per BIOS
	di
	;Neteja RAM
	;bytes a posar a zero OJU! Variables de BIOS!(F37F->FFFF)
	m_CLEAR_ZERO 0C000h,0F37Fh
	ld	SP,PILA

	; Screen 2,Sprites de 16x16
	ld	A,USE_SCREEN
	call	SCREEN
	di
	; Posiciona la ROM de 48ks
	call	SET48K
	; Desactivacio del CLICK CLICK
	xor	A
	ld	(0F3DBh),A

	; Inicialitzacio del TIMER
	; No es fa el posicionar la Rutina de TIMER_R
	; pq ho fem per ROM adalt.
	; Nomes inicia TIMER_T
	call	TIMER_S	; !!!!(dins fa ei)!!!!!
	
RESTARTGAME:
	; Preparo valors inicials del programa
	; LIMPIO SPRITES
	ld	A,0			; Sprite DUMMY
	ld	IX,SPRRAM
	call	SPRT_INI		; Inicia Buffer Sprites RAM
	call	PT3_STOP		; Para i prepara player PT3
	call	TIMERINI		; Inicialitzacio dels TIMERS
	; NETEJA BUFFER DE VIDEO
	call	SCREEN_OFF
	ld	A,1
	ld	(VBUFF_UPDATE),A	; Marco para que se actualice VRAM
	ei
	halt	; Pasa 1 frame per actualitzar VRAM
	di
	
INIJOC:
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

	ld	A,(TIM_SPC)	; Control de Colisio de SPRITE
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
	; Poso cada funcio per separat aixi poso i trec la q uso i la que no
	; Hi ha moltes mes rutines a LIB/ !

	INCLUDE "LIB/CLRSCR.GEN"
	; Borra Buffer amb un Tile determinat
	INCLUDE "LIB/COLORBR.GEN"
	; Canvia el color del Borde
	INCLUDE "LIB/GETCURSORS.GEN"
	; Agafa els valors dels cursors + espai + M + Graph
	INCLUDE "LIB/GETJOY.GEN"
	; Agafa els valors del joystick especificat a A
	INCLUDE "LIB/IPBVRSALTER.GEN"
	; VOLCA buffer Sprite de 128 bytes A VRAM screen 1,2,3
	INCLUDE "LIB/IWBVRM.GEN"
	; VOLCA B blocs de 8 bytes desde direccio RAM HL a la direccio VRAM DE
	INCLUDE "LIB/MINIPSG.GEN"
	; Mini libreria para hacer efectos con el PSG
	INCLUDE "LIB/MIRATECLA.GEN"
	; Control de teclat. Pasa de teclat a codi ascii
	; RAM:	CONTROL.RAM
	INCLUDE "LIB/PSGMUTE.GEN"
	; Apaga PSG
	INCLUDE "LIB/PT3PLAYER.GEN"
	; Player PT3
	; RAM:	PT3PLAYER.RAM
	INCLUDE "LIB/SCREEN.GEN"
	; Posa Screen 2 i mode de Sprites 16 no ampliat
	INCLUDE "LIB/SPRITES.GEN"
	; Contiene dues rutinas
	; SPRT_INI :	Inicialitza la taula RAM de SPRITES
	; PUTSPRT : 	PUT SPRiTe com el de Basic a RAM SPRRAM
	; RAM:	VIDEO.RAM
	INCLUDE "LIB/SPRTLD.GEN"
	; SPRiTes pattern LoaD a VRAM
	INCLUDE "LIB/TECLA.GEN"
	; VOLCA l'estat del teclat (10bytes) a RAM TECLAT
	; RAM:	CONTROL.RAM
	INCLUDE "LIB/TIMERS.GEN"
	; Control de timers y resets
	; RAM: TIMER.RAM
;------------------------------------------------
; MOTOR I TIMER 
;------------------------------------------------	
	INCLUDE "GAMEmotor.GEN"
	INCLUDE "GAMEtimer.GEN"
	; RAM:	TIMER.RAM

;------------------------------------
; DADES FIXES (a ROM) 
;------------------------------------
	; Pantalles
	; GFX
	; Datas
MUSIC_PT3:
	; MUSIC
	INCBIN "DATA/MUSIC/prueba.pt3"
___END_PAGE_2:
;------------------------------------
; Variables : RAM
;------------------------------------
	PAGE	3	; RAM DADES
	;.ORG	0E000h ; Si es para 8ks, no comença a Page3, sino per el mig.
___RAM___:
PILA0:
	ds	256
PILA:	.byte
	; De SISTEMA
	INCLUDE "RAM/CONTROL.RAM"
	INCLUDE "RAM/PT3PLAYER.RAM"
	INCLUDE "RAM/SET48K.RAM"
	INCLUDE "RAM/TIMER.RAM"
	INCLUDE "RAM/VIDEO.RAM"

	; De JOC en si
	INCLUDE "RAM/GAME.RAM"
___END_RAM:

;------------------------------------
; Informe en TEXTO
;------------------------------------
PRINTTEXT "------------------------------------"
PRINTTEXT "* PAGE 0 (Under BIOS) [Max 16384]:"
PRINTTEXT "  - USE:"
PRINT ___END_PAGE_0
PRINTTEXT "  - LEFT:"
PRINT 04000h - ___END_PAGE_0
PRINTTEXT "------------------------------------"
PRINTTEXT "* PAGE 1-2 (Main code) [Max 32768]:"
PRINTTEXT "  - USE:"
PRINT ___END_PAGE_2 - 04000h
PRINTTEXT "  - LEFT:"
PRINT 0C000h - ___END_PAGE_2
PRINTTEXT "------------------------------------"
PRINTTEXT "* RAM [Max 16384]:"
PRINTTEXT "  - USE:"
PRINT ___END_RAM - ___RAM___
PRINTTEXT "  - LEFT:"
PRINT 0FFFFh - ___END_RAM
PRINTTEXT "------------------------------------"
PRINTTEXT "* TOTAL ROM Bytes Used"
PRINT ___END_PAGE_0 + [___END_PAGE_2 - 04000h]
PRINTTEXT "------------------------------------"
