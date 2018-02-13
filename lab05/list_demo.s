/*
-------------------------------------------------------
list_demo.s
A simple list demo program. Prints all elements of an integer list.
-------------------------------------------------------
Author:  Colin Jikyung Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-29
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11	@ Assign a label to the terminate program code
.equ SWI_Open, 0x66	@ Open a file - R0: address of file name, R1: mode 
.equ SWI_Close, 0x68	@ Close a file
.equ SWI_RdInt, 0x6c	@ Read integer from a file
.equ SWI_PrInt, 0x6b	@ Write integer to a file
.equ SWI_RdStr, 0x6a	@ Read string from a file
.equ SWI_PrStr, 0x69	@ Print string to a file
.equ inputMode, 0	@ Set file mode to input
.equ outputMode, 1	@ Set file mode to output
.equ appendMode, 2	@ Set file mode to append
.equ stdout, 1		@ Set output target to be Stdout

.text
	LDR	R2, =_Data	@ Store address of end of list
	LDR	R3, =Data	@ Store address of start of list
	MOV	R0, #stdout
	
	@ Display number of bytes in the list
	LDR	R1, =BytesMsg	@ Print title	
	SWI	SWI_PrStr
	SUB	R1, R2, R3	@ Determine number of bytes in list by address difference
	SWI	SWI_PrInt
	LDR	R1, =CR	@ Print carriage return	
	SWI	SWI_PrStr

Top1:
	LDR	R1, [R3], #4	@ Read address with post-increment (R1 = *R3, R3 += 4)

	SWI	SWI_PrInt	@ Print integer to stdout
	LDR	R1, =CR	@ Print carriage return	
	SWI	SWI_PrStr
	
	CMP	R2, R3	@ Compare current address with end of list
	BNE	Top1	@ If not at end, continue
	
	SWI	SWI_Exit

.data
	BytesMsg:	.asciz	"Bytes in list: "
	CR:	.asciz	"\n"
	Data:	.word	4,5,-9,0,3,0,8,-7,0	@ The list of data
	_Data:	@ End of list address
.end