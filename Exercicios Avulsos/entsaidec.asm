.MODEL SMALL
.CODE
MAIN PROC
    CALL ENTDEC
    CALL SAIDEC
    MOV AH,4CH
    INT 21H
MAIN ENDP

ENTDEC PROC
; lê um numero entre -32768 A 32767
; entrada nenhuma
; saída numero em AX
    PUSH BX
    PUSH CX
    PUSH DX
@INICIO:
; imprime prompt ?
    MOV AH,2
    MOV DL,'?'
    INT 21H     ; imprime ?
;  total = 0
    XOR BX,BX

; negativo = falso
    XOR CX,CX

; le caractere
    MOV AH,1
    INT 21H

; case caractere lido eh?
    CMP AL,'-'
    JE @NEGT
    CMP AL,'+'
    JE @POST
    JMP @REP2
@NEGT:
    MOV CX,1
@POST:
    INT 21H
;end case
@REP2:
; if caractere esta entre 0 e 9
    CMP AL, '0'
    JNGE @NODIG
    CMP AL, '9'
    JNLE @NODIG
; converte caractere em digito
    AND AX,000FH
    PUSH AX
; total = total X 10 + digito
    MOV AX,10
    MUL BX   ; AX = total X 10
    POP BX
    ADD BX,AX ; total - total X 10 + digito
; le caractere
    MOV AH,1
    INT 21H
    CMP AL,13  ;CR ?
    JNE @REP2    ; não, continua
; ate CR
    MOV AX,BX   ; guarda numero em AX
; se negativo
    OR CX,CX    ; negativo ?
    JE @SAI      ; sim, sai
; entao
    NEG AX
; end if
    jmp @sai
@NODIG:
; se caractere ilegal
    MOV AH,2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    JMP @INICIO
@SAI:
    POP DX    ; restaura registradores
    POP CX
    POP BX
   
    RET   ; retorna

ENTDEC ENDP
SAIDEC PROC
; imprime numero decimal sinalizado em AX
; entrada AX
; saida nenhuma
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
; if AX < 0
    OR AX,AX      ; AX < 0 ?
    JGE @END_IF1
;then
    PUSH AX     ;salva o numero
    MOV DL, '-'
    MOV AH,2
    INT 21H         ; imprime -
    POP AX          ; restaura numero
    NEG AX

; digitos decimais
@END_IF1:
    XOR CX,CX      ; contador de d?gitos
    MOV BX,10      ; divisor
@REP1:
    XOR DX,DX      ; prepara parte alta do dividendo
    DIV BX         ; AX = quociente   DX = resto
    PUSH DX        ; salva resto na pilha
    INC CX         ; contador = contador +1

;until
    OR AX,AX       ; quociente = 0?
    JNE @REP1      ; nao, continua

; converte digito em caractere
    MOV AH,2

; for contador vezes
@IMP_LOOP:
    POP DX        ; digito em DL
    OR DL,30H
    INT 21H
    LOOP @IMP_LOOP
; fim do for

    POP DX
    POP CX
    POP BX
    POP AX
    RET
SAIDEC ENDP

END MAIN