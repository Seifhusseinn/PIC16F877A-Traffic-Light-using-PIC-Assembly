
; When assembly code is placed in a psect, it can be manipulated as a
; whole by the linker and placed in memory.  
;
; In this example, barfunc is the program section (psect) name, 'local' means
; that the section will not be combined with other sections even if they have
; the same name.  class=CODE means the barfunc must go in the CODE container.
; PIC18's should have a delta (addressible unit size) of 1 (default) since they
; are byte addressible.  PIC10/12/16's have a delta of 2 since they are word
; addressible.  PIC18's should have a reloc (alignment) flag of 2 for any
; psect which contains executable code.  PIC10/12/16's can use the default
; reloc value of 1.  Use one of the psects below for the device you use:

;psect   barfunc,local,class=CODE,delta=2 ; PIC10/12/16

#include <xc.inc>
    
; CONFIG
    CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator)
    CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
    CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
    CONFIG  BOREN = OFF           ; Brown-out Reset Enable bit (BOR disabled)
    CONFIG  LVP = OFF             ; Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
    CONFIG  CPD = OFF             ; Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
    CONFIG  WRT = OFF             ; Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
    CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)  
 
DCount1 EQU 0X0C
DCount2 EQU 0X0D
DCount3 EQU 0X0E 
 
psect   RESET_VECT,class=CODE,delta=2 ; PIC10/12/16
RESET_VECT:
    goto setup
    
psect   INT_VECT,class=CODE,delta=2 ; PIC10/12/16
INT_VECT:
    BTFSC INTCON,1 ;check if INTF is clear (check if true)
    CALL traffic_light_interrupt
    GOTO main
    retfie
    
setup:
    bsf STATUS,5 ;select bank 1
    CLRF TRISA
    CLRF TRISB
    CLRF TRISC
    CLRF TRISD
    
    BSF PORTB,0
    BCF PORTB,1
    BCF PORTB,2
    BCF PORTB,3
    BCF PORTB,4
    BCF PORTB,5
    
    BCF  OPTION_REG,6
    
    bcf STATUS,5 ;select bank 0
    CLRF PORTA
    ;CLRF PORTB    
    CLRF PORTC
    CLRF PORTD
    
    movlw 0x01
    CLRF PORTA
    CLRF PORTB    
    CLRF PORTC
    CLRF PORTD
    
    BCF  INTCON,1 ;clear flag
    ; 7 -> GIE (Global Interrupt Enable Pin)
    ; 4 -> INTE (RB0 External Interrupt Enable Pin)
    MOVLW (1<<7) | (1<<4) 
    IORWF INTCON
    bcf STATUS,0 ;select bank 0
main:
	 MOVLW   0x02
         MOVWF   PORTA
	 MOVWF   PORTB
	 BSF     PORTB,4
	 CALL	 trafic_light_seg
        
         MOVLW   0x04
         MOVWF   PORTA
	 MOVWF   PORTB
	 BSF     PORTB,4
         CALL    sev_segment_5sec
         
	 MOVLW   0x08
         MOVWF   PORTA
	 MOVWF   PORTB
	 BSF     PORTB,5
	 CALL	 trafic_light_seg
    goto main

;Delay    
DELAY_1sec:
    movlw 0xBD
    movwf DCount1
    movlw 0x4B
    movwf DCount2
    movlw 0x15
    movwf DCount3
LOOP:
    decfsz DCount1, 1
    goto LOOP
    decfsz DCount2, 1
    goto LOOP
    decfsz DCount3, 1
    goto LOOP
    return

;seven segment function
sev_segment_9sec:
    MOVLW 0x6F  ;9
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x7F  ;8
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x07  ;7
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x7D  ;6
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x6D  ;5
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x66  ;4
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x4F  ;3
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x5B  ;2
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x06  ;1
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x3F  ;0
    MOVWF PORTC
    CALL DELAY_1sec
    RETURN
	
sev_segment_5sec:
    MOVLW 0x6D  ;5
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x66  ;4
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x4F  ;3
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x5B  ;2
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x06  ;1
    MOVWF PORTC
    CALL DELAY_1sec
    MOVLW 0x3F  ;0
    MOVWF PORTC
    CALL DELAY_1sec
    RETURN

    ;RETURN
	
sev_segment_3:
	MOVLW 0x4F  ;3
	MOVWF PORTD
	CALL DELAY_1sec
	RETURN

sev_segment_2:	
	MOVLW 0x5B  ;2
	MOVWF PORTD
	CALL DELAY_1sec
	RETURN

sev_segment_1:
	MOVLW 0x06  ;1
	MOVWF PORTD
	CALL DELAY_1sec
	RETURN

sev_segment_0:	
	MOVLW 0x3F  ;0
	MOVWF PORTD
	CALL DELAY_1sec
	RETURN

trafic_light_seg:
	 CALL    sev_segment_3
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 CALL    sev_segment_2
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 CALL    sev_segment_1
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 CALL    sev_segment_0
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 RETURN
	 
traffic_light_interrupt:
	 ;BSF     PORTB,4
	 CALL    sev_segment_1
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 CALL    sev_segment_0
	 CALL	 sev_segment_9sec
	 CALL	 DELAY_1sec
	 
	 MOVLW   0x04
         MOVWF   PORTA
	 MOVWF   PORTB
	 BSF     PORTB,4
         CALL    sev_segment_5sec
         
	 MOVLW   0x08
         MOVWF   PORTA
	 MOVWF   PORTB
	 BSF     PORTB,5
	 CALL	 trafic_light_seg
	 BCF	 INTCON,1  
	 RETURN
	 
    END RESET_VECT