/*
-------------------------------------------------------
sub_task.s
Complete the given subroutines.
-------------------------------------------------------
Author:  Jikyung Kim
ID:      150773520
Email:   kimx3520@mylaurier.ca
Date:    2018-02-10
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11	@ Assign a label to the terminate program code
.equ SWI_Open, 0x66	@ Open a file - R0: address of file name, R1: mode 
.equ SWI_Close, 0x68	@ Close a file
.equ SWI_RdInt, 0x6c	@ Read integer from a file
.equ SWI_PrInt, 0x6b	@ Write integer to a file
.equ SWI_RdStr, 0x6a	@ Read string from a file
.equ SWI_PrStr, 0x69	@ Print string to a file
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ inputMode, 0	@ Set file mode to input
.equ outputMode, 1	@ Set file mode to output
.equ appendMode, 2	@ Set file mode to append
.equ stdout, 1		@ Set output target to be Stdout

.text
	LDR	R2, =_Data1	@ Store address of end of list
	LDR	R3, =Data1	@ Store address of start of list
	BL	PrintList
	BL	PrintCR
	
	BL	SumList
	MOV	R4, R0	@ Store sum
	
	@ Print sum
	MOV	R0, #stdout
	LDR	R1, =SumMsg
	SWI	SWI_PrStr
	MOV	R1, R4
	SWI	SWI_PrInt
	BL	PrintCR	
	
	@ Add two lists into a third
	LDR	R4, =_Data2
	LDR	R5, =Data2
	LDR	R7, =Data3
	BL	AddLists
	
	@ Print contents of third list
	LDR	R2, =_Data3
	LDR	R3, =Data3
	BL PrintList

	SWI	SWI_Exit

PrintCR:
    /*
    -------------------------------------------------------
    Prints the end-of-line character (\n)
    -------------------------------------------------------
	Uses:
	R0	- set to '\n'
	(SWI_PrChr automatically prints to stdout)
    -------------------------------------------------------
    */
	STMFD	SP!, {R0, LR}
	MOV	R0, #'\n'	@ Set output file handle to stdout
	SWI	SWI_PrChr	@ Print the character to Stdout
	LDMFD   SP!, {R0, PC}
	
PrintList:	
    /*
    -------------------------------------------------------
    Prints all integers in a list to stdout - prints each number
	on a new line.
    -------------------------------------------------------
	Uses: 
	R0: stdout command
	R1: current value of the list
	R2: end of list address
	R3: current address of the list 
    -------------------------------------------------------
    */
	STMFD	SP!, {R2,R3,LR}
	MOV R0, #stdout
	loop1:
	LDR R1, [R3], #4	@ Load current value of the list to R1 post increment
	SWI SWI_PrInt		@ Print value in R1 to out
	BL PrintCR			@ Branch to PrintCR
	CMP R2,R3			@ Compare current address in R3 to end of the list R2
	BNE loop1			@ If not end of the list go back to top of the loop

	LDMFD   SP!, {R2,R3,PC}
		
SumList:	
    /*
    -------------------------------------------------------
    Sums all integers in a list.
    -------------------------------------------------------
	Uses:
	R0: current sum
	R1: current value of the list
	R2: end of list address
	R3: current address of the list
    -------------------------------------------------------
    */
	STMFD	SP!, {R2,R3,LR}
	MOV R0,#0 @initialize sum
	sumLoop:	
	LDR R1, [R3], #4	@ Load current value of the list to R1 post increment
	ADD R0, R0, R1		@ Add current value in R1 to current sum R0
	CMP R2,R3			@ Compare current address in R3 to end of the list R2
	BNE sumLoop			@ If not end of the list go back to top of the loop
	
	LDMFD	SP!, {R2,R3,PC}

AddLists:	
    /*
    -------------------------------------------------------
    Sums integers 1 by 1 in two lists and stores results in third list.
    -------------------------------------------------------
	Uses:
	R0: current value of data1
	R1: current value of data2
	R2: end of list data1 address
	R3: current address of list data1
	R4: end of list data2 address
	R5: current address of list data2
	R6: sum of two list
	R7: current address of list data3
    -------------------------------------------------------
    */
	STMFD	SP!, {R2-R5,R7,LR}
	addlistLoop:
	LDR R0, [R3], #4	@ Load current value of the list data1 to R0 post increment
	LDR R1, [R5], #4	@ Load current value of the list data2 to R1 post increment
	ADD R6, R1, R0		@ Add current values in R1 and R0
	STR R6,[R7],#4		@ Store sum of R1 and R0 in R6 to list data3 post increment
	CMP R2, R3			@ Compare current address in R3 to end of the list R2
	BNE addlistLoop		@ If not end of the list go back to top of the loop
	LDMFD	SP!, {R2-R5,R7,PC}

.data
	SumMsg:	.asciz	"Sum: "
	Data1:	.word	4,5,-9,0,3,0,8,-7,0	@ A list of data
	_Data1:	@ End of list address
	Data2:	.word	12,9,-9,5,3,10,8,-7,11	@ A list of data
	_Data2:	@ End of list address
	Data3: .space	(_Data1 - Data1) @ Size based upon first list (bytes)
	_Data3: @ End of list address
.end