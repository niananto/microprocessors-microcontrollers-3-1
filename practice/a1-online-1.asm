;OCTADECIMAL
;A=17
;B=16
;C=15
;....
;H=10

.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

X DB ?

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
        
    ;INPUT
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    ;OUTPUT
    MOV DL, '1'
    MOV AH, 2
    INT 21H
     
    SUB X, 72
    NEG X
    ADD X, 48
    
    
    MOV DL, X
    MOV AH, 2
    INT 21H
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
