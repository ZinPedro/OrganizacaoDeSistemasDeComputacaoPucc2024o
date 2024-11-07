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
    MSG1 DB 'Em que base sera a entrada do numero?',10,13,'$'
    MSG2 DB 10,13,'Em que base sera a saida do numero?',10,13,'$' 
    MSG4 DB 10,13,'O numero eh: $' 

    BIN DB '1 - Binario',10,13,'$'
    DECI DB '2 - Decimal',10,13,'$'
    HEX DB '3 - Hexadecimal',10,13,'$'

    EHEXA DB 10,13,'Digite o numero hexadecimal (de 0 a F) : $'
    SHEXA DB 10,13,'O numero digitado, em hexadecimal, eh: $'

    EBIN DB 10,13,'Digite o numero binario (apenas 0s e 1s) : $'
    SBIN DB 10,13,'O numero digitado, em binario, eh: $'

    EDECI DB 10,13,'Digite o numero decimal (de 0 a 9) : $'
    SDECI DB 10,13,'O numero digitado, em decimal, eh: $'
 
    NPERMITIDO DB 10,13,'Esta nao e uma escolha possivel! Tente novamente: ',10,13,'$'

    

; Segmento de código
.CODE
    MAIN PROC
        MOV AX,@DATA        ; Carrega o endereço do segmento de dados em AX
        MOV DS,AX           ; Define DS como o segmento de dados

        ; Exibe as opções para a base de entrada
        IMPRIMEMSG MSG1
        IMPRIMEMSG BIN
        IMPRIMEMSG DECI
        IMPRIMEMSG HEX

        ; Lê a escolha do usuário para a base de entrada
        CALL ESCOLHA 
        CMP AL,31H          ; Verifica se o usuário escolheu '1' (binário)
        JE EBINARIO_
        CMP AL,32H          ; Verifica se o usuário escolheu '2' (decimal)
        JE EDECIMAL_ 

        ; Caso o usuário escolha hexadecimal
        CALL EHEXADECIMAL
        JMP EXIT_E          ; Salta para o fim da escolha da base de entrada

        EBINARIO_:
        CALL EBINARIO       ; Chama a rotina para a entrada em binário
        JMP EXIT_E          ; Salta para o fim da escolha da base de entrada

        EDECIMAL_:
        CALL EDECIMAL       ; Chama a rotina para a entrada em decimal
        EXIT_E:

        ; Exibe as opções para a base de saída
        IMPRIMEMSG MSG2
        IMPRIMEMSG BIN
        IMPRIMEMSG DECI
        IMPRIMEMSG HEX

        ; Lê a escolha do usuário para a base de saída
        CALL ESCOLHA
        CMP AL,31H          ; Verifica se o usuário escolheu '1' (binário)
        JE SBINARIO_
        CMP AL,32H          ; Verifica se o usuário escolheu '2' (decimal)
        JE SDECIMAL_ 

        ; Caso o usuário escolha hexadecimal para saída
        CALL SHEXADECIMAL
        JMP EXIT_S          ; Salta para o fim da escolha da base de saída

        SBINARIO_: 
        CALL SBINARIO       ; Chama a rotina para a saída em binário
        JMP EXIT_S          ; Salta para o fim da escolha da base de saída

        SDECIMAL_:  
        CALL SDECIMAL       ; Chama a rotina para a saída em decimal
        EXIT_S:

        ; Finaliza o programa
        MOV AH,4Ch          ; Função de saída do DOS
        INT 21H             ; Interrupção para encerrar o programa
    MAIN ENDP


    ESCOLHA PROC  
        PUSH DX               ; Salva o valor do registrador DX na pilha para preservar seu valor durante a execução do procedimento ESCOLHA.
        ESCOLHER:             ; Label (marcador) para o início do loop de seleção.

            MOV AH,01         ; Configura a função de leitura de caractere do teclado sem eco para o DOS (INT 21h, função 01).
            INT 21H           ; Interrupção de sistema para ler um caractere do teclado. O caractere digitado será armazenado em AL.

            CMP AL,31H        ; Compara o valor lido em AL com '1' (ASCII 31h).
            JB N_PERMITIDO    ; Se AL for menor que '1', salta para o rótulo N_PERMITIDO, indicando uma escolha inválida.
            CMP AL,33H        ; Compara o valor lido em AL com '3' (ASCII 33h).
            JA N_PERMITIDO    ; Se AL for maior que '3', salta para o rótulo N_PERMITIDO, indicando uma escolha inválida.

            POP DX            ; Restaura o valor original de DX que foi salvo na pilha.
            RET               ; Retorna para o chamador com AL contendo a escolha válida do usuário.

        N_PERMITIDO:          ; Rótulo para tratar uma entrada inválida do usuário.
            IMPRIMEMSG NPERMITIDO ; Chama a macro IMPRIMEMSG para exibir a mensagem de erro (entrada não permitida).
            JMP ESCOLHER          ; Retorna para o início do loop ESCOLHER para solicitar uma nova entrada do usuário.

    ESCOLHA ENDP             ; Fim do procedimento ESCOLHA.
 

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
            JA LETRA_IMPRIME        ;SE FOR LETRA, PULA PARA LETRA_IMPRIME
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
        RET
    SBINARIO ENDP

    EDECIMAL PROC
        IMPRIMEMSG EDECI         ; Exibe a mensagem solicitando que o usuário digite um número decimal (0-9).

        MOV BX,10                ; Define a base 10 (decimal) para as operações de multiplicação.
        MOV CX,4                 ; Define um limite de 4 dígitos para o número decimal.
        MOV AH,01                ; Configura a função de leitura de caractere do teclado (INT 21h, função 01).
        INT 21H                  ; Interrupção para ler o primeiro caractere do teclado. O valor será armazenado em AL.

        CMP AL,2DH               ; Verifica se o caractere lido é o símbolo de menos ('-' para números negativos).
        JE NEGATIVO              ; Se for '-', pula para o rótulo NEGATIVO para tratar o número como negativo.

        XOR DX,DX                ; Limpa DX, que será usado para armazenar o valor decimal acumulado.
        PUSH DX                  ; Salva o valor atual de DX na pilha.
        CMP AL,13                ; Verifica se o caractere é 'Enter' (valor ASCII 13).
        JE EXIT1_DECI            ; Se for 'Enter', salta para o fim (o número digitado é zero ou vazio).

        AND AL,0FH               ; Converte o dígito ASCII para seu valor numérico (0-9).
        MOV DL,AL                ; Armazena o primeiro dígito convertido em DL.
        DEC CX                   ; Decrementa o contador de dígitos (CX) para refletir o primeiro dígito lido.

        LOOP_DECI:               ; Início do loop para processar cada dígito adicional.
            MOV AH,01            ; Configura novamente a função de leitura de caractere.
            INT 21H              ; Lê o próximo caractere.
            CMP AL,13            ; Verifica se o caractere é 'Enter'.
            JE EXIT1_DECI        ; Se for 'Enter', salta para o final.

            CMP AL,30H           ; Verifica se o caractere é menor que '0'.
            JB NPERMITIDODECI    ; Se for, salta para NPERMITIDODECI para tratar a entrada inválida.
            CMP AL,39H           ; Verifica se o caractere é maior que '9'.
            JA NPERMITIDODECI    ; Se for, salta para NPERMITIDODECI para tratar a entrada inválida.

            AND AL,0FH           ; Converte o dígito ASCII para valor numérico (0-9).
            XOR AH,AH            ; Limpa o registrador AH.
            XCHG DX,AX           ; Troca DX com AX para preparar para a multiplicação.
            MUL BL               ; Multiplica o número acumulado em DX por 10 (BX) para "empurrar" o valor à esquerda.
            ADD DX,AX            ; Adiciona o dígito atual ao valor acumulado em DX.

        LOOP LOOP_DECI           ; Repete o loop enquanto CX (contador de dígitos) não chega a zero.

        JMP EXIT1_DECI           ; Salta para o fim após o processamento completo dos dígitos.

        NEGATIVO:                ; Rótulo para tratar números negativos.
            MOV AX,1             ; Coloca 1 em AX como indicador de número negativo.
            PUSH AX              ; Salva esse indicador na pilha.
            JMP LOOP_DECI        ; Volta ao loop de processamento de dígitos.

        NEGAR:                   ; Rótulo para inverter o sinal do número se for negativo.
            NEG BX               ; Aplica a operação de negação em BX (torna o valor negativo).
            JMP EXIT2_DECI       ; Salta para o fim do procedimento.

        NPERMITIDODECI:          ; Rótulo para tratar entradas inválidas.
            IMPRIMEMSG NPERMITIDO ; Exibe mensagem de erro para entrada inválida.
            JMP LOOP_DECI        ; Retorna ao loop para solicitar uma nova entrada do usuário.

        EXIT1_DECI:              ; Rótulo para o final do processamento dos dígitos.
            MOV BX,DX            ; Move o valor acumulado em DX para BX.
            POP AX               ; Recupera o valor da pilha (verifica se o número é negativo).
            OR AX,AX             ; Verifica se o valor em AX é zero (número positivo).
            JNZ NEGAR            ; Se AX não for zero, chama NEGAR para aplicar o sinal negativo.

        EXIT2_DECI:              ; Rótulo final para sair do procedimento.
            RET                  ; Retorna ao chamador com o valor decimal final em BX.
    EDECIMAL ENDP
   

    SDECIMAL PROC
        IMPRIMEMSG SDECI          ; Exibe a mensagem solicitando que o número decimal seja impresso.

        XOR CX,CX                 ; Limpa CX, que será usado para contar os dígitos do número.

        TEST BX,BX                ; Verifica o sinal do número em BX.
            JNS NNEG              ; Se BX é positivo (sinal não é negativo), salta para NNEG.
            MOV AH,02             ; Configura a função de saída de caractere (INT 21h, função 02) para exibir o sinal.
            MOV DL,2DH            ; Define DL como o caractere '-' para o sinal negativo.
            INT 21H               ; Interrupção para exibir o sinal '-' na tela.

            NEG BX                ; Inverte o valor em BX para torná-lo positivo, já que o sinal foi exibido.
        NNEG:
        MOV AX,BX                 ; Move o valor positivo de BX para AX para preparação de divisão.
        MOV BX,10                 ; Define a base decimal (10) para a divisão.

        IMPRIMEDECIMAL:           ; Rótulo para iniciar o loop de conversão dos dígitos.
            XOR DX,DX             ; Limpa DX antes da divisão para evitar restos indesejados.
            DIV BX                ; Divide AX por 10 (BX), deixando o quociente em AX e o resto (último dígito) em DX.
            PUSH DX               ; Salva o dígito atual (resto) na pilha.
            INC CX                ; Incrementa o contador de dígitos.
            TEST AX,AX            ; Testa se o quociente é zero (se todos os dígitos foram processados).
            JNZ IMPRIMEDECIMAL    ; Se não é zero, continua o loop para processar o próximo dígito.

        ; Agora, todos os dígitos foram empilhados (último dígito no topo da pilha).

        MOV AH,02                 ; Configura a função de saída de caractere (INT 21h, função 02) para exibir os dígitos.

        IMPRIMEDECIMAL2:          ; Rótulo para o loop de impressão dos dígitos.
            POP DX                ; Recupera o próximo dígito da pilha.
            OR DL,30H             ; Converte o valor numérico do dígito para ASCII (adicionando 30h).
            INT 21H               ; Interrupção para exibir o dígito na tela.

        LOOP IMPRIMEDECIMAL2      ; Decrementa CX e repete o loop enquanto CX não é zero (exibe todos os dígitos).

        RET                       ; Retorna ao chamador com o número exibido.
    SDECIMAL ENDP
   
END MAIN


