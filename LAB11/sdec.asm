.model SMALL
.code
main PROC 
     

        MOV BX,10
        MOV CX,4
        MOV AH,01 
        INT 21H

        CMP AL,2DH
        JNE POSITIVO  
        MOV AX,1
        PUSH AX 
POSITIVO:
        XOR DX,DX 
        CMP AL,13 
        JE EXIT1_DECI
        AND AL,0FH
        MOV DL,AL
        DEC CX
   
   
        LOOP_DECI: 
            MOV AH,01 
            INT 21H 
            CMP AL,13 
            JE EXIT1_DECI 
            CMP AL,30H 
            JB NPERMITIDODECI
            CMP AL,39H
            JA NPERMITIDODECI
            AND AL,0FH
            XOR AH,AH  
            XCHG DX,AX 
            MUL BL 
            ADD DX,AX
        LOOP LOOP_DECI
        JMP EXIT1_DECI
        
            JMP LOOP_DECI

        NEGAR:
            NEG BX 
            JMP EXIT2_DECI

        NPERMITIDODECI:
         
            JMP LOOP_DECI 

        EXIT1_DECI:    
            MOV BX,DX
            POP AX 
            OR AX,AX  
            JNZ NEGAR

        EXIT2_DECI:    


;*********************

           XOR CX,CX
            TEST BX,BX
            JNS NNEG
            MOV AH,02
            MOV DL,'-'
            INT 21H

            NEG BX
        NNEG:
        MOV AX,BX
        MOV BX,10 
        IMPRIMEDECIMAL: 
            XOR DX,DX
            DIV BX  
            PUSH DX 
            INC CX
            TEST AX,AX
            JZ EXITLOOP  
            JMP IMPRIMEDECIMAL
        ;

        EXITLOOP:
        MOV AH,02
        IMPRIMEDECIMAL2: 
        POP DX 
        OR DL,30H
        INT 21H
             
        LOOP IMPRIMEDECIMAL2
mov ah,4Ch
int 21h
  main ENDP    
  end main