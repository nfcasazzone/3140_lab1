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
	BL  LEDSETUP	; Set up LED
	BL LEDOFF		; Turn of LED
	MOV R0, #6	; Change IMM to perform Morse/Fib on it
	BL fib			; Call Fibonacci function
	BL MorseDigit	; Call MorseCode function
	;BL extracredit ;uncomment this to test R0 values greater than 6 when using fib
	B forever		; Keep LEDs off when done
MorseDigit	
	push {LR}		; Save LR before function call
	CMP R0, #0		; Check if n is 0 and branch to the respective loop
	BEQ Morse0
	CMP R0, #1		; Check for 1
	BEQ Morse1
	CMP R0, #2		; Check for 2
	BEQ Morse2
	CMP R0, #3	    ; Check for 3
	BEQ Morse3
	CMP R0, #4	    ; Check for 4
	BEQ Morse4
	CMP R0, #5	    ; Check for 5
	BEQ Morse5
	CMP R0, #6	    ; Check for 6
	BEQ Morse6
	CMP R0, #7	    ; Check for 7
	BEQ Morse7
	CMP R0, #8	    ; Check for 8
	BEQ Morse8
	CMP R0, #9	    ; Check for 9
	BEQ Morse9

Morse0	;0 digit loop to call the dashes needed
	;Save LR before the call
	BL dash		;Branch to delay loop for a dash
	BL dash
	BL dash
	BL dash
	BL dash
	B MorseFinish
Morse1	;1 single digit loop to call the dots/dashes needed
	BL dot
	BL dash
	BL dash
	BL dash
	BL dash
	B MorseFinish
Morse2	;2 single digit loop to call the dots/dashes needed
	BL dot
	BL dot
	BL dash
	BL dash
	BL dash
	B MorseFinish
Morse3		;3 single digit loop to call the dots/dashes needed
	BL dot
	BL dot
	BL dot
	BL dash
	BL dash
	B MorseFinish
Morse4		;4 single digit loop to call the dots/dashes needed
	BL dot
	BL dot
	BL dot
	BL dot
	BL dash
	B MorseFinish
Morse5		;5 single digit loop to call the dots/dashes needed
	BL dot
	BL dot
	BL dot
	BL dot
	BL dot
	B MorseFinish
Morse6		;6 single digit loop to call the dots/dashes needed
	BL dash
	BL dot
	BL dot
	BL dot
	BL dot
	BL dot
	B MorseFinish
Morse7		;7 single digit loop to call the dots/dashes needed
	BL dash
	BL dash
	BL dot
	BL dot
	BL dot
	B MorseFinish
Morse8		;8 single digit loop to call the dots/dashes needed
	BL dash
	BL dash
	BL dash
	BL dot
	BL dot
	B MorseFinish
Morse9		;9 single digit loop to call the dots/dashes needed
	BL dash
	BL dash
	BL dash
	BL dash
	BL dot
	B MorseFinish
MorseFinish
	pop {LR}
	BX LR
dot				;Delay loop for a dot
	push {LR}	;Save previous LR before call
	BL delay	;Branch to timing delay loop to signal a space (LED off)
	BL LEDON
	BL delay	;Branch to timing delay loop to signal a dot (LED on)
	BL LEDOFF
	pop {LR}	;Remove previous LR from stack
	BX LR		;Return to previously saved LR before function call

dash			;Delay loop for a dash
	push {LR}	;Save previous LR before call
	BL delay	;Branch to timing delay loop to signal a space (LED off)
	BL LEDON
	BL delay	;Branch to timing delay loop to signal a dot (LED on)
	BL delay
	BL delay	;Dash is 3x the length of a dot
	BL LEDOFF
	pop {LR}	;Remove previous LR from stack
	BX LR		;Return to previously saved LR before function call
delay			;Branch that sets delay time
	push {R4}	;Save previous R4 reg before call
	LDR R4, =3000000	;Load delay time
delayloop		;Branch that counts down from delay time to delay
	SUBS R4, #1	;
	BNE delayloop
	pop {R4}
	BX LR
fib				;Fibonacci function branch that returns the fib(R0)
	CMP R0, #1	;Compare R0 to 1 to see if branching to base case is needed
	BMI basezero 
	BEQ baseone
	push {R4, R5, LR}
	MOV R4, R0
	SUB R0, R4, #1
	BL fib
	MOV R5, R0
	SUB R0, R4, #2
	BL fib 
	ADD R5, R5, R0
	MOV R0, R5
	pop {R4,R5, LR}
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
