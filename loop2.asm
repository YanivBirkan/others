IDEAL
MODEL small
STACK 100h
DATASEG 

; --------------------------
; Your variables here
; --------------------------
num db 1
ten db 10
num1 db 3
num2 dw 6
result db 0
CODESEG
start: 
	mov ax, @data
	mov ds, ax
	
; --------------------------
; Your code here
; -------------------------

	mov cx,20
	jcxz after
	
loop1: 

	mov al,[num]
	mov ah,0
	div[ten]
	add ax,'00'
	mov dx,ax
	mov ah,2h
	int 21h
	mov dl,dh
	int 21h
	
	mov ah,0
	mov al,[num]
	mov bl,3
	div bl
	cmp ah,0
	jne nomood
	
	mov dl,'#'
	mov ah,2h
	int 21h
	
nomood:	
	mov dl, 0ah 
	mov ah, 2h	
	int 21h
	inc [num]
	loop loop1

after:
	mov cx,[num2]
	jcxz after3
	
loop2:
	
	mov al,[num1]
	add [result],al
	loop loop2
	
after3:

exit:
	mov ax, 4c00h
	int 21h
END start