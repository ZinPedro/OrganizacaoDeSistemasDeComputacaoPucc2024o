TITLE Multiplicação
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o dividendo: $'
    MSG2 DB 10,13,'Digite o divisor: $'
    MSG3 DB 10,13,'O quociente eh: $'
    MSG4 DB 10,13,'O resto eh: $'
    MSG5 DB 10,13, 'O caractere digitado nao eh um numero!$'
    MSG6 DB 10,13, 'Esta divisao eh indefinida!$'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        DIVIDENDO:
            MOV AH,09
            LEA DX,MSG1     ;IMPRIME MSG1
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
        DIVISOR:
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

        TEST CL,0FH      ;TESTA SE CL EH 0
        JZ ZERO

        MOV AH,09   
        LEA DX,MSG3     ; IMPRIME MSG3
        INT 21H

        MOV AH,02H      ;FUNÇÃO PARA IMPRIMIR CARACTERE DE DL
        
        AND BL,0FH      ;DEIXA BL, CL SÓ COM O NUMERO
        AND CL,0FH

        XOR DL,DL       ;ZERA DL

        DIVISAO:
            CMP BL,CL       ;VERIFICA SE BL É MENOR QUE CL, SE FOR, ENCERRA DIVISAO
            JB CONTINUA

            SUB BL,CL       ;SUBTRAI CL DE BL
            INC DL
            JMP DIVISAO
        ;
        CONTINUA:
            OR BL,30H       ;VOLTA BL E DL PARA O VALOR DE SEUS RESPECTIVOS CARACTERES NUMERICOS (ASCII)
            OR DL,30H

            INT 21H         ;IMPRIME DL NA TELA (QUOCIENTE)

            MOV AH,09
            LEA DX,MSG4     ;IMPRIME MSG4
            INT 21H

            MOV AH,02
            MOV DL,BL       ;MOVE BL PARA DL E IMPRIME DL (RESTO)
            INT 21H
           
            JMP EXIT    ;JUMP PARA O FINAL DO CODIGO
        ;

        ZERO:   ;SE O DIVISOR FOR 0, IMPRIME MSG6 ALERTANDO QUE A DIVISAO É INDEFINIDA
            MOV AH,09
            LEA DX, MSG6
            INT 21H
            JMP EXIT
        ;

        NNUMERO:    ;IMPRIME A MSG4 ALERTANDO NAO SER UM NUMERO E VOLTA O CODIGO PARA QUE O USUARIO DEGITE O NUMERO DE NOVO
            MOV AH,09
            LEA DX,MSG5
            INT 21H
            CMP BH,01H
            JE DIVISOR

            MOV AH,02
            MOV DL,10
            INT 21H
            JMP DIVIDENDO

        EXIT:       ;FIM DO CODIGO
            MOV AH,4Ch
            INT 21H
        ;
        MAIN ENDP
            END MAIN