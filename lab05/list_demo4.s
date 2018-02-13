/*
-------------------------------------------------------
list_demo4.s
A simple list demo program. Prints all elements of an integer list.
-------------------------------------------------------
Author:  Ji kyung Kim
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

@ Load initial Min and Max
	LDR R7, [R3]	@initialize Min	
	MOV R8, R5		@initialize Max	
	MOV R4, #0		@initialize Sum
	MOV R5, #0		@initialize neg
	MOV R6, #0		@initialize pos
	MOV R9, #0		@initialize zero
	
	
Top1:
	LDR	R1, [R3], #4	@ Read address with post-increment (R1 = *R3, R3 += 4)
	ADD R4, R4, R1		@ Add to Total
	CMP R1, R7  @ Compare number to current Minimum
TestNewMin:
	@BGE TestNewMax	@if not new Min test for new Max
	@MOV R7, R1		@ move new min to R5
	MOVGE R7, R1
TestNewMax:
	CMP R1, R8 @compare number to current Maximum
	@BLT NextInList	@if not new Max test next value
	@MOV R8, R1		@ move new max to R6
	MOVLT R8, R1
NextInList:
	CMP R1, #0  @ Compare number to 0
	ADDLT   R5, R5, #1  @ Increment the negative value count if R1 is negative
    ADDGT   R6, R6, #1  @ Increment the positive value count if R1 is positive
    ADDEQ   R9, R9, #1  @ Increment the zero value count if R1 is zero
	SWI	SWI_PrInt	@ Print integer to stdout
	LDR	R1, =CR	@ Print carriage return	
	SWI	SWI_PrStr
	
	CMP	R2, R3	@ Compare current address with end of list
	BNE	Top1	@ If not at end, continue
@output word "Count: "
	LDR R1, =STRING0
	SWI SWI_PrStr
	MOV R1, R4
	SWI SWI_PrInt		@Print total to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	LDR R1, =STRING1	@Load STRING1 "Negative value Count: " to R1
	SWI SWI_PrStr		@Print "Count: " to output view
	MOV R1, R5			@Move count of negative value count to R1
	SWI SWI_PrInt		@Print Negative to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	LDR R1, =STRING2	@Load STRING1 "positive value Count: " to R1
	SWI SWI_PrStr		@Print "Count: " to output view
	MOV R1, R6			@Move count of positive value count to R1
	SWI SWI_PrInt		@Print Positive to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	LDR R1, =STRING3	@Load STRING1 "Zero value Count: " to R1
	SWI SWI_PrStr		@Print "Count: " to output view
	MOV R1, R9			@Move Zerp	of Zero value count to R1
	SWI SWI_PrInt		@Print total to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	LDR R1, =STRING4	@Load STRING1 "Minimum value Count: " to R1
	MOV R0, #stdout		@set output to stdout
	SWI SWI_PrStr		@Print "Count: " to output view
	MOV R1, R7			@Move count of Maximum value count to R1
	SWI SWI_PrInt		@Print total to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	LDR R1, =STRING5	@Load STRING1 "Maximum value Count: " to R1
	SWI SWI_PrStr		@Print "Count: " to output view
	MOV R1, R8			@Move count of positive value count to R1
	SWI SWI_PrInt		@Print Maximum to output view
	LDR R1, =CR	@print carriage return
	SWI SWI_PrStr
	
	
	SWI	SWI_Exit

.data
	BytesMsg:	.asciz	"Bytes in list: "
	CR:	.asciz	"\n"
	Data:	.word	4,5,-9,0,3,0,8,-7,0	@ The list of data
	_Data:	@ End of list address
	STRING0: .asciz "Sum: "
	STRING1: .asciz "Negative value Count: "
	STRING2: .asciz "Positive value Count: "
	STRING3: .asciz "Zero value Count: "
	STRING4: .asciz "Minimum: "
	STRING5: .asciz "Maximum: "
	
.end