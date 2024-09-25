TITLE PROG LAB05_03
MODEL SMALL
.STACK 100H
.CODE
    MAIN PROC
        MOV CX,26    ;Adciona 26 ao contador (numero de caracteres do alfabeto)

        MOV AH,02H  ;chama a função que imprime o caractere referente ao valor de DL
        MOV DL,41H  ;Adciona 46H (valor referente ao 'A' na tabela ASCII) em DL

        MAIUSCULAS:
            INT 21H ;Executa função 02H

            INC DL ;DL = DL+1
            LOOP MAIUSCULAS ;CX = CX-1 e volta para MAIUSCULAS se CX for diferente de 0
        ;

        MOV CX,26   ;Adciona 26 ao contador (numero de caracteres do alfabeto)
        MOV DL,61H  ;Adciona 61H (valor referente ao 'a' na tabela ASCII) em DL

        MINUSCULAS:
            INT 21H ;Executa função 02H

            INC DL  ;DL = DL+1
            LOOP MINUSCULAS ;CX = CX-1 e volta para MINUSCULAS se CX for diferente de 0
        ;

        MOV AH,4Ch
        INT 21H
    MAIN ENDP
        END MAIN


            
