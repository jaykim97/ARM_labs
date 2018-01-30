/*
-------------------------------------------------------
io_demo.s
A simple file input/output demo program.
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

@ Open a file for reading
	LDR	R0, =FILE	@ Load address of file name
	MOV	R1, #inputMode	@ Set file mode to input
	SWI	SWI_Open	@ Open the file - sets Carry on error

@ Check that file opened
	BCS	Error		@ Branch Carry Set - if error opening file, branch to error message
	
	MOV	R3, R0		@ Save the file handle to R3
	SWI	SWI_RdInt	@ Read first integer from the input file into R0
	LDR R4, =TOTAL	@ Load memory location of TOTAL to register R4

@ Read all integers from a file
TOP:
	MOV	R1, R0		@ Copy integer to output register R1
	STR R1, [R4]	@ Store value in register R1 to total 
	ADD R4, R4, #4
	MOV	R0, #stdout	@ Set output file handle to stdout
	SWI	SWI_PrInt	@ Print the integer to the Output View
	
	LDR	R1, =CR	@ Get the address of the end-of-line string
	SWI	SWI_PrStr	@ Print the string to Stdout (file handle already set)
	
	MOV	R0, R3		@ Move the input file handle to R0
	SWI	SWI_RdInt	@ Read the next integer from the input file into R0
	ADD R6, R6 , #1	@ Count number of integers in the file
	BCC	TOP			@ Branch Carry Clear - if there was no read error (EOF), loop
	
@ Get Sum of the numbers
	LDR R0, =TOTAL	@ Load memory location of TOTAL to register R4
	MOV R3, R6		@ Initialize the loop counter
	
	
	
SUM:
	LDR R1, [R0]	@ Load Number in total to R5
	ADD R2, R2, R1	@ Add current value with the current total
	ADD R0, R0, #4	@ Move to next integer
	SUB R3, R3, #1	@ Decrement the loop counter
	CMP R3, #0		@ Compare current loop counter with 0
	BGT SUM			@ If current counter is greater than 0 loop back to sum

	
@convert total into ascii values 
	MOV R1, R2		@ Move total to register R1
	MOV R0, #0x10	@ Load register R0 with hex 10
ASC:
	SUB	R1,R1,R0	@ Sub register R1 with value register R0
	ADD R3, R3, #1	@ Add 1 to register R3 reference point to decimal 10s digit
	CMP R1,#0x10	@ Compare value in R1 with hex 10
	BGT	ASC			@ If R1 is greater than hex 10 loop back to ASC

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
	
	MOV R1, R1, lsl#8
	ADD R1,R1,R0

@ Print the total
	LDR R2, =STRING	@ Load address of sum total string into R1
	STR R1, [R2]	@ Store value in register R2 (sum) to sum total
	LDR R1, =STRING	@ Load address of sum total string into R1
	MOV R0, #stdout	@ Set output file handle to stdout
	SWI SWI_PrStr	@ Print the integer to the Output View
	
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
	TOTAL: .SPACE 24
	STRING: .ascii " "
.end

I can put stuff here with no errors! It's after .end