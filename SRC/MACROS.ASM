; MACROS para TPMADV Engine

m_INC16: MACRO #VARIABLE
	push	HL
	ld	HL,#VARIABLE
	inc	(HL)
	pop	HL
ENDM

m_RESET16: MACRO #VARIABLE
	push	HL
	ld	HL,#VARIABLE
	ld	(HL),0
	pop	HL
ENDM

m_INCVALUE_MAX: MACRO #VARBIABLE,#MAX
	ld	A,(#VARBIABLE)
	inc	A
	cp	#MAX
	jr	nz,.noreset_#VARBIABLE
	xor	A
.noreset_#VARBIABLE:
	ld	(#VARBIABLE),A
ENDM

m_INCVALUE_MAX_KEEP: MACRO #VARBIABLE,#MAX
	ld	A,(#VARBIABLE)
	cp	#MAX
	jr	z,.noinc_#VARBIABLE
	inc	A
	ld	(#VARBIABLE),A
.noinc_#VARBIABLE:
ENDM

m_INCVALUE_MAX_RESET: MACRO #VARBIABLE,#MAX,#RESETVALUE
	ld	A,(#VARBIABLE)
	inc	A
	cp	#MAX
	jr	nz,.noreset_#VARBIABLE
	ld	A,#RESETVALUE
.noreset_#VARBIABLE:
	ld	(#VARBIABLE),A
ENDM

m_ADDVALUE_MAX: MACRO #VARBIABLE,#VALUE,#MAX
	ld	A,(#VARBIABLE)
	add	A,#VALUE
	cp	#MAX
	jr	nz,.noreset_#VARBIABLE
	xor	A
.noreset_#VARBIABLE:
	ld	(#VARBIABLE),A
ENDM

m_SOUND: MACRO #SONIDO,#DURACION
	push	HL
	push	BC
	ld	C,#DURACION
	ld	HL,#SONIDO
	call	PLAYFX
	pop	BC
	pop	HL
ENDM

m_DO_EVENTS: MACRO #LIST_EVENTS
	push	IX
	ld	IX,#LIST_EVENTS
	call	RUNEVENTS
	pop	IX
ENDM

m_CLEAR_ZERO: MACRO #INIT,#END
	push	BC
	push	HL
	push	DE
	ld	BC, #END - [#INIT+1]
	ld	HL, #INIT
	ld	DE, #INIT +1
	ld	(HL),0
	ldir
	pop	DE
	pop	HL
	pop	BC
ENDM

m_CLEAR_VBUFF_WITH: MACRO #DATA
	ld	BC, [VBUFF+768] - [VBUFF+1]
	ld	HL, VBUFF
	ld	DE, VBUFF +1
	ld	(HL),#DATA
	ldir
ENDM

m_CLEAR_LINES_VBUFF_WITH: MACRO #DATA,#INIT,#LINES
	ld	BC, [VBUFF+#INIT*32+#LINES*32] - [VBUFF+1+#INIT*32]
	ld	HL, [VBUFF+#INIT*32]
	ld	DE, [VBUFF+#INIT*32+1]
	ld	(HL),#DATA
	ldir
ENDM

; Marco para que se actualice VRAM
m_VBUFF_READY: MACRO
	ld	A,1
	ld	(VBUFF_UPDATE),A
ENDM


m_LOAD_3BANKS: MACRO #PATTERNS,#COLORS
	; WARNING!! need DI
	ld 	HL,#PATTERNS
	ld 	DE,VRM_PAT
	call 	IWBVRMRLE2
	ld 	HL,#PATTERNS
	ld 	DE,VRM_PAT+2048
	call 	IWBVRMRLE2
	ld 	HL,#PATTERNS
	ld 	DE,VRM_PAT+4096
	call 	IWBVRMRLE2
	ld 	HL,#COLORS
	ld 	DE,VRM_COL
	call 	IWBVRMRLE2
	ld 	HL,#COLORS
	ld 	DE,VRM_COL+2048
	call 	IWBVRMRLE2
	ld 	HL,#COLORS
	ld 	DE,VRM_COL+4096
	call 	IWBVRMRLE2
ENDM

m_PUTGFX_RAM: MACRO #GFX,#X,#Y,#TARGET
	ld	IX,#GFX
	ld	IY,#TARGET+#X+32*#Y
	call	PUTGFX
ENDM

m_PUTGFX_TRANS: MACRO #GFX,#X,#Y,#TARGET,#TRANS
	ld	IX,#GFX
	ld	IY,#TARGET+#X+32*#Y
	ld	C,#TRANS
	call	PUTGFX_TRANS
ENDM

m_PUTGFX_SC5: MACRO #GFX,#X,#Y,#PAG
; #X Ha de ser Pixel parell 0,2,4,6,...
	ld	B,#PAG
	ld	HL,(#GFX)
	ld	DE,VRM_BIT+[#Y*128]+[#X/2]
	call	IWBVRM5RLE2
ENDM

m_COPY_SC5: MACRO #X,#Y,#DEST_PAG
; Espera Puntero a GFXSC5 en IY
	ld	B,#X ; X
	ld	C,#Y ; Y
	ld	IX,VDPCOMDATA
	ld	A,(IY)
	ld	(IX+0), A		;SXL
	ld	(IX+1), 0		;SXH
	ld	A,(IY+1)
	ld	(IX+2), A		;SYL
	ld	A,(IY+4)
	ld	(IX+3), A		;SYH Page
	ld	(IX+4), B		;DXL
	ld	(IX+5), 0		;DXH
	ld	(IX+6), C		;DYL
	ld	(IX+7), #DEST_PAG	;DYH Page
	ld	A,(IY+2)
	ld	(IX+8), A		;INCXL
	ld	(IX+9), 0		;INCXH
	ld	A,(IY+3)
	ld	(IX+10), A		;INCYL
	ld	(IX+11), 0		;INCYH
	;ld	(IX+12), 0		;Color register no se usa
	ld	(IX+13), 0		;ARG Para este caso SIEMPRE 0
	ld	(IX+14), CMDCOPY	; Copy Rectangle VRAM->VRAM
	ld	HL,VDPCOMDATA	; Envio CMD
	call	_VDPCMD
ENDM

m_COPYMASK_SC5: MACRO #X,#Y,#DEST_PAG
; Espera Puntero a GFXSC5 en IY
	ld	B,#X ; X
	ld	C,#Y ; Y
	ld	IX,VDPCOMDATA
	ld	A,(IY)
	ld	(IX+0), A		;SXL
	ld	(IX+1), 0		;SXH
	ld	A,(IY+1)
	ld	(IX+2), A		;SYL
	ld	A,(IY+4)
	ld	(IX+3), A		;SYH Page
	ld	(IX+4), B		;DXL
	ld	(IX+5), 0		;DXH
	ld	(IX+6), C		;DYL
	ld	(IX+7), #DEST_PAG	;DYH Page
	ld	A,(IY+2)
	ld	(IX+8), A		;INCXL
	ld	(IX+9), 0		;INCXH
	ld	A,(IY+3)
	ld	(IX+10), A		;INCYL
	ld	(IX+11), 0		;INCYH
	;ld	(IX+12), 0		;Color register no se usa
	ld	(IX+13), 0		;ARG Para este caso SIEMPRE 0
	ld	(IX+14), CMDCOPY0	; Copy Rectangle VRAM->VRAM Mask color 0
	ld	HL,VDPCOMDATA	; Envio CMD
	call	_VDPCMD
ENDM

; USE RECOVER after a CHANGE !!
; #MEMDIR 6000, 8000, 0A000
m_CHANGE_TOSUBPAGE: MACRO #SUBP,#MEMDIR
	ld	A,(#MEMDIR)
	push	AF
	ld	A,#SUBP
	ld	(#MEMDIR+01000h),A
ENDM

m_RECOVER_SUBPAGE: MACRO #MEMDIR
	pop	AF
	ld	(#MEMDIR+01000h),A
ENDM

m_MANUAL_IE:	MACRO #TAGTOEXIT
	; Anem a llegir el Registre S1, posem el 1 al Registre 0fh
	ld	A,1		; Registre Status 1
	out	(99h),A
	ld	A,80h + 0Fh	; Registre 0fh
	out	(99h),A
	in	A,(99h)	; El bit 0, marca si hi ha HSync
	and	1
	jr	nz,.MAKE_IE
	ld	A,2	; return 2. No es fa la IE
	jp	.next#TAGTOEXIT
.MAKE_IE:
	push	BC
	push	DE
	push	HL
;------------
	ld	A,MAXY_SCREEN
	ld	B,A
	ld	A,(V_SCN_INTRO_SCROLLROW)
	add	A,B
	ld	B,A
	ld	A,(HBLANK_LINE)
	cp	B
	jr	z,.HBLANK_2
	;Posem la paleta del UI al 144
	ld	HL,PAL_UI_STAN
	xor	A
	out	(99h),A
	ld	A,080h+10h	; a Registre 10h Color inicial
	out	(99h),A
	ld	C,9Ah	; 32 vegades a port 9A
REPT 32
	outi
ENDR
	ld	A,MAXY_SCREEN
	; Teniendo en cuenta el registro de Scroll
	ld	B,A
	ld	A,(V_SCN_INTRO_SCROLLROW)
	add	A,B
	ld	(HBLANK_LINE),A
	out	(99h),A
	ld	A,80h + 13h
	out	(99h),A
	ld	A,1	; return 1. No es fa UI al HBLANK_LINE
	jp	.END
.HBLANK_2:
	; La paleta que toque del grafico
	ld	HL, (GFXDATASC5_PAL)
	xor	A
	out	(99h),A
	ld	A,080h+10h	; a Registre 10h Color inicial
	out	(99h),A
	ld	C,9Ah	; 32 vegades a port 9A
	; Sin esperas pq VDP del MSX2 no las requiere.
REPT 32
	outi
ENDR
	ld	A,(HBLANK_FRAMELINE)
	ld	B,A
	ld	A,(V_SCN_INTRO_SCROLLROW)
	add	A,B
	ld	(HBLANK_LINE),A
	out	(99h),A
	ld	A,80h + 13h
	out	(99h),A
	;SELECT 1 AT 06000h con el sistema de ID de subslot
	ld	A,(06000h)
	push	AF
	ld	A,1
	ld	(07000h),A
	;SELECT 22 AT 0A000h con el sistema de ID de subslot
	ld	A,(0A000h)
	push	AF
	ld	A,22
	ld	(0B000h),A
	call	replay_route		; first outout data
	call	replay_play		; calculate next output
	; Recupera subpage
	pop	AF
	ld	(0B000h),A
	; Recupera subpage
	pop	AF
	ld	(07000h),A
	xor	A	; return 0
;------------
.END:
	pop	HL
	pop	DE
	pop	BC
.next#TAGTOEXIT:
ENDM

m_PUTSPRITE: MACRO #PATTERN,#X,#Y,#PLANO,#COLOR
	ld	HL,[#Y*256+#X] 	; Y,X
	ld	D,#PATTERN*4	; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO	; Plano
	call	PUTSPRT
ENDM

m_PUTSPRITE_VARXY: MACRO #PATTERN,#X,#Y,#PLANO,#COLOR
	ld	A,(#X)
	ld	L,A
	ld	A,(#Y)
	ld	H,A
	;ld	HL,[#Y*256+#X] 	; Y,X
	ld	D,#PATTERN*4	; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO	; Plano
	call	PUTSPRT
ENDM

m_EVENTENTRY: MACRO #VAR,#UPDATE
	ld	A,(#VAR)
	or	A
	jr	nz,#UPDATE
	ld	A,1
	ld	(#VAR),A
ENDM



m_PUTSP32: MACRO #PATTERN,#X,#Y,#PLANO,#COLOR,#ZOOM
	ld	HL,[#Y*256+#X] 	; Y,X
	ld	D,#PATTERN	; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO	; Plano
	call	PUTSPRT
	ld	HL,[#Y*256+#X+#ZOOM] ; Y,X
	ld	D,[#PATTERN+1]*4  ; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO+1	; Plano
	call	PUTSPRT
	ld	HL,[[#Y+#ZOOM]*256+#X] ; Y,X
	ld	D,[#PATTERN+2]*4    ; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO+2	; Plano
	call	PUTSPRT
	ld	HL,[[#Y+#ZOOM]*256+#X+#ZOOM] ; Y,X
	ld	D,[#PATTERN+3]*4       ; Pattern
	ld	E,#COLOR	; Color
	ld	C,#PLANO+3	; Plano
	call	PUTSPRT
ENDM

m_MANUAL_IE_PT3:	MACRO #NUMPAGE,#DIR,#TAGTOEXIT
	; Anem a llegir el Registre S1, posem el 1 al Registre 0fh
	ld	A,1		; Registre Status 1
	out	(99h),A
	ld	A,10001111b	; Registre 0fh
	out	(99h),A
	in	A,(99h)	; El bit 0, marca si hi ha HSync
	and	1
	jr	z,.next#TAGTOEXIT
	push	BC
	push	DE
	push	HL
	ld	A,(6000h)
	push	AF
	SELECT  #NUMPAGE AT #DIR
	call 	TIMER_PLAYER_FULL
	pop	AF
	SELECT	A AT #DIR
	pop	HL
	pop	DE
	pop	BC
.next#TAGTOEXIT:
ENDM

m_CHANGE_INTERRUPT:	MACRO #NEWINTERRUPT
	ld	HL,0FD9Ah
    ld      BC,#NEWINTERRUPT
    ld      (HL),0C3h
    inc     HL
    ld      (HL),C
    inc     HL
    ld      (HL),B
ENDM
