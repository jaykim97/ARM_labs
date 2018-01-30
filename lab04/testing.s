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
	MOV R1, #0x27
	MOV R0, #0x10
ASC:
	SUB	R1,R1,R0
	CMP R1,#0x10
	ADD R3, R3, #1
	BGT	ASC

	MOV R2,#16
	MUL R0, R3, R2
	MOV R3, #0
TODEC:
	SUB R0, R0, #10
	CMP R0, #10
	ADD R3, R3, #1
	BGT TODEC
	ADD R1, R1, R0
	MOV R0, R3
	
	
	ADD R1,R1, #0x30
	ADD R0,R0, #0x30
	
	MOV R0, R0, lsl#8
	ADD R0,R0,R1
	




	
	
	SWI	SWI_Exit	@ Terminate the program
