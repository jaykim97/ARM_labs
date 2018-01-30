/*
-------------------------------------------------------
lab02c.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Jikyung Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-19
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Assign a label to the terminate program code

@ Copy contents of first element of Vec1 to Vec2
	LDR	R0, =Vec1
	LDR	R1, =Vec2
	LDR	R2, [R0]
	STR	R2, [R1]
@ Copy contents of second element of Vec1 to Vec2
	ADD	R0, R0, #4
	ADD	R1, R1, #4
	LDR	R2, [R0]
	STR	R2, [R1]
@ Copy contents of third element of Vec1 to Vec2
	ADD	R0, R0, #4
	ADD	R1, R1, #4
	LDR	R2, [R0]
	STR	R2, [R1]

	SWI	SWI_Exit	@ Terminate the program

.data	@ Define the data section

Vec1:	.word	1, 2, 3

Vec2:	.space	12