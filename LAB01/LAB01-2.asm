title numero
.model small
.data
    plinha db 13,10,'$'
.code
main proc

mov cx, 10
mov ah,2
mov dx,'11'
imprime:
    
    int 21h
    inc dl 

loop imprime

mov ah,4ch
int 21h

main endp
end main