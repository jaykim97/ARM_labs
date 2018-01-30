/*
-------------------------------------------------------
lab01.s
Assign to and add contents of registers.
-------------------------------------------------------
Author:  David Brown
ID:      999999999
Email:   dbrown@wlu.ca
Date:    2018-01-06
-------------------------------------------------------
*/
.equ SWI_Exit, 0x11 @ Assign a label to the terminate program code

    MOV R0, #9      @ Store decimal 9 in register R0
    MOV R1, #0xE    @ Store hex E (decimal 14) in register R1
    ADD R2, R1, R0  @ Add the contents of R0 and R1 and put result in R2
    SWI SWI_Exit    @ Terminate the program