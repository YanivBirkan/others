IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
	msg db '                                                            ',10
        db '       ',4,4,4,4,4,4,4,4,4,4,4,4,4,'    The bird game    ',4,4,4,4,4,4,4,4,4,4,4,4,10
	    db '                                                            ',10,'$'
	msg1 db 'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV',10
		db 'v                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'V                                                                         V',10
		db 'VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV',10,'$'
		msg2 db'	                                       ' ,10
		     db'                 MADE BY: ___yaniv______________' ,10
		     db'                                           ' ,10,'$'	
	 
      
	row db 10
	col db 20
	color dw 0004h
    counter db ?
	
		; --------------------------
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
	;CLEAR SCREEN - ניקוי מסך
    MOV AX, 2h
	INT 10h	

	; HIDE CURSOR - החבאת הסמן
	MOV CX,2607h
	MOV AH,01
	INT 10H

    mov dx,offset msg
	mov ah, 9
	int 21h

	mov dx,offset msg1
	mov ah, 9
	int 21h
	
	mov dx,offset msg2
	mov ah, 9
	int 21h

;start point
;מיקום ראשוני
	mov dh, [row]	; row
	mov dl, [col]  	; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
		
	;Draw smiley - ascii 2 at cursor position
	mov ah, 9   ; 9 = print character with color
	mov al, 2   	; al = character to display 
	mov bx, [color]  ; bh = 00   bl = Foreground 
	mov cx, 1  	; cx = number of times to write character 
	int 10h
	

	; Wait for character
	mov ah,7
	int 21h	
	
	;מחיקה
	;black
	mov [color] ,0      
	
	;Draw smiley - ascii 2 at cursor position
	mov ah, 9   ; 9 = print character with color
	mov al, 2   	; al = character to display 
	mov bx, [color]  ; bh = 00   bl = Foreground 
	mov cx, 1  	; cx = number of times to write character 
	int 10h
	
;הזזה וציור מחדש עם צבע חדש 
;mov	
	mov [col] ,50 
	mov  [row] ,10    
	mov  [color] , 0004h
	
	
;draw
	mov dh, [row]	; row
	mov dl, [col]  	; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
	;Draw smiley - ascii 2 at cursor position
	mov ah, 9   ; 9 = print character with color
	mov al, 2   	; al = character to display 
	mov bx, [color]  ; bh = 00   bl = Foreground 
	mov cx, 1  	; cx = number of times to write character 
	int 10h

	; Wait for character
	mov ah,7
	int 21h	
	; Wait for character
	mov ah,7
	int 21h	
	;סיום הזזה לצד אחד
	;מחיקה
	;black
	mov [color] ,0
	;Draw smiley - ascii 2 at cursor position
	mov ah, 9   ; 9 = print character with color
	mov al, 2   	; al = character to display 
	mov bx, [color]  ; bh = 00   bl = Foreground 
	mov cx, 1  	; cx = number of times to write character 
	int 10h
	
	;ציור מחדש	
	mov [col] , 25
	mov [row] , 17
	mov [color] , 10
	;draw
	mov dh, [row]	; row
	mov dl, [col]  	; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
	;Draw smiley - ascii 2 at cursor position
	mov ah, 9   ; 9 = print character with color
	mov al, 2   	; al = character to display 
	mov bx, [color]  ; bh = 00   bl = Foreground 
	mov cx, 1  	; cx = number of times to write character 
	int 10h
	
	

	
	

; --------------------------
	; Wait for character
mov ah,7
int 21h	

exit:
	mov ax, 4c00h
	int 21h
END start
