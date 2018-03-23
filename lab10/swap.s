/*
-------------------------------------------------------
radix_sort.s
Working with stack frames and local variables.
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
Date:    2018-03-19
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
    LDR    R1, =a
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    
    LDR    R1, =b
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    

    LDR    R1, =a
    STMFD  SP!, {R1}     @ Push a
    LDR    R1, =b
    STMFD  SP!, {R1}     @ Push b
    BL     swap
    ADD    SP, SP, #8
    
    LDR    R1, =a
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    
    LDR    R1, =b
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF  
    
    BL     PrintLF
    
    MOV    R0, #stdout
    LDR    R1, =c
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    
    LDR    R1, =d
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    

    LDR    R1, =c
    STMFD  SP!, {R1}     @ Push c
    LDR    R1, =d
    STMFD  SP!, {R1}     @ Push d
    BL     swap
    ADD    SP, SP, #8
    
    LDR    R1, =c
    LDR    R1, [R1]
    SWI    SWI_PrInt
    BL     PrintLF    
    LDR    R1, =d
    LDR    R1, [R1]
    SWI    SWI_PrInt
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
    STMFD  SP!, {R0, LR}
    MOV    R0, #'\n'    @ Define the line feed character
    SWI    SWI_PrChr    @ Print the character to Stdout
    LDMFD  SP!, {R0, PC}
    
@-------------------------------------------------------
swap:
    /*
    -------------------------------------------------------
    Swaps location of two values in memory.  swap(x, y)
    Parameters passed on stack:
        Address of first value (x)
        Address of second value (y)
    Local variable
        temp (4 bytes)
    -------------------------------------------------------
    Uses:
    R0 - address of x
    R1 - address of y
    R2 - value to swap
    -------------------------------------------------------
    */
    STMFD   SP!, {FP, LR}  @ push frame pointer and link register onto the stack
    MOV     FP, SP         @ save current stack top to frame pointer
    SUB     SP, SP, #4     @ set aside space for temp
    STMFD   SP!, {R0-R2}   @ preserve other registers

    LDR     R0, [FP, #8]   @ get address of x
    LDR     R2, [R0]       @ get value at x
    STR     R2, [FP, #-4]  @ copy value of x to temp

    LDR     R1, [FP, #12]  @ get address of y
    LDR     R2, [R1]       @ get value at y
    STR     R2, [R0]       @ store value of y in x
    
    LDR     R2, [FP, #-4]  @ get temp
    STR     R2, [R1]       @ store temp in y
    
    LDMFD   SP!, {R0-R2}   @ pop preserved registers
    ADD     SP, SP, #4     @ remove local storage
    LDMFD   SP!, {FP, PC}  @ pop frame pointer and program counter

 
@-------------------------------------------------------
.data
a:    .word    9
b:    .word    1
c:    .word    5
d:    .word    3
.end