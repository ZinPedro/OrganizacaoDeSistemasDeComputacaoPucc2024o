TITLE Entrada de Numeros 
.MODEL SMALL
.STACK 100H

PUSH_ALL MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI 
ENDM

POP_ALL MACRO
    POP DI
    POP SI
    POP DX
    POP CX 
    POP BX
    POP AX
ENDM

PulaLinha MACRO 
    PUSH_ALL
    MOV AH,02 
    MOV DL,10
    INT 21H 
    POP_ALL
ENDM

IMPRIMEMSG MACRO MSG
    PUSH_ALL
    MOV AH,09
    LEA DX,MSG
    INT 21H
    POP_ALL  
ENDM

.DATA
    MSG1 DB 'Em que base sera a entrada do numero?',10,13,'$'
    MSG2 DB 10,13,'Em que base sera a saida do numero?',10,13,'$' 
    MSG4 DB 10,13,'O numero eh: $' 

    BIN DB '1 - Binario',10,13,'$'
    DECI  DB '2 - Decimal',10,13,'$'
    HEX  DB '3 - Hexadecimal',10,13,'$'

    EHEXA DB 10,13,'Digite o numero hexadecimal (de 0 a F) : $'
    SHEXA DB 10,13,'O numero digitado, em hexadecimal, eh: $'

    EBIN DB 10,13,'Digite o numero binario (apenas 0s e 1s) : $'
    SBIN DB 10,13,'O numero digitado, em binario, eh: $'

    EDECI DB 10,13,'Digite o numero decimal (de 0 a 9) : $'
    SDECI DB 10,13,'O numero digitado, em decimal, eh: $'
 
    NPERMITIDO DB 10,13,'Esta nao e uma escolha possivel! Tente novamente: ',10,13,'$'

.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX

        IMPRIMEMSG MSG1
        IMPRIMEMSG BIN
        IMPRIMEMSG DECI
        IMPRIMEMSG HEX

        CALL ESCOLHA 
        XOR AL,31H
        JZ EBINARIO_
        XOR AL,32H
        JZ EDECIMAL_ 

        CALL EHEXADECIMAL
        JMP EXIT_E
        EBINARIO_:
        CALL EBINARIO
        JMP EXIT_E 
        EDECIMAL_:
        CALL EDECIMAL 
        EXIT_E:

        IMPRIMEMSG MSG2
        IMPRIMEMSG BIN
        IMPRIMEMSG DECI
        IMPRIMEMSG HEX

        CALL ESCOLHA
        XOR AL,31H
        JZ SBINARIO_
        XOR AL,32H
        JZ SDECIMAL_ 

        CALL SHEXADECIMAL
        JMP EXIT_S
        SBINARIO_: 
        CALL SBINARIO
        JMP EXIT_S 
        SDECIMAL_: 
        CALL SDECIMAL
        EXIT_S:



    MAIN ENDP

    ESCOLHA PROC  
        PUSH DX
        ESCOLHER:
            MOV AH,01
            INT 21H 

            CMP AL,31H
            JB N_PERMITIDO
            CMP AL,33H
            JA N_PERMITIDO

            POP DX
            RET

        N_PERMITIDO:
            IMPRIMEMSG NPERMITIDO
            JMP ESCOLHER
        ; 

    ESCOLHA ENDP  

    EHEXADECIMAL PROC   
        XOR AX,AX
        XOR BX,BX
        IMPRIMEMSG EHEXA

        MOV AH,01                   ;MOVE PARA FUNÇÃO QUE DETECTA CARACTERE DIGITADO E SALVA EM AL
        MOV CX,4                    ;COLOCA O VALOR 4 EM CX PARA REALIZAR O LOOP 4 VEZES

        WHILE_:
            INT 21H                 ;DETECTA CARACTERE DIGITADO E SALVA EM AL

            CMP AL,13               ;DETECTA SE A TECLA DIGITADA FOI O ENTER, SE SIM, SAI DO LOOP
            JE EXIT_WHILE
            ROL BX,4                ;ROLA OS BITS DE BX QUATRO CASAS PARA ESQUERDA
            CMP AL,60H              ;COMPARA O VALOR DE AL COM 66H, SE FOR MAIOR, O USUARIO DIGITOU UMA LETRA MINUSCULA
            JA LETRA_MINUSCULA
            CMP AL,39H              ;COMPARA O VALOR DE AL COM 39H, SE FOR MAIOR, O USUARIO DIGITOU UMA LETRA MAIUSCULA. SE NAO, DIGITOU UM NUMERO.
            JA LETRA_MAIUSCULA
            AND AL,0FH              ;ZERA OS 4 PRIMEIROS BITS DE AL, PARA FILTRAR O NUMERO, DE CARACTERE NUMERICO PARA NUMERO
            JMP SALTO1              ;PULA PARA SALTO1
            LETRA_MINUSCULA:
                SUB AL,87           ;SUBTRAI 87 DE AL, PARA FILTRA A LETRA MINUSCULA, DO CARACTER MINUSCULO PARA O VALOR HEXADECIMAL.
                JMP SALTO1          ;PULA PARA SALTO1
            LETRA_MAIUSCULA:
                SUB AL,55           ;SUBTRAI 55 DE AL, PARA FILTRA A LETRA MAIUSCULA, DO CARACTER MAIUSCULO PARA O VALOR HEXADECIMAL.
        SALTO1:
            OR BL,AL                ;COLOCA O VALOR DE AL EM BL
            LOOP WHILE_             ;VOLTA PARA WHILE_ ATE QUE CX SEJA 0
        ;
        EXIT_WHILE: 
        RET 
    EHEXADECIMAL ENDP

    SHEXADECIMAL PROC 

        IMPRIMEMSG SHEXA

            MOV AH,02               ;MOVE PARA FUNÇÃO QUE IMPRIME O CARACTERE COM O VALOR EM DL
            MOV CX,4                ;COLOCA O VALOR 4 EM CX PARA REALIZAR O LOOP 4 VEZES
        IMPRIME:
            MOV DL,BH               ;COLOCA O VALOR DE BH EM DL
            SHR DL,4                ;FILTRA DL PARA FICA SO COM O VALOR DO CARACTERE MAIS SIGNIFICATIVO DO NUMERO HEXADECIMAL
            CMP DL,09H              ;COMPARA DL COM 09H, PARA SABER SE EH UM NUMERO OU LETRA
            JG LETRA_IMPRIME        ;SE FOR LETRA, PULA PARA LETRA_IMPRIME
            OR DL,30H               ;COLOCA O VALOR DE 3 NOS 4 PRIMEIROS BITS, PARA FILTRAR O NUMERO, DE NUMERO PARA CARACTERE NUMERICO
            JMP SALTO2              ;PULA PARA SALTO2
            LETRA_IMPRIME:
            ADD DL,55               ;SOMA 55 A DL PARA TRANSFORMARA LETRA HEXADECIMAL EM CARACTERE
        SALTO2:
            INT 21H                 ;IMPRIME O CARACTERE COM VALOR EM DL
            ROL BX,4                ;ROLA OS BITS DE BX QUATRO CASAS PARA ESQUERDA
            LOOP IMPRIME            ;;VOLTA PARA IMPRIME ATE QUE CX SEJA 0
        ;
        RET


    SHEXADECIMAL ENDP    
   
    EBINARIO PROC
        XOR AX,AX
        XOR BX,BX 
        IMPRIMEMSG EBIN

        MOV AH,01           ;MOVE PARA FUNÇÃO QUE DETECTA CARACTERE DIGITADO E SALVA EM AL
        MOV CX,16           ;COLOCA O VALOR 16 EM CX PARA REALIZAR O LOOP 16 VEZES


        WHILE_BIN:
            INT 21H         ;DETECTA CARACTERE DIGITADO E SALVA EM AL

            CMP AL,13       ;DETECTA SE A TECLA DIGITADA FOI O ENTER, SE SIM, SAI DO LOOP
            JE EXIT_WHILEBIN

            ROL BX,1        ;ROLA OS BITS DE BX UMA CASA PARA ESQUERDA
            AND AL,01H      ;FILTRA AL (CASO O USUARIO NAO TENHA DIGITADO NEM UM NEM 0 O CODIGO NAO BUGAR(PODE SER QUE O RESULTADO FINAL DE ERRADO))

            OR BL,AL        ;SOMA O VALOR DE AL EM BL
 
            LOOP WHILE_BIN    ;RETORNA A WHILE_ ATE QUE CX SEJA 0
        ;
        EXIT_WHILEBIN: 
        RET
    EBINARIO ENDP   

    SBINARIO PROC 


        IMPRIMEMSG SBIN

            ROL BX,1        ;ROLA OS BITS DE BX UMA CASA PARA ESQUERDA
            
            MOV AH,02       ;MOVE PARA FUNÇÃO QUE IMPRIME O VALOR DE DL
            MOV CX,16       ;COLOCA O VALOR 16 EM CX PARA REALIZAR O LOOP 16 VEZES
        IMPRIMEBIN:
            TEST BX,0001H   ;ZERA TODOS OS BITS DE BX COM EXCEÇÃO DO LSB PARA SABER SE O LSB É 0 OU 1
            JZ ZEROBIN         ;SE A ZERO FLAG ATIVAR JUMP PARA ZERO 
            MOV DL,31H      ;COLOCA O VALOR 31H (VALOR DO 1 NA TABELA ASCII)
            JMP SALTOBIN       ;PULA PARA SALTO
            ZEROBIN:
            MOV DL,30H      ;COLOCA O VALOR 30H (VALOR DO 0 NA TABELA ASCII)
            SALTOBIN:
            INT 21H         ;IMPRIME O NUMERO CORRESPONDENTE NO LSB
            ROL BX,1        ;ROLA OS BITS DE BX UMA CASA PARA ESQUERDA
            LOOP IMPRIMEBIN    ;RETORNA AO IMPRIME ATE QUE CX SEJA 0
        ;
    SBINARIO ENDP

    EDECIMAL PROC 
        XOR DX,DX 
        IMPRIMEMSG EDECI 

        MOV BX,10
        MOV CX,4
        MOV AH,01 
        INT 21H
        CMP AL,2DH
        JE NEGATIVO
        CMP AL,13 
        JE EXIT1_DECI
        AND AL,0FH
        MOV DL,AL
        DEC CX
        LOOP_DECI: 
            MOV AH,01 
            INT 21H 
            CMP AL,13 
            JE EXIT1_DECI 
            CMP AL,30H 
            JB NPERMITIDODECI
            CMP AL,39H
            JA NPERMITIDODECI
            AND AL,0FH
            XOR AH,AH  
            XCHG DX,AX 
            MUL BL 
            ADD DX,AX
        LOOP LOOP_DECI

        NEGATIVO:
            XOR AH,AH
            PUSH AX 
            JMP LOOP_DECI
            
        EXIT1_DECI:    
            MOV BX,DX
 




        RET 
    EDECIMAL ENDP    

END MAIN


