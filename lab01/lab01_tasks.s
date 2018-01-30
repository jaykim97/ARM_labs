/*
-------------------------------------------------------
lab01_tasks.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  Colin Jikyung Kim
ID:      150773520
Email:   kimx3520@wlu.ca
Date:    2018-01-12
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Assign a label to the terminate program code

MOV R0, #9      @ Store decimal 9 in register R0
MOV R1, #14   	@ Store hex E (decimal 14) in register R1
ADD R2, R1, R0  @ Add the contents of R0 and R1 and put result in R2
MOV R3, #8      @ Store 8 in register R3
ADD R3, R3, R3	@ Add value in R3 and R3 and put result in R3
MOV R5, #4      @ Store 4 in R5
ADD R4, R5,#5	@ Add value 4 and 5 and put result in r4
@ADD R4, #5,R5	This doesn't work
SWI SWI_Exit    @ Terminate the program

/*
1. no change
2. result 10(hex)= 16 in decimal
3. immediate value cannot be added. works when middle operand is changed to register
*/