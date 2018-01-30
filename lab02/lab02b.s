/*
-------------------------------------------------------
lab02b.s
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
	LDR	R3, =First
	LDR	R0, [R3]
	LDR	R3, =Second
	LDR	R1, [R3]
@ Perform arithmetic and store results in memory
	ADD	R2, R0, R1
	LDR	R3, =Total
	STR	R2, [R3]
	SUB	R2, R0, R1	@ Subtract Second from First
	LDR	R3, =Diff
	STR	R2, [R3]
	
	SWI	SWI_Exit

.data	@ Define the data section

First:	.word	4
Second:	.word	8

Total:	.space 4	@ Set aside 4 bytes for total
Diff:	.space 4	@ Set aside 4 bytes for difference