             B main
initialValue DEFW 65539
seed         DEFW 123456   
prompt       DEFB "Please input a number between 0 and 255: ",0
error_Output DEFB "Invalid Entry - Press enter another value and press enter to continue \n",0
new_line     DEFB "\n",0
result       DEFB "User input: ",0
high         DEFB "Value is too high - Press enter another value and press enter to continue\n",0
low          DEFB "Value is too low - Press enter another value and press enter to continue\n",0
final        DEFB "You correctly guessed the random number! - ",0

             ALIGN

main         BL randu
             ADR R0, prompt
             SWI 3
             BL readInt 
             BL reset
             SWI 2

randu        LDR R5, seed
             LDR R6, initialValue
             MUL R7, R6, R5
             AND R7, R7, #0x7FFFFFFF
             STR R7, seed
             LDR R5, seed
             MOV R7, R7 ASR #8 
             AND R7, R7, #0xff 
             MOV PC, R14

readInt      MOV R3, #10
             SWI 1   
             SWI 0   
             CMP R0, #10    
             BEQ compare    
             CMP R0, #48    
             BLT error_msg   
             CMP R0, #58     
             BGE error_msg   
             SUB R1, R0, #48 
             MUL R2, R2, R3  
             ADD R2, R2, R1  
             B readInt

compare      CMP R2, #0
             BLT error_msg
             CMP R2, #255
             BGT error_msg
             CMP R2, R7
             BLT lower
             CMP R2, R7
             BGT higher
             CMP R2, R7
             BEQ equal
             B compare

lower        MOV R2, #0
             ADRL R0, low
             SWI 3
             B readInt

higher       MOV R2, #0
             ADRL R0, high
             SWI 3 
             B readInt               

equal        ADRL R0, final
             SWI 3
             MOV R0, R7
             SWI 4
             MOV PC, R14

error_msg    ADRL R0, error_Output  
             SWI 3   
             MOV R2, #0   
             B readInt

reset        ADRL R0, new_line
             SWI 3
             MOV R0, #0
             MOV R1, #0
             MOV R2, #0
             MOV R3, #0
             MOV PC, R14
