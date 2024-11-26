TITLE Entrada de Numeros 
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

ZeraVetor MACRO VETOR  
    PUSH_ALL 
    LEA DI, VETOR
    MOV AL,0
    MOV CX,101
    REP STOSB
    POP_ALL 
ENDM



; Segmento de dados
.DATA
    MSG1 DB 'Qual eh o seu nome?',10,13,'$'
    MSG2 DB 'Ola, $'


    V1 DB 101 DUP(0)
    V2 DB 101 DUP(?)

.CODE
    MAIN PROC
        MOV AX,@DATA 
        MOV DS,AX
        MOV ES,AX

        CALL PROC1
        CALL COPIA 
        PulaLinha
        ZeraVetor V1

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    PROC1 PROC 
        PUSH_ALL
        IMPRIMEMSG MSG1

        CLD
        LEA DI,V1
        MOV AH,01
        
        MOV CX,100

        LOOP_PROC1:
            INT 21H 

            CMP AL,13
            JE EXIT_PROC1

            STOSB
        LOOP LOOP_PROC1
        EXIT_PROC1:

        LEA SI,V1
        MOV AH,02

        IMPRIMEMSG MSG2

        LOOP2_PROC1:
            LODSB

            CMP AL,0 
            JE EXIT2_PROC1

            MOV DL,AL 
            INT 21H
        JMP LOOP2_PROC1
        EXIT2_PROC1:
        POP_ALL
        RET
    PROC1 ENDP   

    COPIA PROC  
        PUSH_ALL
        CLD   
        LEA SI,V1  
        LEA DI,V2   

        MOV CX,101

        REP MOVSB

        POP_ALL
        RET
    COPIA ENDP     

    COMPARA PROC 

    COMPARA ENDP
    
END MAIN