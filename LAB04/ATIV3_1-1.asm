TITLE Numero
.MODEL SMALL
.STACK 100h
.DATA
    MSG1 DB "Digite um caractere:$"
    SIM DB 10,13,"O caractere digitado e um numero!$"
    NAO DB 10,13,"O caractere digitado nao e um numero!$"
.CODE
    MAIN PROC
        ;Permite os acessos as variaveis definidas no .DATA
        MOV AX,@DATA
        MOV DS,AX

        ;exibe a string MSG1 na tela
        MOV AH,9
        MOV DX,OFFSET MSG1
        INT 21h

        ;Lê um caractere do teclado e salva em AL
        MOV AH,1
        INT 21h

        ;Copia o caractere lido em BL
        MOV BL,AL

        ;Compara o caractere em BL com o valor 48(código da tabela ASCII do caractere "0")
        CMP BL,48
            ;Se o caractere em BL for menor que 48 ("0"), salta para o rotulo NAOENUMERO
            JB NAOENUMERO
        
        ;Compara o caractere em BL com o valor 57(código da tabela ASCII do caractere "9")
        CMP BL,57
            ;Se o caractere em BL for maior que 57 ("9"), salta para o rotulo NAOENUMERO
            JA NAOENUMERO

        ;Se chegou até aqui, mostra na tela o conteudo da string SIM (é um numero)
        MOV AH,9
        MOV DX,OFFSET SIM
        INT 21h

        ;Salta para o rotulo FIM
        JMP FIM

        ;Define Rotulo NAOENUMERO
        NAOENUMERO:
            ;Exibe na tela a string NAO (nao e um numero)
            MOV AH,9
            MOV DX,OFFSET NAO
            INT 21h

        ;Define rotulo FIM
        FIM:
            MOV AH,4Ch
            INT 21h
    MAIN ENDP
END MAIN
;PROGRAMA QUE DEFINE SE O CARACTERE DIGITADO PELO USUARIO E UM NUMERO OU NAO POR MEIO DE COMPARAÇÕES COM OS VALORES DE 0 E 9 NOS QUAIS SE FOR MENOR QUE 0 OU MAIOR QUE NOVE O CARACTERE NAO E UM NUMERO, CASO CONTRARIO E UM NUMERO.



