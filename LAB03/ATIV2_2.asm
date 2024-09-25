TITLE SOMA
.MODEL SMALL
.STACK 100h
.DATA
    MSG1 DB "Digite um primeiro numero:$"
    MSG2 DB 10,13,"Digite um segundo numero:$"
    MSG3 DB 10,13,"A soma dos dois numeros eh:$"
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

        MOV AH,9
        LEA DX,MSG2
        INT 21h

        MOV AH,1
        INT 21h

        SUB AL,30H ;SUBTRAI O VALOR 30(HEXADECIMAL) DE AL PARA QUE A SOMA POSTERIOR DE CERTO (DE ACORDO COM A TABELA ASCII)
        ADD BL,AL ;SOMA O VALOR DE BL (PRIMEIRO NUMERO) COM O VALOR "FILTRADO" DE AL

        MOV AH,9
        LEA DX,MSG3
        INT 21h

        MOV AH,2
        MOV DL,BL ;IMPRIME O VALOR DE DL(SOMA DOS DOIS NUMEROS DIGITADOS)
        INT 21h

        MOV AH,4Ch
        INT 21h

    MAIN ENDP
END MAIN

