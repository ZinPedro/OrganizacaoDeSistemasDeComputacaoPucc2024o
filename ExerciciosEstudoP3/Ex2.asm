TITLE ex2
.MODEL SMALL
.STACK 100H

; MACROS para salvar e restaurar os registradores principais
PUSH_ALL MACRO
    PUSH AX             ; Salva o valor de AX na pilha
    PUSH BX             ; Salva o valor de BX na pilha
    PUSH CX             ; Salva o valor de CX na pilha
    PUSH DX             ; Salva o valor de DX na pilha
    PUSH SI             ; Salva o valor de SI na pilha
    PUSH DI             ; Salva o valor de DI na pilha
ENDM

POP_ALL MACRO
    POP DI              ; Restaura o valor de DI da pilha
    POP SI              ; Restaura o valor de SI da pilha
    POP DX              ; Restaura o valor de DX da pilha
    POP CX              ; Restaura o valor de CX da pilha
    POP BX              ; Restaura o valor de BX da pilha
    POP AX              ; Restaura o valor de AX da pilha
ENDM

; Macro para pular uma linha na tela
PulaLinha MACRO 
    PUSH_ALL            ; Salva todos os registradores antes de modificar
    MOV AH,02           ; Função de saída de caractere de `INT 21H`
    MOV DL,10           ; Código ASCII para salto de linha (newline)
    INT 21H             ; Interrupção para executar a função
    POP_ALL             ; Restaura os registradores para seu estado original
ENDM

; Macro para exibir uma mensagem
IMPRIMEMSG MACRO MSG
    PUSH_ALL            ; Salva todos os registradores
    MOV AH,09           ; Função de exibição de string de `INT 21H`
    LEA DX,MSG          ; Carrega o endereço da mensagem em DX
    INT 21H             ; Chama interrupção para exibir a string
    POP_ALL             ; Restaura os registradores
ENDM 

; Segmento de dados
.DATA
    MATRIZ DW 11,2,3,4
           DW 5,6,7,8
           DW 11,12,10,11
           DW 9,13,2,15

    MSG1 DB 'Maior: $'
    MSG2 DB 'Menor: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX
        
        XOR BX,BX
        XOR SI,SI 
        XOR DX,DX
        XOR AX,AX

        MOV DX, MATRIZ[BX][SI]
        MOV AX, MATRIZ[BX][SI]
        ADD SI,2

        MOV CX,15

        JMP COMPARA
        
        COMPARA:
            CMP DX,MATRIZ[BX][SI]
            JA MENOR 
            VOLTA_MENOR:
            CMP AX,MATRIZ[BX][SI]
            JB MAIOR
            VOLTA_MAIOR:

            CMP SI,6
            JE LINHA

            ADD SI,2
        LOOP COMPARA
            LINHA:
                ADD BX,8
                XOR SI,SI
            LOOP COMPARA
        JMP IMPRIME
        MENOR:
            MOV DX,MATRIZ[BX][SI]
            JMP VOLTA_MENOR
        ;

        MAIOR:
            MOV AX,MATRIZ[BX][SI]
            JMP VOLTA_MAIOR

        IMPRIME:
        PUSH DX
        IMPRIMEMSG MSG1

        MOV BX,10
        XOR CX,CX

        VERIFICADECIMAL:
            DIV BL 
            MOV BH,AL     
            MOV AL,AH
            XOR AH,AH 

            PUSH AX
            INC CX

            MOV AL,BH 
            OR AL,AL 
            JZ EXIT1
        JMP VERIFICADECIMAL
        EXIT1:
            MOV AH,02

        IMPRIMEDECIMAL:
            POP DX
            OR DL,30H
            INT 21H
        LOOP IMPRIMEDECIMAL

        PulaLinha
        
        POP DX
        IMPRIMEMSG MSG2
        OR DL,30H
        INT 21H


        MOV AH,4Ch
        INT 21H 
    MAIN ENDP 
END MAIN    