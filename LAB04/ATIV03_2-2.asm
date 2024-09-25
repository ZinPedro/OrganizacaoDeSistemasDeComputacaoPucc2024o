TITLE FunçaoCaractere
.MODEL SMALL
.STACK 100h
.DATA   
    MSG1 DB "Digite um caractere:$"
    MSG2 DB 10,13,"O caractere digitado foi:$"
    NUMERO DB 10,13,"O caractere digitado era um numero!$"
    LETRA DB 10,13,"O caractere digitado era uma letra!$"
    DESCONHECIDO DB 10,13,"O caractere digitado era um caracter desconhecido!$"
.CODE
    MAIN PROC
        ;define as string em DATA
        MOV AX,@DATA
        MOV DS,AX

        ;mostra MSG1 na tela
        MOV AH,9
        LEA DX,MSG1
        INT 21h

        ;espera uma tecla digitada e armazena o valor dela em AL
        MOV AH,1
        INT 21h

        ;copia o valor de AL em BL (valor da tecla digitada)
        MOV BL,AL

        ;mostra MSG2 na tela
        MOV AH,9
        LEA DX,MSG2
        INT 21h

        ;mostra a tecla referente ao valor de DL na tela (indicando qual tecla o usuario apertou)
        MOV AH,2
        MOV DL,BL
        INT 21h

        ;Compara o caractere em BL com o valor 48(código decimal da tabela ASCII do caractere "0") e se for menor manda para o rotulo NAOENUMERO
        CMP BL,48
            JB NAOENUMERO

        ;Compara o caractere em BL com o valor 57(código decimal da tabela ASCII do caractere "9") e se for maior manda para o rotulo NAOENUMERO
        CMP BL,57
            JA NAOENUMERO

        ;se chegou ate aqui, mostra a string NUMERO na tela indicando ser um numero
        MOV AH,9
        LEA DX,NUMERO
        INT 21h

        ;pula para o final do codigo
        JMP FIM

        ;depois de verificar que nao é um número, verifica se é uma letra maiuscula
        NAOENUMERO:
            ;Compara o caractere em BL com o valor 65(código decimal da tabela ASCII do caractere "A") e se for menor manda para o rotulo NAOELETRAMAIUSCULA
            CMP BL,65 
                JB NAOELETRAMAIUSCULA

            ;Compara o caractere em BL com o valor 90(código decimal da tabela ASCII do caractere "Z") e se for maior manda para o rotulo NAOELETRAMAIUSCULA
            CMP BL,90
                JA NAOELETRAMAIUSCULA

            ;se chegou ate aqui, mostra a string LETRA na tela indicando ser uma letra
            MOV AH,9
            LEA DX,LETRA
            INT 21h

            ;pula para o final do codigo
            JMP FIM
            
        ;depois de verificar que nao é um número e nem uma letra maiuscula, verifica se é uma letra minuscula
        NAOELETRAMAIUSCULA:
            ;Compara o caractere em BL com o valor 97(código decimal da tabela ASCII do caractere "a") e se for menor manda para o rotulo NAOELETRAMINUSCULA
            CMP BL,97
                JB NAOELETRAMINUSCULA

            ;Compara o caractere em BL com o valor 122(código decimal da tabela ASCII do caractere "z") e se for maior manda para o rotulo NAOELETRAMINUSCULA
            CMP BL,122
                JA NAOELETRAMINUSCULA

            ;se chegou ate aqui, mostra a string LETRA na tela indicando ser uma letra
            MOV AH,9
            LEA DX,LETRA
            INT 21h

            ;pula para o final do codigo
            JMP FIM

        ;depois de verificar que nao é um número, nao é uma letra maiuscula e nem uma letra minuscula, imprime a string DESCONHECIDO indicando ser um caracter desconhecido
        NAOELETRAMINUSCULA:
            MOV AH,9
            LEA DX,DESCONHECIDO
            INT 21h

        ;finaliza o codigo
        FIM:
            MOV AH,4Ch
            INT 21h
        
    MAIN ENDP
END MAIN
