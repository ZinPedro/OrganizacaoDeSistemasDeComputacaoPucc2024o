TITLE PROG LAB05_04
MODEL SMALL
.STACK 100H
.CODE
    MAIN PROC 
        MOV CX,26   ;Adciona 26 ao contador (numero de caracteres do alfabeto)
        MOV BL,4    ;Adciona 4 a BL (contador para imprimir 4 por linha)
        MOV BH,10   ;Adciona 10 a BH(Valor referente ao Carriage Return na tabela ASCII usado para pular a linha)

        MOV AH,02H  ;chama a função que imprime o caractere referente ao valor de DL
        MOV DL,61H  ;Adciona 61H (valor referente ao 'a' na tabela ASCII) em DL
                
        MINUSCULAS: ;Função Para imprimir 4 letras minusculas por linha em ordem alfabetica
            INT 21H   ;Executa função 02H

            INC DL  ;DL = DL+1

            DEC BL  ;BL=BL-1
            JNZ LINHA    ;Se BL nao for 0, pula para LINHA

            XCHG BH,DL  ;Inverte o valor de BH e DL para armazenar o valor da letra referente em BL e usar DL para pular linha
            INT 21H     ;pula linha
            XCHG BH,DL  ; volta os valores de DL e BH
            MOV BL,4    ;Volta BL para 4 para imprimir mais 4 letras na mesma linha
        ;

        LINHA:  ;Volta para MINUSCULAS se CX for diferente de 0
            LOOP MINUSCULAS
        ; Quando CX for 0, Acaba o codigo
            MOV AH,4Ch
            INT 21H
    MAIN ENDP
        END MAIN