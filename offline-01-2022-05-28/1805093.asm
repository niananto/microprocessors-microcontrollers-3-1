.MODEL SMALL 
.STACK 100H 
.DATA

TEMP1 DW ?
TEMP2 DW ?
TEMPB DB ?
COUNT DW ?
LEN DW ?
N DW ?
ISNEGATIVE DB ?
CR EQU 0DH
LF EQU 0AH

NL DB CR,LF,'$'
MSG1 DB 'INSERT HOW MANY NUMBERS YOU WANT IN THE ARRAY?',CR,LF,'$'
MSG2 DB CR,LF,'HERE IS THE SORTED ARRAY',CR,LF,'$'
MSG3 DB CR,LF,'INSERT A NUMBER TO SEARCH IN THE ARRAY',CR,LF,'$'
MSG4 DB CR,LF,'FOUND IN THE INDEX $'
MSG5 DB CR,LF,'NOT FOUND',CR,LF,'$'

ARRAY DW 100 DUP(?)

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
    
    MOV AH, 9
    LEA DX, NL
    INT 21H               
    
    ;3. Take n integers from the user.            
    XOR BX, BX        
    ALL_INPUT:
        CALL MULTI_CHAR_INPUT ;INPUT SET IN N           
        
        MOV AH, 2
        MOV DL, LF
        INT 21H
        
	    MOV AX, N
	    MOV ARRAY[BX], AX
	    ADD BX, 2
    LOOP ALL_INPUT        
    
    ;4. Sort them using insertion sort. 
    CALL INSERTION_SORT ;CHANGE THE ARRAY
    
    ;5. Display the sorted array. 
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    MOV AH, 2
    MOV DL, 91  ;[
    INT 21H
    MOV DL, 32
    INT 21H
    
    XOR BX, BX
    MOV CX, LEN
    
    ALL_OUTPUT:
    	MOV AX, ARRAY[BX]
    	MOV N, AX
    	MOV COUNT, 0
        
        CALL MULTI_CHAR_OUTPUT
        	
        MOV AH, 2
        MOV DL, 32
        INT 21H
    	ADD BX, 2
    LOOP ALL_OUTPUT 
    
    MOV AH, 2
    MOV DL, 93 ;]
    INT 21H
    
    ;6. Take an integer x from the user.
    STEP_06:
     
    MOV AH, 9
    LEA DX, MSG3
    INT 21H
    
    CALL MULTI_CHAR_INPUT ;INPUT SET IN N  
    
    ;7. Use binary search to find x’s index in the sorted array. Display the index if found, otherwise
	;print ‘NOT FOUND’. 
    CALL BINARY_SEARCH ;SEARCH IN ARRAY FOR N
    
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
 
        MOV TEMP1, AX
        
        ; DX = DX * 10 + TEMP1
        MOV AX, 10
        MUL DX
        ADD AX, TEMP1
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
	CMP N, 0
	JL NEGATIVE_OUTPUT
	
	MOV COUNT, 0
    MOV AX, N
	
	SINGLE_OUTPUT:
        MOV DL, 10
        DIV DL
        
        MOV TEMPB, AL ;RESULT
		MOV DL, AH
		AND DX, 00FFH
		PUSH DX
		INC COUNT  
        
        CMP TEMPB, 0
        JZ END_SINGLE_OUTPUT
        
        MOV AL, TEMPB
        AND AX, 00FFH
        JMP SINGLE_OUTPUT

    END_SINGLE_OUTPUT:
		MOV TEMP1, CX
		MOV CX, COUNT
		MOV AH, 2
		
		PRINT_OUTPUT:
			POP DX
			ADD DL, 48
			INT 21H
		LOOP PRINT_OUTPUT       
    
    	MOV CX, TEMP1
        RET
   	NEGATIVE_OUTPUT:
   		MOV AH, 2
   		MOV DL, 45
   		INT 21H
   		
   		MOV COUNT, 0
   		NEG N
   		MOV AX, N
   		JMP SINGLE_OUTPUT
   	
    RET    	
MULTI_CHAR_OUTPUT ENDP

INSERTION_SORT PROC
	MOV CX, LEN
    XOR BX, BX
    
    SORT:
	    MOV TEMP1, BX
	    
        BACKTRACK:
        	CMP BX, 0
	        JE END_BACKTRACK
	        
	        MOV AX, ARRAY[BX-2]
	        MOV DX, ARRAY[BX]
	        CMP AX, DX
	        JNG END_BACKTRACK
	        
	        ;SWAP ARRAY[BX] AND ARRAY[BX-2]
        	MOV ARRAY[BX-2], DX
        	MOV ARRAY[BX], AX
        	
        	SUB BX, 2
        	JMP BACKTRACK    	
        	                     
        END_BACKTRACK:
	        
	    MOV BX, TEMP1    
	    ADD BX, 2
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
	    MOV AX, MID
    	MOV BX, 2
    	DIV BL
	    MOV N, AX
		INC N
		
        CALL MULTI_CHAR_OUTPUT       
		
		;8. For another search in the same array go to Step 6.
	    JMP STEP_06
    
    END_UNSUCCESSFUL_SEARCH:
        LEA DX, MSG5
        MOV AH, 9
        INT 21H
        ;8. For another search in the same array go to Step 6.
        JMP STEP_06

BINARY_SEARCH ENDP

END MAIN 
                                     