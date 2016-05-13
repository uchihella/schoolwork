;=====================================================================
;			PARITY [MAIN] PROGRAM
;	DESCRIPTION:
;	FINDS PARITY OF 16-BIT INPUT NUMBER
;	
;=====================================================================

	DOSSEG
	.MODEL  LARGE,BASIC

							;PROCEDURES TO
	EXTRN	CLEAR:FAR		;CLEAR SCREEN
	EXTRN	GETDEC$:FAR		;GET 16-BIT DECIMAL INTEGER
	EXTRN	NEWLINE:FAR		;DISPLAY NEWLINE CHARACTER
	EXTRN	PUTDEC$:FAR		;DISPLAY 16-BIT DECIMAL INTEGER
	EXTRN	PUTBIN:FAR
	EXTRN	PUTSTRNG:FAR	;DISPLAY CHARACTER STRING
	EXTRN	PAUSE:FAR		;DISPLAY CHARACTER STRING
	EXTRN	PARITY:FAR
	
;===================================================================
;
; S T A C K   S E G M E N T   D E F I N I T I O N
;
	.STACK  256

;===================================================================
;
; C O N S T A N T   S E G M E N T   D E F I N I T I O N
;
.CODE
.DATA
HEADER		DB	'INPUT NUMBER TO FIND PARITY: '
REPORT		DB	'ORIGINAL                BINARY     PARITY #     PARITY'
EVMSG		DB	'EVEN'
ODMSG		DB	' ODD'
SPACES		DB	'               '
DEBUG		DB	'EXECUTED PAST THIS LINE'	;23 CHARS
PAUMSG		DB	'PRESS ANY KEY TO CONTINUE ... '
NAME_IR		DB	' PARITY PROGRAM BY IAN ROSNER '
;===============================================================
;
; D A T A   S E G M E N T   D E F I N I T I O N
;
INPUT		DW	?
PARBITS		DW	?
EVENODD		DW	?	;EVEN = 0, ODD = 1
;===============================================================
;
; C O D E   S E G M E N T   D E F I N I T I O N
;
	.CODE
	;ASSUME DS:NOTHING,ES:DGROUP
STARTUP:
	MOV		AX,DGROUP		;SET ES TO POINT TO DATA SEG
	MOV		ES,AX
	MOV		DS,AX
	
	LEA		DI,HEADER
	MOV		CX,29
	CALL	PUTSTRNG

	MOV		AX,0
	CALL	GETDEC$		;GET USER INPUT
	MOV		INPUT,AX
	CALL	NEWLINE
	
	CALL	PARITY		;RAW PARITY NOW IN CX
	
	MOV		PARBITS,CX
	
	MOV		AX,PARBITS
	MOV		DX,0
	MOV		CX,2
	DIV		CX
	
	.IF DX == 1
		MOV	EVENODD,1
	.ELSE
		MOV	EVENODD,0
	.ENDIF
;FALL THROUGH TO REPORT
RESULT:
	LEA		DI,REPORT
	MOV		CX,54
	CALL	PUTSTRNG
	CALL	NEWLINE
	;ORIGINAL      BINARY     PARITY #     PARITY
	LEA		DI,SPACES
	MOV		CX,2
	CALL	PUTSTRNG 	;ALIGN W/ HEADER
	
	MOV		AX,INPUT
	MOV		BH,1		;RIGHT-JUSTIFY
	CALL	PUTDEC$
	
	MOV		CX,6		;SPACES
	CALL	PUTSTRNG
	
	MOV		BL,1		;16 BIT BINARY
	CALL	PUTBIN
	
	INC		CX			;NEED 1 MORE SPACE
	CALL	PUTSTRNG
	
	MOV		AX,PARBITS	;NUMBER OF SET BITS [PARITY]
	CALL	PUTDEC$
	
	CALL	PUTSTRNG
	
	.IF EVENODD == 1	;LOAD EVEN / ODD MESSAGE
		LEA DI,ODMSG
	.ELSE
		LEA	DI,EVMSG
	.ENDIF
	
	MOV		CX,4
	CALL	PUTSTRNG
	
DONE:
	CALL	NEWLINE
	CALL	NEWLINE
	LEA		DI,NAME_IR
	MOV		CX,30
	CALL	PUTSTRNG
	CALL	NEWLINE
	LEA		DI,PAUMSG
	CALL PAUSE

	.EXIT
END STARTUP