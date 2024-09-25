TITLE Caractere
.MODEL SMALL
.DATA
    MSG1 DB "Digite um caractere: $"
    MSG2 DB 10,13,"O caractere digitado foi: $"
.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    MOV AH,9
    LEA DX,MSG1
    INT 21h

    MOV AH,1
    INT 21h

    MOV BL,AL

    MOV AH,9
    LEA DX,MSG2
    INT 21h

    MOV AH,2
    MOV DL,BL
    INT 21h

    MOV AH,4Ch
    INT 21h

 MAIN ENDP
END MAIN
