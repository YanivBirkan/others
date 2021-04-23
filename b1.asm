IDEAL
MODEL small  
STACK 100h
P186 

DATASEG
num1 	db ?
num2 	db ?
smaller db ?
bigger 	db ?
 
CODESEG

start:
	mov ax, @data
	mov ds, ax 
	
print_bigger:	
	
	; read first digit
	mov ah,1
	int 21h
	sub al,'0'
	mov [num1],al
	
	; read second digit
	mov ah,1
	int 21h
	sub al,'0'
	mov [num2],al

	
	call calc
	
	skip_1:

	; now we will print the result   
	; print = 
	mov dl,'='
	mov ah,2
	int 21h

	; print bigger
	mov dl,[bigger]
	add dl,'0'
	mov ah,2
	int 21h
	
	
	; new line
	mov dl,10
	mov ah,2
	int 21h

	; check if bigger is zero
	cmp [bigger],0
	jne print_bigger
	
	
	
exit:

	mov ax, 4c00h
	int 21h


;====================================================================
;   name  –  calc(calculate smaller and bigger)
;   IN:  AL - num2 , המספרים יועברו לפרוצדורה ברגיסטרים
;   OUT:  הפרוצדורה תעדכן את המשתנים BIGGER ו SMALLER
;	EFFECTED REGISTERS : al,ah,dl,cl   , 
; ====================================================================
proc calc
pusha

;calculate smaller and bigger
	cmp al,[num1]
	ja al_bigger
	; al hold smaller
	mov [smaller],al
	mov ah,[num1]
	mov [bigger],ah 
	jmp skip_1
al_bigger:
	mov [bigger],al
	mov ah,[num1]
	mov [smaller],ah 


	popa
	ret
endp

END start
