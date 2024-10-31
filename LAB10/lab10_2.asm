TITLE Iniciais Do Nome
.MODEL SMALL
.STACK 100H

ESPAÇO MACRO 
    PUSH AX
    PUSH DX
    MOV AH,02 
    MOV DL,32
    INT 21H
    POP DX 
    POP AX
ENDM   

PulaLinha MACRO 
    PUSH AX
    PUSH DX
    MOV AH,02 
    MOV DL,10
    INT 21H
    POP DX
    POP AX
ENDM

MENSAGEM MACRO
    PUSH AX
    PUSH DX
    PUSH BX

    MOV AH,09
    LEA DX,MSG1
    INT 21H

    MOV AX,BX
    MOV BL,4

    DIV BL

    MOV DL,AL
    MOV AH,02
    ADD DL,31H
    INT 21H

    MOV AH,09
    LEA DX,MSG2
    INT 21H

    MOV AH,02   
    MOV DX,SI
    ADD DL,31H
    INT 21H

    MOV AH,09
    LEA DX,MSG3
    INT 21H

    POP BX
    POP DX
    POP AX
ENDM

.DATA 
    MATRIZ DB 4 DUP(4 DUP(0)),'$'
    MSG1 DB 'Digite o numero da Matriz (linha: $'
    MSG2 DB ', coluna: $'
    MSG3 DB '):',10,13,'$'
    NPERM DB 'Este numero nao eh permitido!',10,13,'$'
    SOMAMSG DB 10,13,'A soma da matriz eh: $'
.CODE
    MAIN PROC 
        MOV AX,@DATA
        MOV DS,AX
 
        CALL LER
        PulaLinha
        CALL IMPRIME  
        CALL SOMA
        CALL IMPSOMA
         
 
        MOV AH,4Ch
        INT 21H
    MAIN ENDP

    LER PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV CX,4
        MOV AH,01
        XOR BX,BX 
        FORLER:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORLER2:
                MENSAGEM
                INT 21H
                PulaLinha
 
                CMP AL,36H
                JA NPERMITIDO
                CMP AL,30H
                JB NPERMITIDO


                AND AL,0FH
                MOV MATRIZ[BX][SI],AL
                INC SI
                LOOP FORLER2
            ;
            POP CX
            ADD BX,4
            LOOP FORLER
            JMP LEREXIT
        ;
        NPERMITIDO:
            MOV AH,09
            LEA DX,NPERM
            INT 21H 
            MOV AH,01
            JMP FORLER2
        ;
        LEREXIT:
        POP DX
        POP CX
        POP BX
        POP AX
        RET
    LER ENDP

    IMPRIME PROC
        PUSH AX
        PUSH BX
        PUSH DX
        PUSH CX
 
        MOV AH,2
        MOV CX,4
        XOR DX,DX

        FORIMP:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORIMP2:
                MOV DL,MATRIZ[BX][SI]
                OR DL,30H
                INT 21H 

                INC SI
                ESPAÇO
                LOOP FORIMP2
            ;
            PulaLinha
            POP CX
            ADD BX,4
            LOOP FORIMP

        POP CX
        POP DX
        POP BX
        POP AX
        RET

    IMPRIME ENDP

    SOMA PROC
        PUSH DX
        PUSH BX
        PUSH CX

        MOV AH,09
        LEA DX,SOMAMSG
        INT 21H 

        XOR AX,AX  
        XOR BX,BX
        MOV CX,4
        FORSOMA:
            XOR SI,SI
            PUSH CX
            MOV CX,4
            FORSOMA2:
                XOR DX,DX
                MOV DL, MATRIZ[BX][SI]
                ADD AX,DX
                INC SI
                LOOP FORSOMA2
            ;
            POP CX
            ADD BX,4
            LOOP FORSOMA
    
        POP CX
        POP BX
        POP DX
        RET
    SOMA ENDP

    IMPSOMA PROC
        PUSH BX
        PUSH CX
        PUSH DX 
        PUSH AX 

        XOR BH,BH
        MOV BL,10
        XOR DX,DX
        XOR CX,CX

        CMP AX,9
        JA SAIDADECIMAL

        MOV AH,02
        MOV DL,AL
        INT 21H
        JMP EXIT

        SAIDADECIMAL:
            DIV BL
            AND AL,AL
            JZ EXITDECIMAL

            MOV DL,AH
            PUSH DX 
            XOR AH,AH
            INC CX
            JMP SAIDADECIMAL
        ;

        EXITDECIMAL:
        XCHG AH,AL
        PUSH AX 
        MOV AH,02
        INC CX
 
        SAIDADECIMAL3:
            POP DX
            OR DL,30H
            INT 21H
        LOOP SAIDADECIMAL3
   
        EXIT:
        POP AX
        POP DX
        POP CX
        POP BX
        RET
    IMPSOMA ENDP
END MAIN