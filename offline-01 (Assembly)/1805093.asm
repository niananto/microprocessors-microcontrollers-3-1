.MODEL SMALL 
.STACK 100H 
.DATA

COUNT DW ?
LEN DW ?
N DW ?
ISNEGATIVE DB ?
CR EQU 0DH
LF EQU 0AH

MSG1 DB 'INSERT HOW MANY NUMBERS YOU WANT IN THE ARRAY?',CR,LF,'$'
MSG2 DB CR,LF,'HERE IS THE SORTED ARRAY',CR,LF,'$'
MSG3 DB CR,LF,'INSERT A NUMBER TO SEARCH IN THE ARRAY',CR,LF,'$'
MSG4 DB CR,LF,'FOUND IN THE INDEX $'
MSG5 DB CR,LF,'NOT FOUND$'

ARRAY DW 100 DUP(?)
NUMBER_STRING DB '00000$'

LOW DW ?
HIGH DW ?
MID DW ?

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ;1. Take an integer n from the user. 
    STEP_01: 
    
    MOV AH, 9
    LEA DX, MSG1
    INT 21H
    
    CALL MULTI_CHAR_INPUT ;INPUT SET IN N
    
    ;2. Go to Step 10 if n <=0 
    CMP N, 0
    JLE END_IT_ALL
               
    MOV CX, N
    MOV LEN, CX
    
    CALL NEWLINE               
    
    ;3. Take n integers from the user.            
    XOR SI, SI        
    ALL_INPUT:
        CALL MULTI_CHAR_INPUT ;INPUT SET IN N           
        
        MOV AH, 2
        MOV DL, LF
        INT 21H
        
	    MOV AX, N
	    MOV ARRAY[SI], AX
	    ADD SI, 2
    LOOP ALL_INPUT        
    
    ;4. Sort them using insertion sort. 
    CALL INSERTION_SORT ;CHANGE THE ARRAY
    
    ;5. Display the sorted array. 
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    XOR SI, SI
    MOV CX, LEN
    
    ALL_OUTPUT:
    	MOV AX, ARRAY[SI]
    	MOV N, AX
    	MOV COUNT, 0
        
        ;CALL MULTI_CHAR_OUTPUT
        CALL MULTI_CHAR_PRINT_STRING
        	
        MOV AH, 2
        MOV DL, 32
        INT 21H
    	ADD SI, 2
    LOOP ALL_OUTPUT 
    
    ;6. Take an integer x from the user.
    STEP_06:
     
    MOV AH, 9
    LEA DX, MSG3
    INT 21H
    
    CALL MULTI_CHAR_INPUT ;INPUT SET IN N  
    
    ;7. Use binary search to find x’s index in the sorted array. Display the index if found, otherwise
	;print ‘NOT FOUND’. 
    CALL BINARY_SEARCH ;SEARCH IN ARRAY FOR N
    JMP STEP_06
    
    ;9. Go to Step 1. 
    JMP STEP_01  
    END_IT_ALL:
    ;10. End 
    
	;EXIT
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP  

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
   
MULTI_CHAR_OUTPUT PROC
	
	MOV COUNT, 0
	
	CMP AX, 0
	JL NEGATIVE_OUTPUT
	
	SINGLE_OUTPUT:
		MOV DX, 0
        MOV BX, 10
        DIV BX
        
		PUSH DX
		INC COUNT  
         
        CMP AX, 0
        JZ END_SINGLE_OUTPUT
        
        JMP SINGLE_OUTPUT

    END_SINGLE_OUTPUT:
		MOV BX, CX
		MOV CX, COUNT
		MOV AH, 2
		
		PRINT_OUTPUT:
			POP DX
			ADD DL, 48
			INT 21H
		LOOP PRINT_OUTPUT       
    
    	MOV CX, BX
        RET
        
   	NEGATIVE_OUTPUT:
   		MOV BX, AX
   		
   		MOV AH, 2
   		MOV DL, 45
   		INT 21H
   		
   		MOV AX, BX
   		NEG AX
   		JMP SINGLE_OUTPUT
   	
    RET    	
MULTI_CHAR_OUTPUT ENDP

INSERTION_SORT PROC
	MOV CX, LEN
    XOR SI, SI
    XOR BX, BX
    
    SORT:
	    MOV BX, SI
	    
        BACKTRACK:
        	CMP SI, 0
	        JE END_BACKTRACK
	        
	        MOV AX, ARRAY[SI-2]
	        MOV DX, ARRAY[SI]
	        CMP AX, DX
	        JNG END_BACKTRACK
	        
	        ;SWAP ARRAY[BX] AND ARRAY[BX-2]
        	MOV ARRAY[SI-2], DX
        	MOV ARRAY[SI], AX
        	
        	SUB SI, 2
        	JMP BACKTRACK    	
        	                     
        END_BACKTRACK:
	        
	    MOV SI, BX    
	    ADD SI, 2
    LOOP SORT
    RET
INSERTION_SORT ENDP

BINARY_SEARCH PROC

	MOV AX, LEN
    MOV BX, 2
    MUL BX
    MOV HIGH, AX
    SUB HIGH, 2
    MOV LOW, 0
    
    SEARCH:
    	MOV AX, HIGH
    	CMP AX, LOW
    	JL END_UNSUCCESSFUL_SEARCH
    	
    	ADD AX, LOW
    	MOV BX, 2
    	DIV BX
    	AND AX, 00FFH
    	MOV MID, AX
    	
    	;CHECK IF MID IS ODD, THEN TAKE SMALLER EVEN
    	MOV AX, MID
    	MOV BX, 2
    	DIV BX
    	CMP DX, 1
    	JE TAKE_SMALLER_EVEN
    	
    	TAKEN_SMALLER_EVEN:
    	
        MOV BX, MID
        MOV AX, ARRAY[BX]
       	CMP AX, N
       	JE END_SUCCESSFUL_SEARCH
       	JL GO_RIGHT
       	JMP GO_LEFT
       	
    TAKE_SMALLER_EVEN:
        DEC MID
    	JMP TAKEN_SMALLER_EVEN
       	
    GO_LEFT:
		MOV AX, MID
		MOV HIGH, AX
		SUB HIGH, 2
		JMP SEARCH
		       
    GO_RIGHT:
        MOV AX, MID
		MOV LOW, AX
		ADD LOW, 2
		JMP SEARCH
		
    END_SUCCESSFUL_SEARCH:
	    LEA DX, MSG4
	    MOV AH, 9
	    INT 21H
	          
;	    MID/2
		MOV DX, 0
	    MOV AX, MID
    	MOV BX, 2
    	DIV BX
	    
	    INC AX
        ;CALL MULTI_CHAR_OUTPUT       
        CALL MULTI_CHAR_PRINT_STRING
		
		;8. For another search in the same array go to Step 6.
	    RET
    
    END_UNSUCCESSFUL_SEARCH:
        LEA DX, MSG5
        MOV AH, 9
        INT 21H
        ;8. For another search in the same array go to Step 6.
        RET
    
    RET
BINARY_SEARCH ENDP

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
                                     