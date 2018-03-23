/*
-------------------------------------------------------
swap_array.s
Working with stack frames and local variables.
-------------------------------------------------------
Author:  Jikyung Colin kim
ID:      150773520
Email:   kimx3520@mylaurier.ca
Date:    2018-03-22
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

.equ inputMode, 0       @ Set file mode to input
.equ outputMode, 1      @ Set file mode to output
.equ appendMode, 2      @ Set file mode to append
.equ stdout, 1          @ Set output target to be Stdout

@-------------------------------------------------------
@ Main Program
   
    MOV    R0, #stdout
    
@ Print the array before the swap
    LDR    R2, =_Data
    LDR    R1, =Data
    SUB    R2, R2, R1
    STMFD  SP!, {R2}     @ Push length of list
    STMFD  SP!, {R1}     @ Push address of list
    BL     print_array
    ADD    SP, SP, #8
    BL     PrintLF

@ Swap the array data
    MOV    R1, #1
    STMFD  SP!, {R1}     @ Push j
    MOV    R1, #7
    STMFD  SP!, {R1}     @ Push i
    LDR    R1, =Data
    STMFD  SP!, {R1}     @ Push a
    BL     swap_array
    ADD    SP, SP, #12
    BL     PrintLF
    
@ Print the array after the swap
    LDR    R2, =_Data
    LDR    R1, =Data
    SUB    R2, R2, R1
    STMFD  SP!, {R2}     @ Push length of list
    STMFD  SP!, {R1}     @ Push address of list
    BL     print_array
    ADD    SP, SP, #8
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
    STMFD    SP!, {R0, LR}
    MOV    R0, #'\n'    @ Define the line feed character
    SWI    SWI_PrChr    @ Print the character to Stdout
    LDMFD   SP!, {R0, PC}
    
@-------------------------------------------------------
swap_array:
    /*
    -------------------------------------------------------
    Swaps location of two values in list.  swap(a, i, j)
	Parameters passed on stack:
	    Address of list
        Index of first value (i)
		Index of second value (j)
	Local variable
	    temp
		
    -------------------------------------------------------
	Uses:
	R0 - index i
	R1 - index j
	R2 - address of list
	R3 - value to swap
    -------------------------------------------------------
    */
    STMFD   SP!, {FP, LR}  @ push frame pointer and link register onto the stack
    MOV     FP, SP         @ save current stack top to frame pointer
    SUB     SP, SP, #4     @ set aside space for temp
    STMFD   SP!, {R0-R3}   @ preserve other registers
	
	LDR		R2, [FP, #8]   @ get address of list
	
	LDR     R0, [FP, #16]   @ get index j
	LDRB	R3, [R2,R0]
	STR     R3, [FP, #-4]  @ copy value of index j to temp
	
    LDR		R1, [FP, #12]   @ get index i
	LDRB	R3, [R2,R1]
	STRB     R3, [R2,R0]  @ copy value of index i to temp
	
	LDR	R3, [FP, #-4]	@ get temp
	STRB	R3, [R2,R1]	

@ your code here


    LDMFD   SP!, {R0-R3}   @ pop preserved registers
    ADD     SP, SP, #4     @ remove local storage
    LDMFD   SP!, {FP, PC}  @ pop frame pointer and program counter
 
@-------------------------------------------------------
print_array:
    /*
    -------------------------------------------------------
    Prints all integer values comma-separated in an array of bytes.
    (i.e. 2,4,7,1,6,...) with no trailing comma.
    Parameters passed on stack:
        Address of list
        Length of list
    -------------------------------------------------------
    Uses:
		R0 - stdout
		R1 - current array value
		R2 - address of list
		R3 - length of list
		R4 - counter
    -------------------------------------------------------
    */
	STMFD   SP!, {FP, LR}  @ push frame pointer and link register onto the stack
    MOV     FP, SP         @ save current stack top to frame pointer
    STMFD   SP!, {R0-R4}   @ preserve other registers
	
	MOV		R0, #stdout
	LDR		R2, [FP, #8]   @ get address of list 
	LDR		R3, [FP, #12]  @ length of list
	MOV		R4, #0		   @ Initilize counter
	
printloop:
	LDRB	R1, [R2], #1
	SWI		SWI_PrInt
	ADD		R4, R4, #1
	CMP		R3,R4
	BNE		printcom
	BEQ		_print_array
printcom:
	MOV    R0, #','
	SWI    SWI_PrChr
	MOV		R0, #stdout
	B printloop
_print_array:
	LDMFD   SP!, {R0-R4}   @ pop preserved registers
    LDMFD   SP!, {FP, PC}  @ pop frame pointer and program counter
 
	


@ your code here


 
@-------------------------------------------------------
.data
Data:    .byte    4,5,9,0,8,0,8,7,1    @ The list of data
_Data:    @ End of list address
.end