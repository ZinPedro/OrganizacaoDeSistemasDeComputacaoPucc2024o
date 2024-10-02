TITLE Multiplicação
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o multiplicando: $'
    MSG2 DB 10,13,'Digite o multiplicador: $'
    MSG3 DB 10,13,'O produto eh: $'
    MSG4 DB 10,13, 'O caractere digitado nao eh um nuamero!$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MULTIPLICANDO:
            MOV AH,09
            LEA DX,MSG1 ;IMPRIME MSG1
            INT 21H

            MOV AH,01       ;DETECTA CARACTERE DIGITADO E SALVA EM AL
            INT 21H
            CMP AL,39H
            JA NNUMERO
            CMP AL,30H      ;VERIFICA SE EH NUMERO
            JB NNUMERO
            MOV BL,AL       ;MOVE O VALOR DE AL PARA BL (CARACTERE DIGITADO)
            OR BH,01H       ;VERIFICADOR PARA NNUMERO
        ;
        MULTIPLICADOR:
            MOV AH,09
            LEA DX,MSG2     ; IMPRIME MSG2
            INT 21H

            MOV AH,01       ;DETECTA CARACTERE DIGITADO E SALVA EM AL
            INT 21H
            CMP AL,39H
            JA NNUMERO      ;VERIFICA SE EH NUMERO
            CMP AL,30H
            JB NNUMERO
            MOV CL,AL       ;MOVE O VALOR DE AL PARA CL (CARACTERE DIGITADO)
        ;
        MOV AH,09
        LEA DX,MSG3         ; IMPRIME MSG3
        INT 21H

        MOV AH,02H      ;FUNÇÃO PARA IMPRIMIR CARACTERE DE DL

        MOV DL,30H      ;POE 30H EM DL 

        TEST CL,0FH     ;TESTA SE CL EH 0
        JZ ZERO

        CMP CL,31H      ;TESTA SE CL EH 1
        JE UM
        
        AND BL,0FH
        AND CL,0FH      ;DEIXA BL, CL SÓ COM O NUMERO
        XOR CH,CH       ;ZERA CH (PARA USO DO LOOPING EM CASO DE ALGUM VALOR EM CH)

        

        MULTIPLICACAO:
            ADD DL,BL
            LOOP MULTIPLICACAO     ;SOMA BL EM DL ATE QUE CL SEJA IGUAL A 0
            INT 21H         ;IMPRIME RESULTADO (DL)

            JMP EXIT        ;JUMP PARA O FINAL DO CODIGO
        ;

        UM: ;MULTIPLICAÇAO POR 1
            MOV DL,BL       ; POE O VALOR DE BL EM DL
            INT 21H         ;IMPRIME RESULTADO (DL)
            JMP EXIT        ;JUMP PARA O FINAL DO CODIGO
        ;

        ZERO:   ;MULTIPLICAÇAO POR 0
            INT 21H     ;IMPRIME RESULTADO (DL) (NESSE CASO 0)
            JMP EXIT    ;JUMP PARA O FINAL DO CODIGO
        ;

        NNUMERO: ;IMPRIME A MSG4 ALERTANDO NAO SER UM NUMERO E VOLTA O CODIGO PARA QUE O USUARIO DEGITE O NUMERO DE NOVO
            MOV AH,09
            LEA DX,MSG4
            INT 21H
            CMP BH,01H
            JE MULTIPLICADOR

            MOV AH,02
            MOV DL,10
            INT 21H
            JMP MULTIPLICANDO

        EXIT:       ;FIM DO CODIGO
            MOV AH,4Ch
            INT 21H
        ;
        MAIN ENDP
            END MAIN



        
            
