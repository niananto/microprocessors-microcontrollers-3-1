.MODEL SMALL
    
    
.STACK 100H
    
    
.DATA
CR EQU 0DH
LF EQU 0AH
     
PR DB 'Input a small letter. We will be printing the next capital version of that$'    
X DB ?
     
.CODE

MAIN PROC
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
           
    ;PROMPT
    LEA DX, PR
    MOV AH, 9
    INT 21H  
    
    ;NEW LINE
    MOV DL, CR
    MOV AH, 2
    INT 21H
    MOV DL, LF
    MOV AH, 2
    INT 21H
           
    ;INPUT X
    MOV AH, 1
    INT 21H
    MOV X, AL
            
    ;ADD 2 TO X
    SUB X, 31
               
    ;NEW LINE
    MOV DL, CR
    MOV AH, 2
    INT 21H
    MOV DL, LF
    MOV AH, 2
    INT 21H
    
    ;PRINT THE UPDATED VALUE OF X
    MOV DL, X
    MOV AH, 2
    INT 21H
      
      
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN
