TITLE Repeat
.MODEL SMALL
.STACK 100H
.CODE
    MAIN PROC 
        MOV AH,01
        REPEAT:
            INT 21H
            INC CL

            CMP AL,13
            JNE REPEAT
        ;
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
