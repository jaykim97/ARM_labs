/*
-------------------------------------------------------
io_demo.s
A simple file input/output demo program.
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
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

@ Open a file for reading
	LDR	R0, =FILE	@ Load address of file name
	MOV	R1, #inputMode	@ Set file mode to input
	SWI	SWI_Open	@ Open the file - sets Carry on error

@ Check that file opened
	BCS	Error		@ Branch Carry Set - if error opening file, branch to error message
	
	MOV	R3, R0		@ Save the file handle to R3
	SWI	SWI_RdInt	@ Read first integer from the input file into R0

@ Read all integers from a file
TOP:
	MOV	R1, R0		@ Copy integer to output register R1
	MOV	R0, #stdout	@ Set output file handle to stdout
	SWI	SWI_PrInt	@ Print the integer to the Output View
	
	LDR	R1, =CR	@ Get the address of the end-of-line string
	SWI	SWI_PrStr	@ Print the string to Stdout (file handle already set)
	
	MOV	R0, R3		@ Move the input file handle to R0
	SWI	SWI_RdInt	@ Read the next integer from the input file into R0
	BCC	TOP			@ Branch Carry Clear - if there was no read error (EOF), loop
	
@ Close the input file	
	MOV	R0, R3		@ Move the input file handle to R0
	SWI	SWI_Close	@ Close the input file
	BAL	Done		@ Branch ALways - skip over error handling
	
@ Print an error when file open fails
Error:
	LDR	R1, =ERR	@ Load address of error message string into R1
	MOV	R0, #stdout	@ Set output file handle to stdout
	SWI SWI_PrStr	@ Print the string
	LDR	R1, =FILE	@ Load address of file name into R1
	SWI SWI_PrStr	@ Print the file name

Done:
	SWI	SWI_Exit

.data
	FILE:	.asciz	"numbers.txt"	@ Input file name
	ERR:	.asciz	"Error - could not open file: "	@ Error message string
	CR:	.asciz	"\n"	@ End of line
.end

I can put stuff here with no errors! It's after .end