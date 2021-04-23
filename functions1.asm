IDEAL
MODEL small
STACK 100h
DATASEG
rand1 		DB ?
ten         DB 10
msg1	DB 10,'Enter a  digit : $'
msg2	DB 10,'here I div the new number in 27 and the mod = $'
mod1	db ?
CODESEG
start:
	mov ax, @data
	mov ds, ax

; --------------------------
; Your code here
; --------------------------
mov ax ,1000
Call MOR_RANDOM
mov [rand1],ax
;הדפסה דו סיפרתי
	mov al , [rand1]
	mov ah, 0
	div [ten]
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	int 21h	
exit:
	mov ax, 4c00h
	int 21h
END start