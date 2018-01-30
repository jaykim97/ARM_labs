/*
-------------------------------------------------------
timer2.s
A simple count down program to light up left and right LEDs
-------------------------------------------------------
Author:  Colin Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-25
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11	@ Terminate program
.equ SWI_Timer, 0x6d	@ Assign current timer to R0
.equ SWI_SetLED, 0x201  @ Assign value in R0 to LEDs
.equ LEFT_LED, 0x02 @ Turns on left LED
.equ RIGHT_LED, 0x01 @ Turns on right LED
.equ BOTH_LED, LEFT_LED|RIGHT_LED   @ Turns on both LEDs

	MOV	R3, #10		@ Set Loop Counter
	
TOP:
	MOV	R0, R3			@ Copy loop counter to LEDs
	SWI	SWI_SetLED		@ Show the LEDs
	SWI	SWI_Timer		@ Put current time in R0
	ADD	R2, R0, #250	@ Add delay time to current time (ms)
	
LEFTDELAY:	@first half of the delay time, light up left LED
	MOV R0, #LEFT_LED	@ prepare left led
    SWI SWI_SetLED		@ light up led
	SWI	SWI_Timer		@ Get the next tick (ms)
	CMP	R0, R2			@ Is the current time less than the final time?
	BLT	LEFTDELAY		@ Yes - continue delay loop

	SWI SWI_Timer
	ADD R2,R0, #250

RIGHTDELAY: @second half of the delay time, light up right LED
	MOV R0, #RIGHT_LED @ prepare right led
    SWI SWI_SetLED	   @ light up led
	SWI	SWI_Timer	@ Get the next tick (ms)
	CMP	R0, R2		@ Is the current time less than the final time?
	BLT	RIGHTDELAY		@ Yes - continue delay loop
	
	
	SUB	R3, R3, #1	@ Decrement the loop counter by 1
	CMP	R3, #0
	BGT	TOP
	
	MOV R0, #BOTH_LED	@ prepare both LEDs 
	SWI SWI_SetLED		@ light up both LEDs before exiting
	
	SWI	SWI_Exit