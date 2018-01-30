/*
-------------------------------------------------------
count2.s
A simple count down program (BGT)
-------------------------------------------------------
Author:  Colin Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-25
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Terminate program

@ Store data in registers
	LDR R3, =val		@ Initialize a countdown value
	LDR R3, [R3]
TOP:
	SUB	R3, R3, #1	@ Decrement the countdown value
	CMP	R3, #0		@ Compare the countdown value to 0
	BGE	TOP	@ Branch to TOP if > 0
	
	SWI	SWI_Exit
.data
	
val:	.word	5