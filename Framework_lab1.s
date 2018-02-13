				AREA Myprog, CODE, READONLY
		ENTRY
		EXPORT __main
			
;don't change these addresses!
PCR22 	  EQU 0x4004A058 ;PORTB_PCR22  address
SCGC5 	  EQU 0x40048038 ;SIM_SCGC5    address
PDDR 	  EQU 0x400FF054 ;GPIOB_PDDR   address
PCOR 	  EQU 0x400FF048 ;GPIOB_PCOR   address
PSOR      EQU 0x400FF044 ;GPIOB_PSOR   address

ten		  EQU 0x00000400 ; 1 << 10
eight     EQU 0x00000100 ; 1 << 8
twentytwo EQU 0x00400000 ; 1 << 22

__main
	; Your code goes here!
		BL  LEDSETUP
		BL LEDOFF	
		MOV R0, #2 ;n
		MOV R5, R0
		MOV R0, #0
		BL fib
		B Morsedigit
Morsedigit
		MOV R2, #3 ;dot delay time
		CMP  R0, #6
		BPL dash
		CMP R0, #0
		BEQ dash
		;r0 holds number of dots
		RSB R1, R0, #5 ;r1 holds the number of dashes
dot	
		BL dotstart
		CMP R1, #0
		BEQ forever
		BL dashestart
		B forever
dash
		BL dashestart
		CMP R0, #0
		BEQ forever
		BL dotstart
		B forever
		
dotstart ;push LR onto stack so we can return back to dot
		push {LR}
		
dotsoff ;turn off LED for required time
		BL delay
		BL LEDON
dotsloop ;turn on LED for required time
		BL delay
		SUB R0, #1
		CMP R0, #0
		BL LEDOFF
		BNE dotsoff
		pop {LR}
		BX LR
		
dashestart ;same as dots but for dashes
		push {LR}
		SUB R1, R0, #5
		RSB R0, R1, #5
		MOVEQ R1, #5
		MOVEQ R0, #0
dashesoff
		BL delay
		BL LEDON
dashesloop
		MOV R2, #9
		BL delay
		SUB R1, #1
		CMP R1, #0
		BL LEDOFF
		BNE dashesoff
		pop {LR}
		BX LR
		
delay ;loop for LED off time
		SUBS R2, #1
		BNE delay
		MOV R2, #3
		BX LR


fib		
		push {LR}
fib2
		CMP R5, #0
		MOVEQ PC, LR
		CMP R5, #1
		ADDEQ R0, #1
		MOVEQ PC, LR
		BL minus1
		BL minus2
		pop {LR}
		BX LR
		; Your code goes here!
minus1
		push {R5, LR}
		SUB R5, #1
		BL fib2
		pop {LR, R5}
		BX LR
minus2
		push {R5, LR}
		SUB R5, #2
		BL fib2
		pop {LR, R5}
		BX LR
	; Call this function first to set up the LED
LEDSETUP
				PUSH  {R4, R5} ; To preserve R4 and R5
				LDR   R4, =ten ; Load the value 1 << 10
				LDR		R5, =SCGC5
				STR		R4, [R5]
				
				LDR   R4, =eight
				LDR   R5, =PCR22
				STR   R4, [R5]
				
				LDR   R4, =twentytwo
				LDR   R5, =PDDR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR

; The functions below are for you to use freely      
LEDON				
				PUSH  {R4, R5}
				LDR   R4, =twentytwo
				LDR   R5, =PCOR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR
LEDOFF				
				PUSH  {R4, R5}
				LDR   R4, =twentytwo
				LDR   R5, =PSOR
				STR   R4, [R5]
				POP   {R4, R5}
				BX    LR
				
forever
			B		forever						; wait here forever	
			END
 				