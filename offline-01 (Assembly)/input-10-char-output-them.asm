.MODEL SMALL
.STACK 100H
.DATA
                 
    CR EQU 0DH
    LF EQU 0AH
    NEWLINE DB CR, LF, '$'
                 
    ARRAY DB 10 DUB(?)
    
.CODE  

MAIN PROC
    
    MOV AX, @DATA
    MOV DS, AX
    
    MOV CX, 10
    MOV BX, 0 
    MOV AH, 1
    
    FOR:
        INT 21H
        MOV ARRAY[BX], AL
        INC BX
    LOOP FOR
           
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
               
    MOV CX, 10
    MOV BX, 0 
    MOV AH, 2
    
    FOR2:
        MOV DL, ARRAY[BX]
        INT 21H
        INC BX
    LOOP FOR2
    
    
    
    MOV AH, 4CH
    INT 21H
    MAIN ENDP

END MAIN