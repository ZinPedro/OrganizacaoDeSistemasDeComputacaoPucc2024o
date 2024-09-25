TITLE Eco
.MODEL SMALL
.CODE
MAIN PROC 
    MOV AH,2 ;função 2(imprime o caracter armazenado em DL)
    MOV DL,"?" ;armazena o caractere (?) em dl
    INT 21h ;executa a função 2 imprimindo "?"

    MOV AH,1 ;funçao 1 (espera o clique de uma tecla do teclado)
    INT 21h ;executa funçao 1

    MOV BL,AL ; move o valor de al para bl (valor da tecla clicada)

    MOV AH,2  ;função 2(imprime o caracter armazenado em DL)
    MOV DL,10 ;armazena o caractere (10) em dl (line feed)
    INT 21h ;executa a função 2 descendo de linha

    MOV AH,2 ;função 2(imprime o caracter armazenado em DL)
    MOV DL,13 ;armazena o caractere (13) em dl (carrage return)
    INT 21h ;executa a função 2 voltando para o inicio da linha

    MOV AH,2 ;função 2(imprime o caracter armazenado em DL)
    MOV DL,BL ;poe o valor de bl em dl(valor da tecla clicada anteriormente)
    INT 21h ;;executa a função 2

    MOV AH,4Ch  ;funçao que, ao terminar o codigo, nao deixa com que o prompt finalize
    INT 21h ;executa função 4Ch
 MAIN ENDP
END MAIN

