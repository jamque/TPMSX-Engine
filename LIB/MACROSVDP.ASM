; MACROS PARA VDP MSX2

; A = Register Status to Set
m_SET_STATUS_REGISTER: MACRO
	out	(99h),A
	ld	(VDP_REG + 0Fh),A
	ld	A,80h + 0Fh	; Register 0Fh: Status Register Index
	out	(99h),A
ENDM

m_READ_STATUS_REGISTER: MACRO
	in	A,(99h)
ENDM

; A = Data to Write to Register
m_WRITE_DATA_REGISTER: MACRO #REG
	out	(99h),A
	ld	(VDP_REG + #REG),A
	ld	A,80h + #REG	; Register to Write
	out	(99h),A
ENDM

; Flag NZ if V-Blank happens
m_CHECK_VBLANK: MACRO
	xor	A		; Status Register 0
	out	(99h),A
	ld	(VDP_REG + 0Fh),A
	ld	A,80h + 0Fh	; Register 0Fh: Status Register Index
	out	(99h),A
	in	A,(99h)
	and	10000000b 	; 7    F     V-Blank IRQ Flag (1=interrupt)
ENDM

; Flag NZ if V-Blank happens
m_CHECK_HBLANK: MACRO
	ld	A,1		; Status Register 1
	out	(99h),A
	ld	(VDP_REG + 0Fh),A
	ld	A,80h + 0Fh	; Register 0Fh: Status Register Index
	out	(99h),A
	in	A,(99h)
	and	00000001b 	;0    FH   Horizontal Retrace IRQ Flag
ENDM
