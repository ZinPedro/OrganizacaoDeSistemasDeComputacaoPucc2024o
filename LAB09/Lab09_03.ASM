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

        XOR DL,DL       ;zera DL   
        MOV SI,6        ;coloca SI indicando a ultima posição do vetor
        MOV CX,7        ;adciona 7 ao contador para o FOR

        FOR:
            MOV AH,09H  ;Imprime a MSG1
            LEA DX,MSG1
            INT 21H

            MOV AH,02H ;Imprime o número de números que faltam para o usuario digitar
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
            DEC SI          ;decrementa SI

            MOV AH,02H      ;Função pula linha
            MOV DL,10       
            INT 21H

            LOOP FOR        ;se o contador CX for 0, volta para FOR
            JMP IMPRIME     ;pula para a impressão do vetor
        ;
        NAONUMERO:      ;Exibe mensagem de erro, já que o usuario nao digitou um numero
            MOV AH,09H
            LEA DX,MSG3     ;imprime a MSG3
            INT 21H

            JMP FOR     ;volta para o for
        ;
        IMPRIME: 

        MOV AH,9
        LEA DX,MSG4     ;Imprime a MSG4
        INT 21H

        MOV CX,7        ;adciona 7 ao contador para o FOR2
        XOR SI,SI       ;Zera SI

        MOV AH,2        ;FUNÇÃO PARA IMPRIMIR CARACTERE DE DL

        FOR2:
            MOV DL,VETOR[SI]    ;coloca o nummero do vetor referente a SI em DL
            INC SI              ;incrementa SI
            OR DL,30H           ;adciona 30h no numero para virar caractere numerico
            INT 21H             ;imprime

            LOOP FOR2           
        ;

        MOV AH,4Ch      ;Finaliza o codigo
        INT 21H
    MAIN ENDP
END MAIN



