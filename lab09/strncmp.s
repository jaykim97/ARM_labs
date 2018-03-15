/*
-------------------------------------------------------
strncmp.s
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

@-------------------------------------------------------
@ Main Program

    MOV    R0, #stdout
    LDR    R1, =TestStr
    SWI    SWI_PrStr
    LDR    R1, =Str1
    SWI    SWI_PrStr
    BL     PrintLF
    LDR    R1, =TestStr
    SWI    SWI_PrStr
    LDR    R1, =Str2
    SWI    SWI_PrStr
    BL     PrintLF
    LDR    R1, =LengthStr
    SWI    SWI_PrStr
    MOV    R1, #16       @ Set the maximum comparison length
    SWI    SWI_PrInt
    BL     PrintLF
	
    STMFD  SP!, {R1}     @ Push the maximum length
    LDR    R1, =Str2
    STMFD  SP!, {R1}     @ Push the second string address
    LDR    R1, =Str1
    STMFD  SP!, {R1}     @ Push the first string address
    BL     strncmp
    ADD    SP, SP, #12   @ Clean up the stack
	
    MOV    R2, R0        @ Save result
	
    MOV    R0, #stdout
    LDR    R1, =StrncmpStr
    SWI    SWI_PrStr
    MOV    R0, R2        @ Recover result
    BL     PrintLEG
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
PrintLEG:
    /*
    -------------------------------------------------------
    Prints "Lesser", "Equals", or "Greater" to stdout as appropriate
    -------------------------------------------------------
    Uses:
    R0 - input parameter, then set to stdout
    R1 - set to address of "True"
    -------------------------------------------------------
    */
    STMFD   SP!, {R0-R1, LR}
    CMP     R0, #0           @ Is R0 Equals?
    LDRLT   R1, =LesserStr   @ load "Lesser" message
    LDRGT   R1, =GreaterStr  @ load "Greater" message
    LDREQ   R1, =EqualsStr   @ load "Equals" message
    MOV     R0, #stdout
    SWI     SWI_PrStr        @ Print the string to Stdout
    LDMFD   SP!, {R0-R1, PC}
    
LesserStr:
.asciz    "Lesser"    
EqualsStr:
.asciz    "Equals"
GreaterStr:
.asciz    "Greater"

@-------------------------------------------------------
strncmp:
    /*
    -------------------------------------------------------
    Determines if two strings are equal up to a max length (iterative)
	Parameters passed on stack:
        Address of first string
		Address of second string
        Maximum length of comparisons
    -------------------------------------------------------
    Uses:
    R0 - returns < 0 if first string comes first, > 0 if first string comes second,
         0 if two strings are equal up to maximum length
    R1 - address of first string
    R2 - address of second string
	R3 - current maximum length
    R4 - character from first string
    R5 - character from second string
    -------------------------------------------------------
    */

    @ your code here
    @ initialize stack, frame pointer, and extract parameters from stack
	STMFD	SP!, {FP,LR}	@ Push frame pointer and link register onto the stack
	MOV	FP, SP				@ Save current stack top to frame pointer
	
	STMFD	SP!, {R1-R5}	@ Preserve other registers
	LDR	R1, [FP, #8]		@ Get address of first string
	LDR	R2, [FP, #12]		@ Get address of second string
	LDR	R3, [FP, #16]		@ Get maximum length
	
	
	
    MOV     R0, #0          @ Initialize result to strings equal

strncmpLoop:
    CMP     R3, #0
    BEQ     _strncmp        @ Max length met - finish comparison
    LDRB    R4, [R1], #1    @ Get character from first string
    LDRB    R5, [R2], #1    @ Get character from second string
    CMP     R4, R5
    SUBNE   R0, R4, R5      @ Calculate difference between two characters if not the same
    BNE     _strncmp        @ Return difference if not the same
    CMP     R4, #0          @ Look for end of strings
    BEQ     _strncmp        @ Return if at end of strings
    SUB     R3, R3, #1      @ Decrement max length count
    B       strncmpLoop
    
_strncmp:
	
    @ your code here
    @ clean up stack
	LDMFD	SP!, {R1-R5}	@ Pop preserved registers
	LDMFD	SP!, {FP, PC}	@ pop frame pointer and program counter

@-------------------------------------------------------
TestStr:
.asciz    "Test String: "
LengthStr:
.asciz    "Max Length: "
StrncmpStr:
.asciz    "Comparison: "
Str1:
.asciz    "This is a string"
Str2:
.asciz    "This is a string, but longer"
.end