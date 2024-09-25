TITLE Mensagens
.MODEL SMALL
.DATA
    MSG1 DB "Mensagem 1.$"
    MSG2 DB 10,13,"Mensagem 2.$"
.CODE
MAIN PROC
    MOV AX,@DATA ;Abre data em ax
    MOV DS,AX ;Abre data em ds, por meio do ax

        
    MOV AH,9 ;funçao 9(imprimeos caracteres de uma string) apontada por dx
    LEA DX,MSG1 ;move dx para o bit onde esta o primeiro comando/caractere da variavel MSG1 (joga DX pro offset de MSG1)
    INT 21h ;executa a funçao 9, lendo a partir da posiçao de dx ate achar o dolar

    MOV AH,9 ;funçao 9(imprimeos caracteres de uma string) apontada por dx
    LEA DX,MSG2 ;move dx para o bit onde esta o primeiro comando/caractere da variavel MSG2 (joga DX pro offset de MSG2)
    INT 21h ;executa a funçao 9, lendo a partir da posiçao de dx ate achar o dolar

    MOV AH,4Ch ;funçao que, ao terminar o codigo, nao deixa com que o prompt finalize
    INT 21h ;executa função 4Ch
 MAIN ENDP
END MAIN


