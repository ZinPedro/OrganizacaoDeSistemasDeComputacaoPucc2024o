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

; Segmento de dados
.DATA
    MSG1 DB 'Digite uma string?',10,13,'$' 
    MSG2 DB 'A string digitada foi: $'
    MSG3 DB 'A quantidade de "a" na string eh: $'

    IGUAIS DB 'As duas frases sao iguais!',10,13,'$'
    NAOIGUAIS DB 'As duas frases nao sao iguais!',10,13,'$'

    REFERENCIA DB 'teste para identificar se eh igual ' 

    V1 DB 101 DUP(0)
    V2 DB 101 DUP(?)

.CODE
    MAIN PROC
        MOV AX,@DATA 
        MOV DS,AX
        MOV ES,AX
  
        IMPRIMEMSG MSG1     ;Imprime MSG1
        CALL PROC1          ;Lê, armazena e imprime string 
        CALL COPIA          ;Copia vetor com string em outro vetor
        PulaLinha           ;pula linha
        CALL COMPARA        ;Compara string digitada com a sttring REFERENCIA
        IMPRIMEMSG MSG3     ;Imprime MSG3
        CALL LETRAA         ;Conta quantos 'a' foram digitados

        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    PROC1 PROC 
        PUSH_ALL 

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
        PUSH_ALL
        CLD 
        LEA SI,V1
        LEA DI,REFERENCIA

        MOV CX,34

        REP CMPSB
        JZ STRINGIGUAIS 

        IMPRIMEMSG NAOIGUAIS    
        JMP EXIT_COMPARA

        STRINGIGUAIS: 
        IMPRIMEMSG IGUAIS

        EXIT_COMPARA: 
        POP_ALL
        RET
    COMPARA ENDP
    
    LETRAA PROC
        PUSH_ALL

        CLD
        LEA DI,V1
        MOV AL,'a'
        MOV AH,02

        XOR DX,DX
        MOV CX,101

        VOLTA: 
            SCASB 
            JNZ SKIP    
            ADD DL,1
            SKIP:
        LOOP VOLTA

        CMP DL,10
        JB UMDIGITO

        PUSH AX
        PUSH DX

        MOV BL,10 
        XOR CX,CX
        XOR AH,AH 

        VERIFICADECIMAL:
            MOV AL,DL
 
            DIV BL
 
            MOV DL,AL
            MOV AL,AH
            XOR AH,AH
            PUSH AX  

            INC CX

            CMP DL,0
            JE IMPRIMEDECIMAL

        JMP VERIFICADECIMAL  

        IMPRIMEDECIMAL:
            MOV AH,2
            LOOP_IMPRIMEDECIMAL:
                POP DX 
                OR DL,30H
                INT 21H
            LOOP LOOP_IMPRIMEDECIMAL 

        POP DX 
        POP AX 

        JMP LETRAA_EXIT
        UMDIGITO:
            OR DL,30H   
            INT 21H 

        LETRAA_EXIT:
        POP_ALL
        RET
    LETRAA ENDP    
END MAIN