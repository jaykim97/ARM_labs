/*
-------------------------------------------------------
lab02a.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Jikyung Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-19
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Assign a label to the terminate program code

@ Copy data from memory to registers
	LDR	R3, =A
	LDR	R0, [R3]
	LDR	R3, =B
	LDR	R1, [R3]
	ADD	R2, R1, R0
@ Copy data to memory
	LDR	R3, =Result	@ Assign address of Result to R3
	STR	R2, [R3]	@ Store contents of R2 to address in R3
	
	SWI	SWI_Exit

.data	@ Define the data section

A:	.word	4
B:	.word	8
Result:	.space 4	@ Set aside 4 bytes for result