/*
-------------------------------------------------------
segment_task.s
Subroutines for working with the 8-Segment Display.
-------------------------------------------------------
Author:  Jikyung Kim
ID:      150733520
Email:   kimx3520@mylaurier.ca
Date:    2018-02-21
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11	@ Assign a label to the terminate program code
.equ SWI_Open, 0x66	@ Open a file - R0: address of file name, R1: mode 
.equ SWI_Close, 0x68	@ Close a file
.equ SWI_RdInt, 0x6c	@ Read integer from a file
.equ SWI_PrInt, 0x6b	@ Write integer to a file
.equ SWI_RdStr, 0x6a	@ Read string from a file
.equ SWI_PrStr, 0x69	@ Print string to a file
.equ SWI_SetSeg8, 0x200 @ Write to 8-segment display
.equ SWI_Timer, 0x6d    @ Assign current timer to R0

.equ inputMode, 0	@ Set file mode to input
.equ outputMode, 1	@ Set file mode to output
.equ appendMode, 2	@ Set file mode to append
.equ stdout, 1		@ Set output target to be Stdout
	
@ patterns for 8 segment display
@ byte values for each segment of the display
.equ SEG_A, 0x80 
.equ SEG_B, 0x40 
.equ SEG_C, 0x20 
.equ SEG_D, 0x08
.equ SEG_E, 0x04
.equ SEG_F, 0x02
.equ SEG_G, 0x01
.equ SEG_P, 0x10

.equ PAUSE, 500

@ Display all of the 8-segment display segments
	MOV	R1, #SEG_A
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_B
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_C
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_D
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_E
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_F
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_G
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	MOV	R1, #SEG_P
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay

@ Display three ORed segments
	MOV	R1, #SEG_A | SEG_F | SEG_D
	BL	Print_8_Segments
	MOV	R1, #PAUSE
	BL	Delay
	
@ Display the digits from 0 to 9 using a loop

	@ your code here
	LDR R2, =Digits @ Get address of start of table
	LDR R3, =_Digits @ Store address of end of the digits
	SUB R4, R3, R2	@ Store End
	MOV R1, #0 @ Initialize loop counter
PRINTLOOP:
	BL Print_8_Digit
	MOV R0,R1
	MOV R1, #PAUSE
	BL Delay
	MOV R1, R0
	ADD R1, R1, #1
	CMP R1, R4
	BNE PRINTLOOP
	
	
	SWI	SWI_Exit

Print_8_Segments:
	/*
	-------------------------------------------------------
	Displays segments in the 8-segment display.
	-------------------------------------------------------
	Uses:
	R0 - segments to display in 8-segment display (used by SWI_SetSeg8)
	R1 - segments parameter
	-------------------------------------------------------
	*/
	STMFD	SP!, {R0-R1, LR}

	MOV R0, R1      @ Copy parameter to 8 segment display
	SWI SWI_SetSeg8 @ Show the 8-segment display

	LDMFD   SP!, {R0-R1, PC}
		
Print_8_Digit:
    /*
    -------------------------------------------------------
    Prints a digit on the 8-segment display. R1 is treated as a
	byte-sized offset to the digit to be displayed in Digits.
    -------------------------------------------------------
	Uses:
	R1 - digit parameter
	R2 - address of digits
    -------------------------------------------------------
    */
	STMFD	SP!, {R0-R2, LR}
	LDRB R0,[R2,R1]
	SWI SWI_SetSeg8
	
	LDMFD   SP!, {R0-R2, PC}
		
Delay:
    /*
    -------------------------------------------------------
    Delays execution for a given number of ms.
    -------------------------------------------------------
	Uses:
	R1 - Delay time parameter
	R2 - Delay counter
    -------------------------------------------------------
    */
	STMFD	SP!, {R0-R2, LR}

	@ your code here
	SWI SWI_Timer	@ Put current time in R0
	ADD R2, R0, R1	@ Add delay time to current time (ms)
	
DelayLoop:
	SWI SWI_Timer	@ Get the next tick (ms) in R0
	CMP R0, R2	@ Is the current time less than the final time
	BLT DelayLoop
	
	LDMFD   SP!, {R0-R2, PC}
	
.data
Digits:
.byte SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
.byte SEG_B|SEG_C @1
.byte SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
.byte SEG_A|SEG_B|SEG_C|SEG_D|SEG_F@3
.byte SEG_B|SEG_C|SEG_F|SEG_G @4
.byte SEG_A|SEG_C|SEG_D|SEG_F|SEG_G @5
.byte SEG_A|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @6
.byte SEG_A|SEG_B|SEG_C @7
.byte SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G@8
.byte SEG_A|SEG_B|SEG_C|SEG_D|SEG_F|SEG_G @9
_Digits: @end of digits
.end