TITLE ex5
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

    LINHA1 DB 'Soma da linha $'
    LINHA2 DB ' = $'

    COLUNA1 DB 'Soma da coluna $'
    COLUNA2 DB ' = $'
    
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX

        MOV AH,02

        IMPRIMEMSG LINHA1
        MOV DL,31H
        INT 21H
        IMPRIMEMSG LINHA2
        MOV BX,0
        CALL SOMALINHA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG LINHA1
        MOV DL,32H
        INT 21H
        IMPRIMEMSG LINHA2
        MOV BX,8
        CALL SOMALINHA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG LINHA1
        MOV DL,33H
        INT 21H
        IMPRIMEMSG LINHA2
        MOV BX,16
        CALL SOMALINHA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG LINHA1
        MOV DL,34H
        INT 21H
        IMPRIMEMSG LINHA2
        MOV BX,24
        CALL SOMALINHA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG COLUNA1
        MOV DL,31H
        INT 21H
        IMPRIMEMSG COLUNA2
        MOV SI,0
        CALL SOMACOLUNA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG COLUNA1
        MOV DL,32H
        INT 21H
        IMPRIMEMSG COLUNA2
        MOV SI,2
        CALL SOMACOLUNA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG COLUNA1
        MOV DL,33H
        INT 21H
        IMPRIMEMSG COLUNA2
        MOV SI,4
        CALL SOMACOLUNA
        CALL IMPRIMEDECIMAL

        PulaLinha

        IMPRIMEMSG COLUNA1
        MOV DL,34H
        INT 21H
        IMPRIMEMSG COLUNA2
        MOV SI,6
        CALL SOMACOLUNA
        CALL IMPRIMEDECIMAL

        MOV AH,4Ch
        INT 21H 
    MAIN ENDP

    SOMALINHA PROC
        MOV CX,4
        XOR SI,SI
        XOR DX,DX

        SOMA_LINHA:
            ADD DX,MATRIZ [BX][SI]
            ADD SI,2
        LOOP SOMA_LINHA
        RET
    SOMALINHA ENDP

    SOMACOLUNA PROC
        MOV CX,4
        XOR BX,BX
        XOR DX,DX

        SOMA_COLUNA:
            ADD DX,MATRIZ [BX][SI]
            ADD BX,8
        LOOP SOMA_COLUNA
        RET
    SOMACOLUNA ENDP

    IMPRIMEDECIMAL PROC
        PUSH_ALL
            MOV BX,10
            MOV AX,DX
            XOR CX,CX
            VERIFICA_DECIMAL:
                DIV BL 

                MOV BH,AL
                MOV AL,AH
                XOR AH,AH
                PUSH AX 
                MOV AL,BH
                INC CX

                OR AL,AL
                JZ EXIT_DECIMAL
            JMP VERIFICA_DECIMAL
            EXIT_DECIMAL:
                MOV AH,02

            IMPRIME_DECIMAL:
                POP DX
                OR DL,30H
                INT 21H     
            LOOP IMPRIME_DECIMAL
        POP_ALL
        RET
    IMPRIMEDECIMAL ENDP   


END MAIN
