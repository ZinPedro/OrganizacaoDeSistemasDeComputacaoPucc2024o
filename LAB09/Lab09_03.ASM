TITLE Programa de inversão de vetores
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite um numero (numeros restantes: $'
    MSG2 DB  ')',10,13,'$'
    MSG3 DB 10,13,'O caractere digitado nao e um numero!',10,13,'$'
    MSG4 DB 'Resultado: $'
    VETOR DB  7 DUP (0)
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV CX,7        ;move 7 para o contador para o FOR3
        CALL LER

        MOV DI,6        ;Zera DI
        MOV CX,3        ;move 3 para o contador para o FOR3
        CALL INVERTER

        
        MOV AH,9
        LEA DX,MSG4     ;Imprime a MSG4
        INT 21H

        
        MOV CX,7        ;move 7 para o contador para o FOR3
        CALL IMPRIMIR

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    LER PROC 
              ;adciona 7 ao contador para o FOR

        FOR:
            MOV AH,09H  ;Imprime a MSG1
            LEA DX,MSG1
            INT 21H

            MOV AH,02H  ;Imprime o número de números que faltam para o usuario digitar
            MOV DL,CL
            OR DL,30H
            INT 21H

            MOV AH,09H  ;Imprime a MSG2
            LEA DX,MSG2
            INT 21H

            MOV AH,01H  ;Espera o Usuario Digitar um numero e salva em AL
            INT 21H

            CMP AL,30H      ;Verifica se o caractere digitado nao e um numero (se for manda para NAONUMERO)
            JL NAONUMERO

            CMP AL,39H      ;Verifica se o caractere digitado nao e um numero (se for manda para NAONUMERO)
            JG NAONUMERO

            AND AL,0FH      ;zera os 4 primeiros bits de AL (subtrai os 30H de AL)
            MOV VETOR[SI],AL    ;coloca o numero referente a tecla digitada no vetor
            INC SI          ;decrementa SI

            MOV AH,02H      ;Função pula linha
            MOV DL,10       
            INT 21H

            LOOP FOR        ;se o contador CX for 0, volta para FOR
            RET
        ;
        NAONUMERO:      ;Exibe mensagem de erro, já que o usuario nao digitou um numero
            MOV AH,09H
            LEA DX,MSG3     ;imprime a MSG3
            INT 21H

            JMP FOR     ;volta para o for
        ;
    LER ENDP

    INVERTER PROC 
        XOR BX,BX       ;Zera BX
        
        FOR2:
            MOV AL,VETOR[BX]        
            XCHG AL,VETOR[DI]
            MOV VETOR[BX],AL        ;inverte o vetor
            INC BX
            DEC DI
            LOOP FOR2
            RET
        ;
    INVERTER ENDP

    IMPRIMIR PROC
        XOR SI,SI       ;Zera SI

        MOV AH,2        ;FUNÇÃO PARA IMPRIMIR CARACTERE DE DL

        FOR3:
            MOV DL,VETOR[SI]    ;coloca o nummero do vetor referente a SI em DL
            INC SI              ;incrementa SI
            OR DL,30H           ;adciona 30h no numero para virar caractere numerico
            INT 21H             ;imprime

            LOOP FOR3           
        ;
        RET
    IMPRIMIR ENDP
END MAIN
