;*****    
;* A *
;*ABC*
;* C *
;*****

.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

PROMPT DB 'ENTER 3 SYMBOLS',CR,LF,'$'
X DB ?
Y DB ?
Z DB ?
OUT1 DB '*****',CR,LF,'$'
OUT2 DB '* $'
OUT3 DB ' *',CR,LF,'$'
OUT4 DB '*$'
OUT5 DB '*',CR,LF,'$'
NEWLINE DB CR,LF,'$'

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
        
    ;PROMPT
    LEA DX, PROMPT
    MOV AH, 9
    INT 21H
    
    ;INPUT
    MOV AH, 1
    INT 21H
    MOV X, AL
    MOV AH, 1
    INT 21H
    MOV Y, AL
    MOV AH, 1
    INT 21H
    MOV Z, AL
    
    ;OUTPUT
    LEA DX, NEWLINE
    MOV AH, 9
    INT 21H
    
    LEA DX, OUT1
    MOV AH, 9
    INT 21H
    
    LEA DX, OUT2
    MOV AH, 9
    INT 21H
    
    MOV DL, X
    MOV AH, 2
    INT 21H
    
    LEA DX, OUT3
    MOV AH, 9
    INT 21H   
    
    LEA DX, OUT4
    MOV AH, 9
    INT 21H   
    
    MOV DL, X
    MOV AH, 2
    INT 21H
    
    MOV DL, Y
    MOV AH, 2
    INT 21H
    
    MOV DL, Z
    MOV AH, 2
    INT 21H  
    
    LEA DX, OUT5
    MOV AH, 9
    INT 21H
                
    LEA DX, OUT2
    MOV AH, 9
    INT 21H     
    
    MOV DL, Z
    MOV AH, 2
    INT 21H  
    
    LEA DX, OUT3
    MOV AH, 9
    INT 21H     
    
    LEA DX, OUT1
    MOV AH, 9
    INT 21H    
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
