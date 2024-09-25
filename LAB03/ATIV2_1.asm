TITLE Maiuscula
.MODEL SMALL
.STACK 100h
.DATA
    MSG1 DB "Digite uma letra minuscula:$"
    MSG2 DB 10,13,"A letra maiuscula correspondente eh:$"
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,9
        LEA DX,MSG1
        INT 21h

        MOV AH,1 ;GRAVA O VALOR DA TECLA DIGITADA EM AL
        INT 21h

        MOV BL,AL 

        SUB BL,20H ;SUBTRAI O VALOR 20(HEXADECIMAL) DE BL PARA QUE O VALOR RESULTANTE FIQUE EQUIVALENTE A MESMA LETRA POREM MAIUSCULA(DE ACORDO COM A TABELA ASCII)

        MOV AH,9
        LEA DX,MSG2
        INT 21h

        MOV AH,2
        MOV DL,BL ;IMPRIME O VALOR DE DL(VALOR DA TECLA DIGITADA ANTERIORMENTE)
        INT 21h

        MOV AH,4Ch
        INT 21h

    MAIN ENDP
END MAIN

