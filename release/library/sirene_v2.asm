#INCLUDE P16F628A.INC

__CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC

#DEFINE		BANK0	BCF	STATUS,RP0
#DEFINE		BANK1	BSF	STATUS,RP0
#DEFINE		CHAVE1	PORTA,0
#DEFINE		CHAVE2	PORTA,1
#DEFINE		CHAVE3	PORTA,2
#DEFINE		LED1		PORTB,1
#DEFINE		LED2	PORTB,2
#DEFINE		SIRENE	PORTB,3

	FREQ	EQU		20H
	DL0		EQU		21H
	DL1		EQU		22H
	DL2		EQU		23H
	SAVE_W	EQU		24H
	SAVE_S	EQU		25H

	ORG		000H
	GOTO		INICIO

	ORG		004H
	MOVWF	SAVE_W
	SWAPF	STATUS,W
	MOVWF	SAVE_S
	BTFSS	INTCON,T0IF
	GOTO		END_INT
	BCF		INTCON,T0IF
	MOVLW	FREQ
	MOVWF	TMR0
	MOVLW	B'00001000'
	XORWF	PORTB,F
END_INT:
	SWAPF	SAVE_S,W
	MOVWF	STATUS
	SWAPF	SAVE_W,F
	SWAPF	SAVE_W,W
	RETFIE

DELAY:
	MOVLW	.2
	MOVWF	DL2
LOOP_250MS:
	MOVLW	.250
	MOVWF	DL1
LOOP_1MS:
	MOVLW	.200
	MOVWF	DL0
LOOP:
	NOP
	DECFSZ	DL0,F
	GOTO		LOOP
	DECFSZ	DL1,F
	GOTO		LOOP_1MS
	DECFSZ	DL2,F
	GOTO		LOOP_250MS
	RETURN

INICIO:
	CLRF	PORTA
	CLRF	PORTB
	BANK1
	MOVLW	B'00000111'
	MOVWF	TRISA
	MOVLW	B'00000000'
	MOVWF	TRISB
	MOVLW	B'10000000'
	MOVWF	OPTION_REG
	MOVLW	B'00100000'
	MOVWF	INTCON
	BANK0
	MOVLW	B'00000111'
	MOVWF	CMCON
BGNNG:
	BTFSS	CHAVE2
	GOTO 	BGNNG
;	BSF		INTCON,T0IE
;	BSF		SIRENE
MAIN:
	BSF		LED1
	BCF		LED2
;	MOVLW	.99
;	MOVWF	FREQ
	CALL	DELAY
	BCF		LED1
	BSF		LED2
;	MOVLW	.199
;	MOVWF	FREQ
	CALL	DELAY
	GOTO		MAIN
	END
