TITLE ENTRADA DE BINARIOS
.MODEL SMALL
.STACK 100H
.DATA 
    MSG1 DB 'Digite o numero binario: $'
    MSG2 DB 10,13,'O numero binario digitado foi: $'
    MSG3 DB 10,13,'O caractere digitado nao eh permitido! (Digite apenas zeros e uns!)',10,13,'$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,09
        LEA DX,MSG1
        INT 21H

        OR CX,16
        MOV AH,01

        while1:
            INT 21H

            CMP AL,13
            JE exit_while
            CMP AL,8
            JE apagar

            CMP AL,30H 
            JB N_PERMITIDO
            CMP AL,31H
            JA N_PERMITIDO

            OR BL,AL
            ROL BX,1
            LOOP while1
        ; 
        exit_while:

        MOV AH,09
        LEA DX,MSG2
        INT 21H

        MOV AH,02
 
        MOV CX,16  

        XOR AL,AL 
        XOR DH,DH

        verificador:
            ROL BX,1
            TEST DL,1
            JNZ salva
            TEST BX,1
            JZ CONTA
            OR DL,1
            salva:
                LOOP verificador
                JMP exit_verificador
            CONTA:
                INC DH
                JMP salva
        exit_verificador:
        ;
 
        TEST DH,01H
        JNZ arruma
        CONTINUA: 

        MOV CX,16
        MOV DL,DH
        XOR DH,DH
        SUB CX,DX

        while2:
            TEST BX,01
            JZ zero
            MOV DL,31H 
            JMP voltar
            zero:
                MOV DL,30H
            ;
            voltar:
                INT 21H
                ROL BX,1
                LOOP while2
                TEST AL,01
                JNZ POP_
                JMP EXIT
        ;
        arruma:
            INC DH
            MOV CL,DH
            ROL BX,CL
            DEC DH
            JMP CONTINUA
        ;
 
        apagar:
            AND BL,0FEh
            ROR BX,1
            JMP while1
        ;

        N_PERMITIDO:
            PUSH CX

            MOV AH,09
            LEA DX,MSG3
            INT 21H

            MOV AH,09
            LEA DX,MSG1
            INT 21H

            MOV AH,2
            MOV CX,16 

            MOV AL,1
            JMP verificador
        ;

        POP_:
            POP CX
            JMP while1
        ;

        EXIT:
            MOV AH,4Ch
            INT 21H
        MAIN ENDP
            END MAIN





