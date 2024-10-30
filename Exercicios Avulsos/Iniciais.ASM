TITLE Iniciais Do Nome
.MODEL SMALL
.STACK 100H
.DATA 
    MSG1 DB 'Escreva seu nome:',10,13,'$'
    V1 DB 10 DUP (0)
    MSG2 DB 10,13,'Suas iniciais sao: $'
    V2 DB 10 DUP (0)
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        mov ah,09
        LEA DX,MSG1
        INT 21H

        MOV AH,01
        MOV CX,10
        FOR:
            INT 21H
            CMP AL,13
            JE EXITFOR
            MOV V1[SI],AL
            CMP AL,20H
            JE ESPAÇO
            CMP AL,'.'
            JE ESPAÇO
            INC SI
            LOOP FOR
            JMP EXITFOR
        ;
        ESPAÇO:
            INT 21H
            CMP AL,13
            JE EXITFOR
            MOV V1[SI],AL
            MOV V2[BX],AL
            INC BX
            INC SI
            LOOP FOR
        ;
        EXITFOR:
            MOV AH,09
            LEA DX,MSG2
            INT 21H

            MOV AH,02
            XOR BX,BX
            
            MOV DL,V1[BX]
            INT 21H

            FOR2:
                TEST V2[BX], 0FFH
                JZ EXIT
                MOV DL,V2[BX]
                INT 21H
                INC BX
                JMP FOR2
            ;
            EXIT:
                MOV AH,4Ch
                INT 21H
    MAIN ENDP
END MAIN