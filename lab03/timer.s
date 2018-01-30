/*
-------------------------------------------------------
timer.s
A simple count down program  with delay.
Triggers 8 segment display.
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
Date:    2018-01-25
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11	@ Terminate program
.equ SWI_Timer, 0x6d	@ Assign current timer to R0
.equ SWI_SetSeg8, 0x200	@ Write to 8 8-segment display

	MOV	R3, #10	@ Initialize the loop counter
	
TOP:
	MOV	R0, R3		@ Copy loop counter to 8-segment display
	SWI	SWI_SetSeg8	@ Show the 8-segment display
	SWI	SWI_Timer	@ Put current time in R0
	ADD	R2, R0, #500	@ Add delay time to current time (ms)
	
DELAY:
	SWI	SWI_Timer	@ Get the next tick (ms)
	CMP	R0, R2		@ Is the current time less than the final time?
	BLT	DELAY		@ Yes - continue delay loop
		
	SUB	R3, R3, #1	@ Decrement the loop counter
	CMP	R3, #0
	BGT	TOP
	
	SWI	SWI_Exit