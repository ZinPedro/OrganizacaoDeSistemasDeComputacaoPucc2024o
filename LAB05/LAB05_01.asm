TITLE PROG LAB05_01
MODEL SMALL
.STACK 100H
.DATA
    LINHA DB 10,13,'$'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV CX, 50 ;adciona 50(decimal) ao Contador CX 

        FOR:  ;Bloco de looping que imprime 50 '*' na mesma linha
            MOV AH,02H
            MOV DL,'*'
            INT 21H

            DEC CX   ;} Decrementa 1 de CX
            JNZ FOR  ;} Volta para o FOR se CX for diferente de 0
        ;

        MOV AH,01H ;Espera o usuário apertar algo no teclado para dar continuidade
        INT 21H

        MOV CX,50 ;adciona 50(decimal) ao Contador CX 
        
        FOR2: ;Bloco de looping que imprime 50 '*' em linhas diferentes
            MOV AH,02H
            MOV DL,'*'
            INT 21H

            MOV AH,09H   ;função que pula linha
            LEA DX,LINHA
            INT 21H

            DEC CX     ;} Decrementa 1 de CX
            JNZ FOR2   ;} Volta para o FOR se CX for diferente de 0
        ;

        MOV AH, 4Ch
        INT 21H
    MAIN ENDP
        END MAIN
