.MODEL SMALL 
.STACK 100H 
.DATA

CR EQU 0DH
LF EQU 0AH

ARRAY DW 1,3,5,8,12
NUMBER_STRING DB '00000$'

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    XOR SI, SI ;MAKE SI 0
    LOOP_ARR:
    	CMP SI, 8
    	JE END_LOOP_ARR
    	
    	MOV BX, ARRAY[SI]
    	CMP BX, 1
    	JLE END_LOOP_PRIME
    	MOV CX, 2
    	LOOP_PRIME:
    		CMP CX, BX
    		JGE PRIME
    		
    		MOV AX, BX
    		XOR DX, DX
    		DIV CX
    		
    		CMP DX, 0
    		JE END_LOOP_PRIME
    		
    		INC CX
    		JMP LOOP_PRIME	
    	
    	PRIME:
    		CALL NEWLINE
    		MOV AX, BX
    		CALL MULTI_CHAR_PRINT_STRING
    		JMP END_LOOP_PRIME
    	
    	END_LOOP_PRIME:
    	
    	ADD SI, 2
    	JMP LOOP_ARR
    	
    END_LOOP_ARR:	 
    
	;EXIT
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP  

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
                                     