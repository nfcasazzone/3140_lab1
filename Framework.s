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
	
	MOV R0, #0	; Change R0 to 0 to test MorseDigit(0)
	BL MorseDigit	; Call MorseDigit(0)
	
	MOV R0, #1	; Change R0 to 1 to test MorseDigit(1)
	BL MorseDigit	; Call MorseDigit(1)
	
	MOV R0, #2	; Change R0 to 2 to test MorseDigit(2)
	BL MorseDigit	; Call MorseDigit(2)
	
	MOV R0, #3	; Change R0 to 3 to test MorseDigit(3)
	BL MorseDigit	; Call MorseDigit(3)
	
	MOV R0, #4	; Change R0 to 4 to test MorseDigit(4)
	BL MorseDigit	; Call MorseDigit(4)
	
	MOV R0, #5	; Change R0 to 5 to test MorseDigit(5)
	BL MorseDigit	; Call MorseDigit(5)
	
	MOV R0, #6	; Change R0 to 6 to test MorseDigit(6)
	BL MorseDigit	; Call MorseDigit(6)
	
	MOV R0, #7	; Change R0 to 7 to test MorseDigit(7)
	BL MorseDigit	; Call MorseDigit(7)
	
	MOV R0, #8	; Change R0 to 8 to test MorseDigit(8)
	BL MorseDigit	; Call MorseDigit(8)
	
	MOV R0, #9	; Change R0 to 9 to test MorseDigit(9)
	BL MorseDigit	; Call MorseDigit(9)
	
	B forever		; Keep LEDs off when done
;The MorseDigit function takes in an input in R0 and flashes the appropriate dots and dashes onto the LED
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
;All these loops branch to a combination of dash or dot 5 times and then branch to MorseFinish, the end. 
Morse0	;0 digit loop to call the dashes needed
	BL dash		;Branch to delay loop for a dash
	BL dash
	BL dash
	BL dash
	BL dash
	B MorseFinish ;Branch to the finish
Morse1	;1 single digit loop to call the dots/dashes needed
	BL dot ;Branch to delay loop for a dash
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
	pop {LR} ;pop LR so the function can return to main
	BX LR    ;end the function and branch back to main
	
dot				;Delay loop for a dot
	push {LR}	;Save previous LR before call
	BL delay	;Branch to timing delay loop to signal a space (LED off)
	BL LEDON
	BL delay	;Branch to timing delay loop to signal a dot (LED on)
	BL LEDOFF	;turn off the LED
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
	BMI basezero ;if R0<=0, branch to base zero case
	BEQ baseone ; if R0=1, branch to base 1 case
	push {R4, R5, LR} ;else case: save R4, R5, and LR before next function call
	MOV R4, R0 ;save original value of n
	SUB R0, R4, #1 
	BL fib  ;call fib(n-1)
	MOV R5, R0 ;save result of fib(n-1) into R5
	SUB R0, R4, #2
	BL fib  ;call fib(n-2_
	ADD R5, R5, R0 ;add result of fib(n-2) to R5
	MOV R0, R5 ;R0 holds fib(n-1)+fib(n-2)
	pop {R4,R5, LR} ;pop R4, R5, and LR to safely return to address before fib call
	BX LR
basezero ;returns zero
	MOV R0, #0
	BX LR
baseone ;returns one
    MOV R0, #1
	BX LR
	
extracredit ;R0 is the input, this function handles splitting multi-digit numbers and pushing onto the stack for MorseDigit
	push {R6, R7, R8, LR} ;saves the values of the registers that will be used
	MOV R7, #0 ;R7 will hold the number of digits of R0
	MOV R8, #10
MorseDigitStackSetup ;this part essentially performs mod 10 on R0 contiously until R0=0 and pushes the result each time onto the stack. 
	MOV R6, R0 ;moves R0 to R6 to perform calculations
	UDIV R6, R6, R8  ;performs unsigned integer division of R6 by 10
	MUL R6, R6, R8   ;multiplies R6 by 10
	SUB R6, R0, R6   ;R6 now holds R0 mod 10.
	push {R6} ;push this result onto the stack
	ADD R7, #1 
	UDIV R0, R0, R8 ;R0 is divided by 10 before looping again as long as R0 !=0
	CMP R0, #0
	BNE MorseDigitStackSetup
StackLoop
	pop {R0} ;this pops the most significant digit of the original input R0 of extracredit(n) to R0
	BL MorseDigit ;MorseDigit is called on this value of R0
	BL delay ;there is a 3 dot delay before the next digit is dislpayed
	BL delay
	BL delay
	SUB R7, #1 ;checks if there are more digits to display
	CMP R7, #0
	BNE StackLoop
	pop {R6, R7, R8, LR} ;restores the original values of the registers used in this function
	BX LR ;branches back to LR
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
