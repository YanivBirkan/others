IDEAL
MODEL small
STACK 100h
DATASEG
NUM_A 		DB 8
NUM_B 		DB 5
RESULT      DW ? 
ten         DB 10
CODESEG
start:
	mov ax, @data
	mov ds, ax

; --------------------------
; Your code here
; --------------------------
	mov al,[NUM_A]
	MOV bl,[NUM_B]
	mul bl
	
	mov [RESULT],ax
	
	mov dl, 10
	mov ah, 2
	int 21h	
	
	mov ax,[RESULT]

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