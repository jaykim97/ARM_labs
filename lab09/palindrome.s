/*
-------------------------------------------------------
palindrome.s
Working with stack frames.
-------------------------------------------------------
Author:  Jikyung Colin kim
ID:      150773520
Email:   kimx3520@mylaurier.ca
Date:    2018-03-13
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11     @ Terminate program code
.equ SWI_Open, 0x66     @ Open a file
                        @ inputs - R0: address of file name, R1: mode (0: input, 1: write, 2: append)
                        @ outputs - R0: file handle, -1 if open fails
.equ SWI_Close, 0x68    @ Close a file
                        @ inputs - R0: file handle
.equ SWI_RdInt, 0x6c    @ Read integer from a file
                        @ inputs - R0: file handle
                        @ outputs - R0: integer
.equ SWI_PrInt, 0x6b    @ Write integer to a file
                        @ inputs - R0: file handle, R1: integer
.equ SWI_RdStr, 0x6a    @ Read string from a file
                        @ inputs - R0: file handle, R1: buffer address, R2: buffer size
                        @ outputs - R0: number of bytes stored
.equ SWI_PrStr, 0x69    @ Write string to a file
                        @ inputs- R0: file handle, R1: address of string
.equ SWI_PrChr, 0x00    @ Write a character to stdout
                        @ inputs - R0: character

.equ inputMode, 0     @ Set file mode to input
.equ outputMode, 1    @ Set file mode to output
.equ appendMode, 2    @ Set file mode to append
.equ stdout, 1        @ Set output target to be Stdout

.equ False, 0
.equ True, 1

@-------------------------------------------------------
@ Main Program

    MOV    R0, #stdout
    LDR    R1, =TestStr
    SWI    SWI_PrStr
    LDR    R1, =Pal1
    SWI    SWI_PrStr
    BL     PrintLF
    LDR    R1, =PalindromeStr
    SWI    SWI_PrStr

    LDR    R1, =Pal1
    BL     strlen

    @STMFD	SP!, {R1,R0} WHY this wont work? 
	STMFD	SP!, {R0}	@ Push length of the string onto the stack
	STMFD	SP!, {R1}	@ Push address of the string onto the stack
	BL	Palindrome
	ADD SP, SP, #8		@ Release the parameter memory from the stack
	
    BL     PrintTrueFalse
    BL     PrintLF
    
    MOV    R0, #stdout
    LDR    R1, =TestStr
    SWI    SWI_PrStr
    LDR    R1, =Pal2
    SWI    SWI_PrStr
    BL     PrintLF
    LDR    R1, =PalindromeStr
    SWI    SWI_PrStr

    LDR    R1, =Pal2
    BL     strlen

    STMFD	SP!, {R0}	@push length of the string onto the stack
	STMFD	SP!, {R1}
	BL	Palindrome
	ADD SP, SP, #8
	
    BL     PrintTrueFalse
    BL     PrintLF
    
    SWI    SWI_Exit

@-------------------------------------------------------
PrintLF:
    /*
    -------------------------------------------------------
    Prints the line feed character (\n)
    -------------------------------------------------------
    Uses:
    R0    - set to '\n'
    (SWI_PrChr automatically prints to stdout)
    -------------------------------------------------------
    */
    STMFD   SP!, {R0, LR}
    MOV     R0, #'\n'       @ Define the line feed character
    SWI     SWI_PrChr       @ Print the character to Stdout
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
    STMFD   SP!, {R0-R1, LR}
    CMP     R0, #0          @ Is R0 False?
    LDREQ   R1, =FalseStr   @ load "False" message
    LDRNE   R1, =TrueStr    @ load "True" message
    MOV     R0, #stdout
    SWI     SWI_PrStr       @ Print the string to Stdout
    LDMFD   SP!, {R0-R1, PC}
    
TrueStr:
.asciz    "True"    
FalseStr:
.asciz    "False"

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
    STMFD   SP!, {R1-R2, LR}
    MOV     R0, #0          @ Initialize length    

strlenLoop:
    LDRB    R2, [R1], #1    @ Read address with post-increment (R2 = *R1, R1 += 1)
    CMP     R2, #0          @ Compare character with null
    ADDNE   R0, R0, #1
    BNE     strlenLoop      @ If not at end, continue
    
    LDMFD   SP!, {R1-R2, PC}

@-------------------------------------------------------
Palindrome:
    /*
    -------------------------------------------------------
    Determines if a string is a palindrome (iterative)
	Parameters passed on stack:
        Address of string
        Length of string
    -------------------------------------------------------
    Uses:
    R0 - returns True if palindrome, False otherwise
    R1 - address of string
    R2 - length of string
    R3 - left character
    R4 - right character
    -------------------------------------------------------
    */
    STMFD   SP!, {FP, LR}   @ push frame pointer and link register onto the stack
    MOV     FP, SP          @ Save current stack top to frame pointer
                            @ allocate local storage (none)
    STMFD   SP!, {R1-R4}    @ preserve other registers
    
    LDR     R1, [FP, #8]    @ Get string address
    LDR     R2, [FP, #12]   @ Get length of string
    
    MOV     R0, #True       @ Initialize result to True

PalindromeLoop:    
    CMP     R2, #1          @ Compare string length to 1
    BLE     _Palindrome
    
    LDRB    R3, [R1], #1    @ Get leftmost character, increment string address
    SUB     R2, R2, #2      @ Offset to right-most character (length - 1)
    LDRB    R4, [R1, R2]    @ Get rightmost character
    
    CMP     R3, R4          @ Compare left and right characters
    MOVNE   R0, #False      @ Characters do not match, result is False
    BEQ     PalindromeLoop  @ Characters match - keep looping
    
_Palindrome:
    LDMFD   SP!, {R1-R4}    @ pop preserved registers
                            @ deallocate local storage (none was allocated)
    LDMFD   SP!, {FP, PC}   @ pop frame pointer and program counter

@-------------------------------------------------------
TestStr:
.asciz    "Test String: "
PalindromeStr:
.asciz    "Palindrome: "
Pal1:
.asciz    "racecar"
Pal2:
.asciz    "notapalindrome"
.end