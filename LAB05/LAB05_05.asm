TITLE PROG SUM10N
MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite um numero (numeros restantes: $'
    MSG2 DB  ')',10,13,'$'
    MSG3 DB 10,13,'O caractere digitado nao e um numero!',10,13,'$'
    MSG4 DB 'O resultado foi: $'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV CX,5    ;Adciona 5 ao Contador CX
        OR BL,30H  ;Adciona 30H ao BL (valor referente ao numero 0 da tabela ASCII)

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

            MOV AH,01H  ;Espera o Usuario Digitar um numero e salva em DL
            INT 21H

            CMP AL,30H      ;Verifica se o caractere digitado nao e um numero (se for manda para NAONUMERO)
            JL NAONUMERO

            CMP AL,39H      ;Verifica se o caractere digitado nao e um numero (se for manda para NAONUMERO)
            JG NAONUMERO

            AND AL,0FH      ;zera os 4 primeiros bits de AL (subtrai os 30H de AL)
            ADD BL,AL       ;Soma BL com AL e guarda em BL

            MOV AH,02H      ;Função pula linha
            MOV DL,10
            INT 21H

            LOOP FOR        ;se o contador CX for 0, volta para FOR
            JMP EXIT        ;pula para o fim
        ;   
        NAONUMERO:      ;Exibe mensagem de erro, já que o usuario nao digitou um numero
            MOV AH,09H
            LEA DX,MSG3
            INT 21H

            JMP FOR     ;volta para o for
        ;
        EXIT:           
            MOV AH,09H      ;Imprime a MSG4
            LEA DX,MSG4
            INT 21H

            MOV AH,02H      ; Mostra o resultado da soma
            MOV DL,BL
            INT 21H

            MOV AH,4Ch      
            INT 21H
    MAIN ENDP
        END MAIN