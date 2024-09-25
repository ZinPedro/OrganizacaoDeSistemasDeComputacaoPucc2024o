TITLE PROG LAB05_02
MODEL SMALL
.STACK 100H
.DATA
    LINHA DB 10,13,'$'
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        MOV CX, 50  ;adciona 50(decimal) ao Contador CX 

        FOR: ;Bloco de looping que imprime 50 '*' na mesma linha
            MOV AH,02H
            MOV DL,'*'
            INT 21H
            LOOP FOR ;Instrução que representa DEC CX + JNZ FOR
        ;

        MOV AH,01H ;Espera o usuário apertar algo no teclado para dar continuidade
        INT 21H    

        MOV CX,50 ;adciona 50(decimal) ao Contador CX 
        
        FOR2:   ;Bloco de looping que imprime 50 '*' em linhas diferentes
            MOV AH,02H
            MOV DL,'*'
            INT 21H

            MOV AH,09H  ;função que pula linha
            LEA DX,LINHA 
            INT 21H

            LOOP FOR2   ;Instrução que representa DEC CX + JNZ FOR2
        ;

        MOV AH, 4Ch
        INT 21H
    MAIN ENDP
        END MAIN
