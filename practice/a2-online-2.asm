;grading
;80 or more -> A+
;70 to 80 -> A

.MODEL SMALL 
.STACK 100H 
.DATA

N DW ?
CR EQU 0DH
LF EQU 0AH
MSG DB ?

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; first BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    
    ; first char to digit
    ; also clears AH
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    MOV N, BX
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    
    ;------------------------------------
    ; start from here
    ; input is in N
    
    MOV AH, 2
           
    CMP N, 100
    JG INVALID           
    CMP N, 80
    JNL A_PLUS
    CMP N, 70
    JNL A
    CMP N, 60
    JNL A_MINUS
    JMP INVALID
    
    A_PLUS:
    MOV DL, 65
    INT 21H
    MOV DL, 43
    INT 21H
    JMP END
    
    A:
    MOV DL, 65
    INT 21H 
    JMP END
    
    A_MINUS:
    MOV DL, 65
    INT 21H
    MOV DL, 45
    INT 21H
    JMP END
    
    INVALID:
    JMP END
    
    END:
    
    
      

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 

