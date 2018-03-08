/*
-------------------------------------------------------
reverse.s
Sample of recursive reverse subroutine.
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

@-------------------------------------------------------
@ Main Program

	MOV	R0, #stdout
	LDR	R1, =TestStringStr
	SWI	SWI_PrStr
	LDR	R1, =TestString
	SWI	SWI_PrStr
	BL PrintLF

	LDR	R1, =ReverseStr
	SWI	SWI_PrStr
	LDR	R1, =TestString
	BL Reverse
	BL PrintLF

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
Reverse:
	/*
	-------------------------------------------------------
	Prints the contents of a string in reverse.
	-------------------------------------------------------
	Uses:
	R0 - character to print
	R1 - Address of string
	-------------------------------------------------------
	*/
	STMFD	SP!, {R0-R1, LR}

	LDRB	R0, [R1], #1	@ Copy character with auto-increment
	CMP	R0, #0	@ At end of string? (NULL terminated)
	BEQ	_Reverse	@ Base Case: End of string - leave subroutine
	BL	Reverse	@ General Case: Make recursive call
	SWI SWI_PrChr	@ Print character

_Reverse:
	LDMFD   SP!, {R0-R1, PC}

@-------------------------------------------------------
TestStringStr:
.asciz	"Test String: "
ReverseStr:
.asciz	"Reversed: "
TestString:
.asciz	"This is a string."
.end