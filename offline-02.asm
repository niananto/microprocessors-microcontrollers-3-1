.MODEL SMALL 
.STACK 100H 
.DATA

TEMP DW ?
TEMP2 DB ?
LEN DW ?
N DW ?
CR EQU 0DH
LF EQU 0AH

ARRAY DW 100 DUP(?)

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    MENU_INPUT:
        ; char input 
        MOV AH, 1
        INT 21H
        
        ; if \n\r, stop taking input
        CMP AL, CR
        JZ END_MENU_INPUT
        ;CMP AL, LF
        ;JZ END_SINGLE_INPUT    

        AND AX, 000FH
        ;0000 0000 0000 1111
        
        ; save AX 
        MOV TEMP, AX
        
        ; DX = DX * 10 + TEMP
        MOV AX, 10
        MUL DX
        ADD AX, TEMP
        MOV DX, AX
        JMP MENU_INPUT
        
        END_MENU_INPUT:
        MOV N, DX
        ;MOV AH, 2
        ;MOV DL, LF
        ;INT 21H
               
    MOV CX, N
    MOV LEN, CX
    
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H               
               
    XOR BX, BX
             
    ALL_INPUT:
                   
        ; fast DX = 0
        XOR DX, DX
        
        SINGLE_INPUT:
        ; char input 
        MOV AH, 1
        INT 21H
        
        ; if \n\r, stop taking input
        CMP AL, CR
        JZ END_SINGLE_INPUT
        ;CMP AL, LF
        ;JZ END_SINGLE_INPUT    

        AND AX, 000FH
        ;0000 0000 0000 1111
        
        ; save AX 
        MOV TEMP, AX
        
        ; DX = DX * 10 + TEMP
        MOV AX, 10
        MUL DX
        ADD AX, TEMP
        MOV DX, AX
        JMP SINGLE_INPUT
        
        END_SINGLE_INPUT:
        MOV N, DX
        MOV AH, 2
        MOV DL, LF
        INT 21H
        
    MOV AX, N
    MOV ARRAY[BX], AX
    ADD BX, 2
    LOOP ALL_INPUT        
    
    ;;;INSERTION SORT;;;
    
    MOV CX, LEN
    XOR BX, BX
    
    INSERTION_SORT:
    MOV N, ARRAY[BX]
    MOV TEMP, BX
    
        BACKTRACK:
        DEC BX
        MOV AX, ARRAY[BX]
        CMP AX, N
        JG SWAP
        
        END_BACKTRACK:
        
    MOV BX, TEMP    
    ADD BX, 2
    LOOP INSERTION_SORT
    
    ;;;END INSERTION SORT;;;
    
    ;OUTPUT
    ;12, 34 THAKLE 21 43 HISHEBE PRINT HOY
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    MOV DL, 91  ;[
    INT 21H
    MOV DL, 32
    INT 21H
    
    XOR BX, BX
    MOV CX, LEN
    
    ALL_OUTPUT:
    MOV AX, ARRAY[BX]
        
        SINGLE_OUTPUT:
        MOV DL, 10
        DIV DL
        
        MOV TEMP2, AL ;RESULT
        MOV DL, AH   ;MODULUS
        ADD DL, 48
        MOV AH, 2
        INT 21H
        
        CMP TEMP2, 0
        JZ END_SINGLE_OUTPUT
        
        MOV AL, TEMP2
        AND AX, 00FFH
        JMP SINGLE_OUTPUT
    
        END_SINGLE_OUTPUT:
        MOV AH, 2
        MOV DL, 32
        INT 21H
        
        
    ADD BX, 2
    LOOP ALL_OUTPUT 
    
    MOV AH, 2
    MOV DL, 93
    INT 21H
      

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 
