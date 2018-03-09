/*
-------------------------------------------------------
task3.s
Program to test a recursive palindrome function.
-------------------------------------------------------
Author:  Jikyung Kim
ID:      150773520
Email:   kimx3520@mylaurier.ca
Date:    2018-03-03
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11		@ Terminate program code
.equ SWI_Open, 0x66		@ Open a file
						@ inputs - R0: address of file name, R1: mode (0: input, 1: write, 2: append)
						@ outputs - R0: file handle, -1 if open fails
.equ SWI_Close, 0x68	@ Close a file
						@ inputs - R0: file handle
.equ SWI_RdInt, 0x6c	@ Read integer from a file
						@ inputs - R0: file handle
						@ outputs - R0: integer
.equ SWI_PrInt, 0x6b	@ Write integer to a file
						@ inputs - R0: file handle, R1: integer
.equ SWI_RdStr, 0x6a	@ Read string from a file
						@ inputs - R0: file handle, R1: buffer address, R2: buffer size
						@ outputs - R0: number of bytes stored
.equ SWI_PrStr, 0x69	@ Write string to a file
						@ inputs- R0: file handle, R1: address of string
.equ SWI_PrChr, 0x00	@ Write a character to stdout
						@ inputs - R0: character
.equ SWI_SetSeg8, 0x200 @ Write to 8-segment display
						@ inputs - R0: segment(s)
.equ SWI_Timer, 0x6d    @ Read current time
						@ output - R0: current time

.equ inputMode, 0	@ Set file mode to input
.equ outputMode, 1	@ Set file mode to output
.equ appendMode, 2	@ Set file mode to append
.equ stdout, 1		@ Set output target to be Stdout

.equ False, 0
.equ True, 1
	
@-------------------------------------------------------
@ Main Program

	@ Test the first string
	MOV	R0, #stdout
	LDR	R1, =TestStringStr
	SWI	SWI_PrStr
	LDR	R1, =Pal1
	SWI	SWI_PrStr
	BL PrintLF
	MOV	R0, #stdout
	LDR	R1, =PalindromeStr
	SWI	SWI_PrStr
	LDR	R1, =Pal1
	BL	strlen
	MOV	R2, R0
	BL	Palindrome
	BL	PrintTrueFalse
	BL	PrintLF
	
	@ Test the second string
	MOV	R0, #stdout
	LDR	R1, =TestStringStr
	SWI	SWI_PrStr
	LDR	R1, =Pal2
	SWI	SWI_PrStr
	BL PrintLF
	MOV	R0, #stdout
	LDR	R1, =PalindromeStr
	SWI	SWI_PrStr
	LDR	R1, =Pal2
	BL	strlen
	MOV	R2, R0
	BL	Palindrome
	BL	PrintTrueFalse
	BL	PrintLF
	
	SWI	SWI_Exit

@-------------------------------------------------------
PrintLF:
    /*
    -------------------------------------------------------
    Prints the line feed character (\n)
    -------------------------------------------------------
	Uses:
	R0	- set to '\n'
	(SWI_PrChr automatically prints to stdout)
    -------------------------------------------------------
    */
	STMFD	SP!, {R0, LR}
	MOV	R0, #'\n'	@ Define the line feed character
	SWI	SWI_PrChr	@ Print the character to Stdout
	LDMFD   SP!, {R0, PC}
	
@-------------------------------------------------------
PrintTrueFalse:
    /*
    -------------------------------------------------------
    Prints "True" or "False" to stdout as appropriate
    -------------------------------------------------------
	Uses:
	R0 - input parameter, then set to stdout
	R1 - set to address of "True"
    -------------------------------------------------------
    */
	STMFD	SP!, {R0-R1, LR}
	CMP	R0, #0	@ Is R0 False?
	LDREQ	R1, =FalseStr	@ load "False" message
	LDRNE	R1, =TrueStr	@ load "True" message
	MOV	R0, #stdout
	SWI	SWI_PrStr	@ Print the string to Stdout
	LDMFD   SP!, {R0-R1, PC}
	
TrueStr:
.asciz	"True"	
FalseStr:
.asciz	"False"
	
@-------------------------------------------------------
strlen:
    /*
    -------------------------------------------------------
    Determines the length of a string.
    -------------------------------------------------------
	Uses:
	R0 - returned length
	R1 - address of string
	R2 - current character
    -------------------------------------------------------
    */
	STMFD	SP!, {R1-R2, LR}
	MOV	R0, #0	@ Initialize length	

strlenLoop:
	LDRB	R2, [R1], #1	@ Read address with post-increment (R2 = *R1, R1 += 1)
	CMP	R2, #0	@ Compare character with null
	ADDNE	R0, R0, #1
	BNE	strlenLoop	@ If not at end, continue
	
	LDMFD	SP!, {R1-R2, PC}

@-------------------------------------------------------
Palindrome:
	/*
	-------------------------------------------------------
	Determines if a string is a palindrome (Recursive)
	-------------------------------------------------------
	Uses:
	R0 - returns True if palindrome, False otherwise
	R1 - address of string
	R2 - length of string
	R3 - address of string from behind
	R4 - character to check from front
	R5 - character to check from back
	R6 - first time flag
	@ your further comments here
	
	-------------------------------------------------------
	*/
	STMFD SP!, {R1,LR}
	MOV R0, #1	@ initialize R0 to be true
	
	CMP R2, #0
	MOVEQ R0, #1
	MOVEQ PC,LR	@ if length is 0 true and leave the recursion
	CMP R2, #1
	MOVEQ R0, #1
	MOVEQ PC,LR	@ if length is 1 true and leave the recursion
	
	SUB R2, R2, #1
	LDRB R5,[R1,R2]
	LDRB R4,[R1],#1
	CMP R4, R5
	SUB R2, R2, #1
	BEQ Palindrome
	MOVNE R0, #0
	BNE _Palindrome
	
_Palindrome:
	LDMFD SP!, {R1,PC}
	@ your code here
	

@-------------------------------------------------------
TestStringStr:
.asciz	"Test String: "
PalindromeStr:
.asciz	"Palindrome: "
Pal1:
.asciz	"racecar"
Pal2:
.asciz	"notapalindrome"
.end