TITLE PROGRAMA EXEMPLO PARA MANIPULAÇÃO DE VETORES USANDO BX (B)
.MODEL SMALL
.STACK 100H
.DATA
    VETOR DB 1, 1, 1, 2, 2, 2
.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS,AX

        XOR DL, DL      ;Zera DL
        MOV CX,6        ;Adciona 6 ao contador para o loop
        XOR BX, BX      ;le os algarismos do vetor em BX

        MOV AH, 02      ;FUNÇÃO PARA IMPRIMIR CARACTERE DE DL

        VOLTA:
            MOV DL, VETOR[BX]
            INC BX 
            ADD DL, 30H         ;Imprime caractere por caractere do VETOR
            INT 21H
        LOOP VOLTA

        MOV AH,4CH
        INT 21H ;saida para o DOS
    MAIN ENDP
END MAIN
