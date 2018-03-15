/*
-------------------------------------------------------
min_max.s
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

       @ push the parameters onto the stack
	LDR R1, =Min
	STMFD SP!,{R1}
	
	LDR R1, =Max
	STMFD SP!,{R1}
	
	LDR R1, =_Data
	STMFD SP!,{R1}
	
	LDR R1, =Data
	STMFD SP!,{R1}
	
	BL    MinMax       @ Call the function
    ADD SP, SP, #16	@ Release the parameter memory from the stack
		
	
    MOV    R0, #stdout
    LDR    R1, =MinStr
    SWI    SWI_PrStr
    LDR    R1, =Min
    LDR R1, [R1]
    SWI SWI_PrInt
    BL    PrintLF    
    
    LDR    R1, =MaxStr
    SWI    SWI_PrStr
    LDR    R1, =Max
    LDR R1, [R1]
    SWI SWI_PrInt
    BL    PrintLF    
    
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
    STMFD    SP!, {R0, LR}
    MOV    R0, #'\n'    @ Define the line feed character
    SWI    SWI_PrChr    @ Print the character to Stdout
    LDMFD   SP!, {R0, PC}
    
@-------------------------------------------------------
MinMax:
    /*
    -------------------------------------------------------
    Finds the minimum and maximum values in a list.
    Passes addresses of list, end of list, max, and min as parameters
	in that order.
    -------------------------------------------------------
    Uses:
	R1 - address of list of numbers
	R2 - address of end of the list 
	R3 - address of max value
	R4 - address of min value
	R5 - current value
	R6 - current of max
	R7 - current of min
    -------------------------------------------------------
    */

	STMFD SP!, {FP, LR}	@ push frame pointer and link register onto the stack
	MOV FP, SP			@ Save current stack top to frame pointer
	
	STMFD SP!, {R1-R7}	@ preserve other registers
	
	LDR R1, [FP, #8]	@ Get address of list of numbers to R1
	LDR R2, [FP, #12]	@ Get address of end of the list to R2 
	LDR R3, [FP, #16]	@ Get address of max to R3
	LDR R4, [FP, #20]	@ Get address of max to R4
	
	MOV R6, #0			@ Initialize max at R6
	MOV R7, #0			@ Initialize min at R7
	
	
listLoop:
	LDR R5, [R1], #4	@ Load value of the list to R5
	CMP R6, R5			
	MOVLE R6, R5		@ Set max to R5 if value is greater than current max
	CMP R7, R5			
	MOVGT R7, R5		@ Set min to R5 if value is greater than current max
	CMP R2, R1
	BNE	listLoop		@ If not end of the list loop back else go to _MinMax
	BEQ	_MinMax

_MinMax:
	STR R6, [R3]		@ Store Max to memory
	STR R7, [R4]		@ Store Min to memory
	LDMFD SP!, {R1-R7}	@ Pop preserved registers
	LDMFD SP!, {FP, PC}	@ Pop frame pointer and program counter
	

	
 
@-------------------------------------------------------
Data:    .word    4,5,-9,0,3,0,8,-7,12    @ The list of data
_Data:    @ End of list address
Min:    .space 4
Max:    .space 4
MinStr:
.asciz  "Minimum: "
MaxStr:
.asciz  "Maximum: "
.end