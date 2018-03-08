/*
-------------------------------------------------------
task1.s
Subroutines for working with characters.
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

	MOV	R1, #'E'	@ set the character

	@ Print character
	MOV	R2, R1	@ preserve character
	MOV	R0, #stdout 	
	LDR	R1, =characterStr
	SWI	SWI_PrStr	@R0: STDOUT, R1: 'Character':, R2: "E"
	MOV	R0, R2	@R0: "E"
	SWI SWI_PrChr
	BL	PrintLF
	
	@ Test if lower case
	MOV	R0, #stdout
	LDR	R1, =isLowerStr 
	SWI	SWI_PrStr	@R0: STDOUT, R1: 'is lower case:':, R2: "E"
	MOV	R1, R2	@R0: STDOUT, R1: "E":, R2: "E"
	BL	isLowerCase
	BL	PrintTrueFalse
	BL	PrintLF
	
	@ Test if upper case
	MOV	R0, #stdout
	LDR	R1, =isUpperStr
	SWI	SWI_PrStr
	MOV	R1, R2
	BL	isUpperCase
	BL	PrintTrueFalse
	BL	PrintLF

	@ Test if letter
	MOV	R0, #stdout
	LDR	R1, =isLetterStr
	SWI	SWI_PrStr
	MOV	R1, R2
	BL	isLetter
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
	R0 - input parameter; then set to stdout
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
isLowerCase:
    /*
    -------------------------------------------------------
    Determines if a character is a lower case letter.
	ASCII digits are defined as (hexadecimal):
	a (0x61) - z (0x7A)
    -------------------------------------------------------
	Uses:
	R0 - returns True if lower case, False otherwise
	R1 - character parameter
    -------------------------------------------------------
    */
	MOV	R0, #False
	CMP	R1, #'a'
	BLT	_isLowerCase	@ < 'a', return False
	CMP	R1, #'z'
	MOVLE	R0, #True	@ <= 'z', return True
_isLowerCase:
	MOV	PC, LR

@-------------------------------------------------------
isUpperCase:
    /*
    -------------------------------------------------------
    Determines if a character is an upper case letter.
	ASCII digits are defined as (hexadecimal):
	A (0x41) - Z (0x5A)
    -------------------------------------------------------
	Uses:
	R0 - returns True if upper case, False otherwise
	R1 - character parameter
    -------------------------------------------------------
    */
	MOV	R0, #False
	CMP	R1, #'A'
	BLT	_isUpperCase	@ < 'A', return False
	CMP	R1, #'Z'
	MOVLE	R0, #True	@ <= 'Z', return True
_isUpperCase:
	MOV	PC, LR


@-------------------------------------------------------
@This causes error. 
@Reason: when branching to isLowerCase LR will be the CMP R0, #False line.
@		This will cause LR back to actual main function to be lost and 
@		continuously loop inside isLetter
isLetter:
    /*
    -------------------------------------------------------
    Determines if a character is a letter.
	ASCII letters are defined as:
	A (0x41) - Z (0x5A), a (0x61) - z (0x7A)
    -------------------------------------------------------
	Uses:
	R0 - returns True if letter, False otherwise
	R1 - character parameter
	R4 - preserve LR
    -------------------------------------------------------
    */
	MOV R3, LR
	BL	isLowerCase
	CMP	R0, #False
	BLEQ	isUpperCase	@ Not lowercase? Test for uppercase.
	MOV PC, R3

@-------------------------------------------------------
characterStr:
.asciz	"Character: "
isLetterStr:
.asciz "Is Letter: "
isLowerStr:
.asciz "Is Lower Case: "
isUpperStr:
.asciz "Is Upper Case: "
.end
