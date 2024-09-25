title imprime string
.model small
.data
    texto1 db 'organizacao de sistemas computacionais$'
    plinha db 13,10,'$'
    texto3 db 'Aula 01$'
    del db 127,'$'
    
.code

main proc
mov ax,@data
mov ds,ax

mov ah,9

mov dx, offset texto1
int 21h

mov dx, offset plinha
int 21h

mov dx, offset texto3
int 21h

mov dx, offset del
int 21h


mov ah,4ch
int 21h
main endp
end main 
