.MODEL SMALL 
.STACK 100H 
.DATA

COUNT DW ?

N DW ?
ISNEGATIVE DB ?
CR EQU 0DH
LF EQU 0AH

TEMP1 DW ?
TEMP2 DW ?
TEMP3 DW ?
TEMP4 DW ?
TEMP5 DW ?

MSG1 DB 'INSERT A NUMBER?',CR,LF,'$'
MSG2 DB CR,LF,'THE CO-PRIMES ARE -',CR,LF,'$'
MSG3 DB CR,LF,'TOTAL NUMBER OF CO-PRIMES IS -',CR,LF,'$'
MSG4 DB CR,LF,'YOUR INPUT MUST BE AN INTEGER GREATER THAN 1',CR,LF,'$'

NUMBER_STRING DB '00000$'

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ;Take an integer n from the user. 
    STEP_01: 
    
    MOV AH, 9
    LEA DX, MSG1
    INT 21H
    
    CALL MULTI_CHAR_INPUT ;INPUT SET IN N
    
    MOV AX, N
    CMP AX, 1
    JLE WRONG_INPUT 
    
    ;LOOP ALL IT'S SMALLER ONES
    ;CHECK FOR COPRIME
    ;PRINT IF COPRIME
    
    CALL NEWLINE
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    MOV CX, 2
    MOV COUNT, 0
    LOOP_SMALLER_NUMS:
        CMP CX, N
        JE END_LOOP_SMALLER

        MOV BX, N
        MOV TEMP3, BX
        MOV TEMP4, CX

        CALL GCD
        
        MOV AX, TEMP5
        CMP AX, 1
        JE INC_COUNT
        
        INC_COUNT_DONE:

        INC CX
        JMP LOOP_SMALLER_NUMS
        
        INC_COUNT:
            INC COUNT
            MOV AX, CX
            CALL MULTI_CHAR_PRINT_STRING
            CALL NEWLINE
            JMP INC_COUNT_DONE
    
    END_LOOP_SMALLER:
    
    MOV AH, 9
    LEA DX, MSG3
    INT 21H
    
    MOV AX, COUNT
    CALL MULTI_CHAR_PRINT_STRING
    JMP AGAIN   
    
    WRONG_INPUT:
        
        MOV AH, 9
        LEA DX, MSG4
        INT 21H
        JMP AGAIN
    
    AGAIN:

        CALL NEWLINE
        CALL NEWLINE 
        JMP STEP_01  

    END_IT_ALL: 
    
	;EXIT
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP


GCD PROC
    
    MOV TEMP1, AX
    MOV TEMP2, BX
    
    MOV AX, TEMP3
    MOV BX, TEMP4
        
    LOOP_NOT_EQUAL:
        
        CMP AX, BX
        JE LOOP_END
        JG LEFT_BIG
        JMP RIGHT_BIG
        
        
    LEFT_BIG: 
    
        SUB AX, BX
        JMP LOOP_NOT_EQUAL
    
    RIGHT_BIG:    
    
        SUB BX, AX       
        JMP LOOP_NOT_EQUAL
        
    LOOP_END:
    
    MOV TEMP5, AX
    
    MOV AX, TEMP1
    MOV BX, TEMP2
    RET
        
GCD ENDP


MULTI_CHAR_INPUT PROC
	XOR DX, DX    
    SINGLE_CHAR_INPUT: 
        MOV AH, 1
        INT 21H
        
        ;if minus sign
        CMP AL, '-'
        JE HANDLE_NEGATIVE
        
        ; if \n\r, stop taking input
        CMP AL, CR
        JZ END_SINGLE_CHAR_INPUT    

        AND AX, 000FH
        ;0000 0000 0000 1111
 
        MOV BX, AX
        
        ; DX = DX * 10 + BX
        MOV AX, 10
        MUL DX
        ADD AX, BX
        MOV DX, AX
        JMP SINGLE_CHAR_INPUT
        
    END_SINGLE_CHAR_INPUT:
        MOV N, DX
        CMP ISNEGATIVE, 1
    	JE NEGATIVE_INPUT
        RET
        
    HANDLE_NEGATIVE:
    	MOV ISNEGATIVE, 1
    	JMP SINGLE_CHAR_INPUT
   
   	NEGATIVE_INPUT:
   		MOV ISNEGATIVE, 0
   		NEG N
   		RET
    
    RET    
MULTI_CHAR_INPUT ENDP

NEWLINE PROC
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    RET
NEWLINE ENDP

MULTI_CHAR_PRINT_STRING PROC
    
    LEA DI, NUMBER_STRING
    ADD DI, 5               
    
    CMP AX, 0
    JL PRINT_NEG
    
    PRINT_LOOP:
        DEC DI
        
        MOV DX, 0
        ; DX:AX = 0000:AX
        
        MOV BX, 10
        DIV BX
        
        ADD DL, '0'
        MOV [DI], DL
        
        CMP AX, 0
        JNE PRINT_LOOP
        JMP DONE
        
    PRINT_NEG:
     	MOV BX, AX
     	MOV AH, 2
     	MOV DL, 45
     	INT 21H
     	MOV AX, BX
     	NEG AX
     	JMP PRINT_LOOP
     
    DONE:
    
    MOV DX, DI
    MOV AH, 9
    INT 21H
    
    RET

MULTI_CHAR_PRINT_STRING ENDP

END MAIN 
                                     