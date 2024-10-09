TITLE ENTRADA DE_BINARIOS
.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Digite o numero hexadecimal (de 0 a F) : $'
    MSG2 DB 10,13,'O numero digitado foi: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,9
        LEA DX,MSG1                 ;IMPRIME MSG1
        INT 21H

        MOV AH,01                   ;MOVE PARA FUNÇÃO QUE DETECTA CARACTERE DIGITADO E SALVA EM AL
        MOV CX,4                    ;COLOCA O VALOR 4 EM CX PARA REALIZAR O LOOP 4 VEZES


        WHILE_:
            INT 21H                 ;DETECTA CARACTERE DIGITADO E SALVA EM AL

            CMP AL,13               ;DETECTA SE A TECLA DIGITADA FOI O ENTER, SE SIM, SAI DO LOOP
            JE EXIT_WHILE
            ROL BX,4                ;ROLA OS BITS DE BX QUATRO CASAS PARA ESQUERDA
            CMP AL,66H              ;COMPARA O VALOR DE AL COM 66H, SE FOR MAIOR, O USUARIO DIGITOU UMA LETRA MINUSCULA
            JG LETRA_MINUSCULA
            CMP AL,39H              ;COMPARA O VALOR DE AL COM 39H, SE FOR MAIOR, O USUARIO DIGITOU UMA LETRA MAIUSCULA. SE NAO, DIGITOU UM NUMERO.
            JG LETRA_MAIUSCULA
            AND AL,0FH              ;ZERA OS 4 PRIMEIROS BITS DE AL, PARA FILTRAR O NUMERO, DE CARACTERE NUMERICO PARA NUMERO
            JMP SALTO1              ;PULA PARA SALTO1
            LETRA_MINUSCULA:
                SUB AL,87           ;SUBTRAI 87 DE AL, PARA FILTRA A LETRA MINUSCULA, DO CARACTER MINUSCULO PARA O VALOR HEXADECIMAL.
                JMP SALTO1          ;PULA PARA SALTO1
            LETRA_MAIUSCULA:
                SUB AL,55           ;SUBTRAI 55 DE AL, PARA FILTRA A LETRA MAIUSCULA, DO CARACTER MAIUSCULO PARA O VALOR HEXADECIMAL.
        SALTO1:
            OR BL,AL                ;COLOCA O VALOR DE AL EM BL
            LOOP WHILE_             ;VOLTA PARA WHILE_ ATE QUE CX SEJA 0
        ;
        EXIT_WHILE:
            MOV AH,09               
            LEA DX,MSG2             ;IMPRIME MSG2
            INT 21H
            
            MOV AH,02
            MOV CX,4
        IMPRIME:
            MOV DL,BH
            SHR DL,4
            CMP DL,09H
            JG LETRA_IMPRIME
            OR DL,30H
            JMP SALTO2
            LETRA_IMPRIME:
            ADD DL,55
        SALTO2:
            INT 21H
            ROL BX,4
            LOOP IMPRIME
        ;
        MOV AH,4Ch
        INT 21H
        MAIN ENDP
            END MAIN