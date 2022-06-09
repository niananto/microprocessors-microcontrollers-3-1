.MODEL SMALL 
.STACK 100H 
.DATA

N DW ?
CR EQU 0DH
LF EQU 0AH  

_FIRST DB CR,LF,'FIRST QUADRANT$'
_SECOND DB CR,LF,'SECOND QUADRANT$'
_THIRD DB CR,LF,'THIRD QUADRANT$'
_FOURTH DB CR,LF,'FOURTH QUADRANT$'
_ORIGIN DB CR,LF,'ORIGIN$'
_Y_AXIS DB CR,LF,'Y AXIS$'
_X_AXIS DB CR,LF,'X AXIS$'

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 1
    INT 21H
    CMP AL, '-'
    JE NEGATIVE_X
    CMP AL, '0'
    JE POSITIVE_X
    JMP INVALID
    
    NEGATIVE_X:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE Y_AXIS           
    
    MOV AH, 1
    INT 21H    ;BLANK INPUT
    
    MOV AH, 1
    INT 21H
        
    CMP AL, '-'
    JE THIRD
    CMP AL, '0'
    JE SECOND
    JMP INVALID           
               
    POSITIVE_X:
    MOV AH, 1
    INT 21H
    CMP AL, '0'
    JE Y_AXIS
    
    MOV AH, 1
    INT 21H    ;BLANK INPUT
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '-'
    JE FOURTH
    CMP AL, '0'
    JE FIRST
    JMP INVALID
    
    ORIGIN:
    LEA DX, _ORIGIN
    MOV AH, 9
    INT 21H
    JMP END
    
    Y_AXIS:
    MOV AH, 1
    INT 21H    ;BLANK INPUT
    MOV AH, 1
    INT 21H    ;BLANK INPUT
    MOV AH, 1
    INT 21H    ;BLANK INPUT
    
    CMP AL, '0'
    JE ORIGIN
    
    LEA DX, _Y_AXIS
    MOV AH, 9
    INT 21H
    JMP END
    
    X_AXIS:
    LEA DX, _X_AXIS
    MOV AH, 9
    INT 21H
    JMP END
        
    
    FIRST:
    MOV AH,1
    INT 21H
    CMP AL, '0'
    JE X_AXIS
    
    LEA DX, _FIRST
    MOV AH, 9
    INT 21H
    JMP END
    
    SECOND:
    MOV AH,1
    INT 21H
    CMP AL, '0'
    JE X_AXIS
    
    LEA DX, _SECOND
    MOV AH, 9
    INT 21H
    JMP END
    
    THIRD:
    MOV AH,1
    INT 21H
    CMP AL, '0'
    JE X_AXIS
    
    LEA DX, _THIRD
    MOV AH, 9
    INT 21H
    JMP END
    
    FOURTH:
    MOV AH,1
    INT 21H
    CMP AL, '0'
    JE X_AXIS
    
    LEA DX, _FOURTH
    MOV AH, 9
    INT 21H
    JMP END
    
    INVALID:
    ;DO NOTHING
    
    END:
    ;DO NOTHING
    
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 


