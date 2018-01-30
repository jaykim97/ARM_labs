/*
-------------------------------------------------------
count1.s
A simple count down program (BGT)
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
Date:    2018-01-25
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Terminate program

@ Store data in registers
	MOV	R3, #5		@ Initialize a countdown value
	
TOP:
	SUB	R3, R3, #1	@ Decrement the countdown value
	CMP	R3, #0		@ Compare the countdown value to 0
	BGT	TOP	@ Branch to TOP if > 0
	
	SWI	SWI_Exit