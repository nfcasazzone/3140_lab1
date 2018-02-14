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
	MOV R0, #7
	BL fib
	BL MorseDigit
	;BL extracredit uncomment this to test R0 values greater than 6 when using fib
	B forever
MorseDigit	
	push {LR}	
	CMP R0, #0
	BEQ Morse0
	CMP R0, #1
	BEQ Morse1
	CMP R0, #2
	BEQ Morse2
	CMP R0, #3
	BEQ Morse3
	CMP R0, #4
	BEQ Morse4
	CMP R0, #5
	BEQ Morse5
	CMP R0, #6
	BEQ Morse6
	CMP R0, #7
	BEQ Morse7
	CMP R0, #8
	BEQ Morse8
	CMP R0, #9
	BEQ Morse9
Morse0
	BL Morse0loop
	pop {LR}
	BX LR
Morse1
	BL Morse1loop
	pop {LR}
	BX LR
Morse2
	BL Morse2loop
	pop {LR}
	BX LR
Morse3
	BL Morse3loop
	pop {LR}
	BX LR
Morse4
	BL Morse4loop
	pop {LR}
	BX LR
Morse5
	BL Morse5loop
	pop {LR}
	BX LR
Morse6
	BL Morse6loop
	pop {LR}
	BX LR
Morse7
	BL Morse7loop
	pop {LR}
	BX LR
Morse8
	BL Morse8loop
	pop {LR}
	BX LR
Morse9
	BL Morse9loop
	pop {LR}
	BX LR
Morse0loop
	push {LR}
	BL dash
	BL dash
	BL dash
	BL dash
	BL dash
	pop {LR}
	BX LR
Morse1loop
	push {LR}
	BL dot
	BL dash
	BL dash
	BL dash
	BL dash
	pop {LR}
	BX LR
Morse2loop
	push {LR}
	BL dot
	BL dot
	BL dash
	BL dash
	BL dash
	pop {LR}
	BX LR
Morse3loop
	push {LR}
	BL dot
	BL dot
	BL dot
	BL dash
	BL dash
	pop {LR}
	BX LR
Morse4loop
	push {LR}
	BL dot
	BL dot
	BL dot
	BL dot
	BL dash
	pop {LR}
	BX LR
Morse5loop
	push {LR}
	BL dot
	BL dot
	BL dot
	BL dot
	BL dot
	pop {LR}
	BX LR
Morse6loop
	push {LR}
	BL dash
	BL dot
	BL dot
	BL dot
	BL dot
	BL dot
	pop {LR}
	BX LR
Morse7loop
	push {LR}
	BL dash
	BL dash
	BL dot
	BL dot
	BL dot
	pop {LR}
	BX LR
Morse8loop
	push {LR}
	BL dash
	BL dash
	BL dash
	BL dot
	BL dot
	pop {LR}
	BX LR
Morse9loop
	push {LR}
	BL dash
	BL dash
	BL dash
	BL dash
	BL dot
	pop {LR}
	BX LR
dot
	push {LR}
	BL delay
	BL LEDON
	BL delay
	BL LEDOFF
	pop {LR}
	BX LR

dash
	push {LR}
	BL delay
	BL LEDON
	BL delay
	BL delay
	BL delay
	BL LEDOFF
	pop {LR}
	BX LR
delay
	push {R4}
	LDR R4, =3000000
delayloop
	SUBS R4, #1
	BNE delayloop
	pop {R4}
	BX LR
fib		
	;CMP R0, #0
	;BEQ basezero
	;BMI basezero
	CMP R0, #1
	BMI basezero
	BEQ baseone
	push {R4,R5, LR}
	MOV R4, R0
	SUB R0, R4, #1
	BL fib
	MOV R5, R0
	SUB R0, R4, #2
	BL fib 
	ADD R5, R5, R0
	MOV R0, R5
	pop {R4, R5,LR}
	BX LR
basezero
	MOV R0, #0
	BX LR
baseone
    MOV R0, #1
	BX LR
extracredit
	push {R6, R7, R8, LR}
	MOV R6, R0
	MOV R7, #0
	MOV R8, #10
MorseDigitStackSetup ;R0 is the input
	MOV R6, R0
	UDIV R6, R6, R8
	MUL R6, R6, R8
	SUB R6, R0, R6
	push {R6}
	ADD R7, #1
	UDIV R0, R0, R8
	CMP R0, #0
	BNE MorseDigitStackSetup
StackLoop
	pop {R0}
	BL MorseDigit
	BL delay
	BL delay
	BL delay
	SUB R7, #1
	CMP R7, #0
	BNE StackLoop
	pop {R6, R7, R8, LR}
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