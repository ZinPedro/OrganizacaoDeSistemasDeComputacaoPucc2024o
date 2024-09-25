TITLE While
.MODEL SMALL
.STACK 100H
.CODE
    MAIN PROC 
        MOV AH,01
        WHILE:
            INT 21H
        
            CMP AL,13
            JE EXITWHILE

            INC CL
            JMP WHILE
        ;
        EXITWHILE:
        MOV AH,02
        ASTERISC:
            MOV DL,42
            INT 21H

            LOOP ASTERISC
        ;
        MOV AH,4Ch
        INT 21H
    MAIN ENDP
END MAIN
