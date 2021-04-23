IDEAL
MODEL small
STACK 100h
p186 
DATASEG
; --------------------------
; Your variables here
	x dw 0
	y dw 0
	;צבע התחלתי של הרקע
	color db 2
	pix dw 0
	pix1 db  0
	
	msg_start_game  db ' Snake Game !$' 
	msg_start_game2  db '[use keys A & D / W & S ]$'
	
	; positiv = move right   negative = move left
ball_delta_x 	dw   2  ; +- signed pixber 
ball_delta_y 	dw   0  ; +- signed pixber 
; --------------------------
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
 
	
	;change grafic mode
	mov ax,13h
	int 10h
	 
	 
	 	 
	; print message
	MOV DH, 8   ; row pixber
	MOV DL, 12  ; column pixber
	MOV CX, offset msg_start_game
	call putMessage
	 
	 
	; print message
	MOV DH, 11   ; row pixber
	MOV DL,	7   ; column pixber
	MOV CX, offset msg_start_game2
	call putMessage
	
	
	; sleep 
	mov ax,100
	call MOR_SLEEP
	
	;מיקום  לרקע
	mov [pix],319
;מצייר את הרקע
back :
	call draw_line
	inc [y]
	mov [x],0
	;השורה הבאה מציירת כמה פעמים לצייר שורה
	cmp [y], 250
	jne back
	 
	;מצייר את הדמות במצב ההתחלתי שלה ובמיקום לפי הוואי
	mov [y],90
	call draw_char
	  
		  
    mov ah, 0h
	int 16h
	;מעביר את הסמן לאותו מקום ומנקה את הדמות
	mov [y],90
	call clear_char
    mov [y],90
fly :

	
	CALL MOR_GET_KEY
	
	mov ah, 01h
    int 16h
	
	cmp al,' '
    je up
	
	cmp al,'q'
	je exit
down :         
	  add [y],10
	  mov bx,[y]
	  call draw_char
	   
	   
	  mov ax, 100
		call MOR_SLEEP
		
	   mov[y],bx
	   call clear_char
	   
	   mov[y],bx
	   jmp fly
	
up :
	  sub [y],50
	  mov bx,[y]
	  call draw_char
	   
	  	 
		
	   mov[y],bx
	   call clear_char
	   
	   mov[y],bx
		
	   mov al,0
      
	  


	   jmp fly
	   
	   








	
game_over:	   
	   
; --------------------------
	
exit:

	;wait for key
	mov ah, 0h
	int 16h
	
	;return to text mode
	mov ax, 03h
	int 10h
	
	mov ax, 4c00h
	int 21h
 ;==========================================
 
proc draw_pixel
	pusha

	xor bh, bh ; bh = 0
	mov cx, [x]
	mov dx, [y]
	mov al, [color]
	mov ah, 0ch
	int 10h
	
	popa
	ret
 
endp draw_pixel
		
proc draw_line
	 pusha
	nu1 :
	call draw_pixel
	inc  [x]
	mov ax,[pix]
	cmp [x],ax
	jne nu1
	popa
	ret
	
endp draw_line
	 
;==============================================
;   putMessage  - print message on screen
;   IN: DH= row pixber  , DL = column pixber  , cx = the message (offset)
;   OUT:  NONE
;	EFFECTED REGISTERS : NONE
; ==============================================

proc putMessage
	pusha

	; set cursor position acording to dh dl
	MOV AH, 2       ; set cursor position
	MOV BH, 0       ; display page pixber
	INT 10H         ; video BIOS call
	
	; print msg
	mov dx,cx
	mov ah,9
	int 21h

	popa
	ret
endp 

;ציור של הציפור
proc draw_char
	pusha
	
	
	 ;!!!!!נאם משפיע על מיקום הוואי של פיקסל בודד
	 mov [pix],38
	 mov [x],25
	  
	 mov [color],0
	 call draw_line
	 
	 
	 
	mov [pix],25
	mov [x],20
	inc [y]
	mov [color],0
	call draw_line

	mov [pix],31
	mov [x],25
	mov [color],15
	call draw_line

	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	mov [pix],38
	mov [x],32
	mov [color],15
	call draw_line
	
	mov [pix],39
	mov [x],38
	mov [color],0
	call draw_pixel
	
	
	
	mov[pix],20
	mov[x],19
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],24
	mov [x],20
	mov [color],15
	call draw_line
	
	
	
	mov [pix],30
	mov [x],24
	mov [color],14
	call draw_line
	
	mov[pix],31
	mov[x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],39
	mov [x],31
	mov [color],15
	call draw_line
	
	mov[pix],40
	mov[x],39
	mov [color],0
	call draw_pixel
	
	
	
	mov[pix],20
	mov[x],19
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],30
	mov [x],20
	mov [color],14
	call draw_line
	
	mov[pix],31
	mov[x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	mov [color],15
	call draw_line
	 
	mov[pix],39
	mov[x],38
	mov [color],0
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	mov [color],15
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	mov [color],0
	call draw_pixel
	
	
		
	mov[pix],19
	mov[x],18
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],30
	mov [x],19
	mov [color],14
	call draw_line
	
	mov[pix],31
	mov[x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	mov [color],15
	call draw_line
	 
	mov[pix],39
	mov[x],38
	mov [color],0
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	mov [color],15
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	mov [color],0
	call draw_pixel
	
	
	
		
	mov[pix],18
	mov[x],17
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],30
	mov [x],18
	mov [color],14
	call draw_line
	
	mov[pix],31
	mov[x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	mov [color],15
	call draw_line
	 
	mov[pix],39
	mov[x],38
	mov [color],0
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	mov [color],15
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	mov [color],0
	call draw_pixel
	
	
	
		
	mov[pix],17
	mov[x],16
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],30
	mov [x],17
	mov [color],14
	call draw_line
	
	mov[pix],31
	mov[x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],40
	mov [x],31
	mov [color],15
	call draw_line
	 
	mov[pix],41
	mov[x],40
	mov [color],0
	call draw_pixel
	
	
			
	mov[pix],25
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov [pix],32
	mov [x],25
	mov [color],14
	call draw_line
	
	mov[pix],41
	mov[x],32
	mov [color],0
	call draw_line
	
	 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],25
	mov[x],14
	mov [color],15
	call draw_line
	
	mov[pix],26
	mov[x],25
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	mov [color],0
	call draw_pixel
	
	
	
	
 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],25
	mov[x],14
	mov [color],15
	call draw_line
	
	mov[pix],26
	mov[x],25
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],42
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],43
	mov[x],42
	mov [color],0
	call draw_pixel
 
 
	
 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],25
	mov[x],14
	mov [color],15
	call draw_line
	
	mov[pix],26
	mov[x],25
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],42
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],43
	mov[x],42
	mov [color],0
	call draw_pixel
	
	
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],26
	mov[x],14
	mov [color],15
	call draw_line
	
	mov[pix],27
	mov[x],26
	mov [color],0
	call draw_pixel
	
	mov [pix],30
	mov [x],27
	mov [color],14
	call draw_line
	
	
	mov [pix],31
	mov [x],30
	mov [color],0
	call draw_pixel
	
	mov [pix],32
	mov [x],31
	mov [color],12
	call draw_pixel
	
	mov [pix],42
	mov [x],32
	mov [color],0
	call draw_line
	
	 
	 
	
	
	mov[pix],24
	mov[x],13
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],26
	mov[x],24
	mov [color],15
	call draw_line
	
	mov[pix],27
	mov[x],26
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],27
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	mov [color],0
	call draw_pixel
	
	
	
	
		
	
	mov[pix],15
	mov[x],14
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov[pix],26
	mov[x],15
	mov [color],15
	call draw_line
	
	mov[pix],27
	mov[x],26
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],27
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	mov [color],0
	call draw_pixel
	
	
		
	mov[pix],15
	mov[x],14
	inc[y]
	mov [color],0
	call draw_line
	
	mov[pix],25
	mov[x],15
	mov [color],15
	call draw_line
	
	mov[pix],26
	mov[x],25
	mov [color],0
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	mov [color],0
	call draw_pixel
	
	
	
	
	
	
	mov[pix],26
	mov[x],14
	inc[y]
	mov [color],0
	call draw_line
	
	 
	
	mov [pix],31
	mov [x],25
	mov [color],14
	call draw_line
	
	mov [pix],32
	mov [x],31
	mov [color],0
	call draw_pixel
	
	
	mov[pix],40
	mov[x],32
	mov [color],12
	call draw_line
	
	
	mov[pix],41
	mov[x],40
	mov [color],0
	call draw_pixel
	
	
	
	
	mov[pix],25
	mov[x],15
	inc[y]
	mov [color],0
	call draw_line
	
	mov [pix],32
	mov [x],24
	mov [color],43
	call draw_line
	
	mov[pix],41
	mov[x],32
	mov [color],0
	call draw_line
	
	
	
	mov[pix],17
	mov[x],16
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],32
	mov [x],17
	mov [color],43
	call draw_line
	
	mov[pix],33
	mov[x],32
	mov [color],0
	call draw_pixel
	
	
	
	mov[pix],18
	mov[x],17
	inc[y]
	mov [color],0
	call draw_pixel
	
	mov [pix],32
	mov [x],18
	mov [color],43
	call draw_line
	
	mov[pix],33
	mov[x],32
	mov [color],0
	call draw_pixel

	
	mov[pix],25
	mov[x],18
	inc[y]
	mov [color],0
	call draw_line
	
	mov [pix],32
	mov [x],25
	mov [color],43
	call draw_line
	
	mov[pix],33
	mov[x],32
	mov [color],0
	call draw_pixel
 
 
 
 
	mov[pix],32
	mov[x],25
	inc[y]
	mov [color],0
	call draw_line
	 
 
	
	popa
	ret
	
	endp draw_char
		
;מחיקת הציפור עובר שוב על אותם הפיקסלים ומחזיר אותו לצבע של המסך	
proc clear_char 
	pusha
	
	
	 
	 mov [pix],38
	 mov [x],25
	 
	 
	 ;צבע שוב פעם
	 mov [color],2
	 call draw_line
	 
	 
	 
	mov [pix],25
	mov [x],20
	inc [y] 
	call draw_line

	mov [pix],31
	mov [x],25 
	call draw_line

	mov [pix],32
	mov [x],31
	call draw_pixel
	
	mov [pix],38
	mov [x],32
	call draw_line
	
	mov [pix],39
	mov [x],38
	call draw_pixel
	
	
	
	mov[pix],20
	mov[x],19
	inc[y]
	call draw_pixel
	
	mov [pix],24
	mov [x],20
	call draw_line
	
	
	
	mov [pix],30
	mov [x],24
	call draw_line
	
	mov[pix],31
	mov[x],30
	call draw_pixel
	
	mov [pix],39
	mov [x],31
	call draw_line
	
	mov[pix],40
	mov[x],39
	call draw_pixel
	
	
	
	mov[pix],20
	mov[x],19
	inc[y]
	call draw_pixel
	
	mov [pix],30
	mov [x],20
	call draw_line
	
	mov[pix],31
	mov[x],30
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	call draw_line
	 
	mov[pix],39
	mov[x],38
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	call draw_pixel
	
	
		
	mov[pix],19
	mov[x],18
	inc[y]
	call draw_pixel
	
	mov [pix],30
	mov [x],19
	call draw_line
	
	mov[pix],31
	mov[x],30
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	call draw_line
	 
	mov[pix],39
	mov[x],38
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	call draw_pixel
	
	
	
		
	mov[pix],18
	mov[x],17
	inc[y]
	call draw_pixel
	
	mov [pix],30
	mov [x],18
	call draw_line
	
	mov[pix],31
	mov[x],30
	call draw_pixel
	
	mov [pix],38
	mov [x],31
	call draw_line
	 
	mov[pix],39
	mov[x],38
	call draw_pixel
	
	mov[pix],40
	mov[x],39
	call draw_pixel
	
	mov[pix],41
	mov[x],40
	call draw_pixel
	
	
	
		
	mov[pix],17
	mov[x],16
	inc[y]
	call draw_pixel
	
	mov [pix],30
	mov [x],17
	call draw_line
	
	mov[pix],31
	mov[x],30
	call draw_pixel
	
	mov [pix],40
	mov [x],31
	call draw_line
	 
	mov[pix],41
	mov[x],40
	call draw_pixel
	
	
			
	mov[pix],25
	mov[x],13
	inc[y]
	call draw_line
	
	mov [pix],32
	mov [x],25
	call draw_line
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	call draw_line
	
	mov[pix],25
	mov[x],14
	call draw_line
	
	mov[pix],26
	mov[x],25
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	call draw_pixel
	
 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	call draw_line
	
	mov[pix],25
	mov[x],14
	call draw_line
	
	mov[pix],26
	mov[x],25
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],42
	mov[x],32
	call draw_line
	
	
	mov[pix],43
	mov[x],42
	call draw_pixel
 
 
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	call draw_line
	
	mov[pix],25
	mov[x],14
	call draw_line
	
	mov[pix],26
	mov[x],25
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],42
	mov[x],32
	call draw_line
	
	
	mov[pix],43
	mov[x],42
	call draw_pixel
	
	
	
	
	mov[pix],14
	mov[x],13
	inc[y]
	call draw_line
	
	mov[pix],26
	mov[x],14
	call draw_line
	
	mov[pix],27
	mov[x],26
	call draw_pixel
	
	mov [pix],30
	mov [x],27
	call draw_line
	
	
	mov [pix],31
	mov [x],30
	call draw_pixel
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	mov [pix],42
	mov [x],32
	call draw_line
	
	 
	
	mov[pix],24
	mov[x],13
	inc[y]
	call draw_line
	
	mov[pix],26
	mov[x],24
	call draw_line
	
	mov[pix],27
	mov[x],26
	call draw_pixel
	
	mov [pix],31
	mov [x],27
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	call draw_pixel
	
		
	
	mov[pix],15
	mov[x],14
	inc[y]
	call draw_pixel
	
	mov[pix],26
	mov[x],15
	call draw_line
	
	mov[pix],27
	mov[x],26
	call draw_pixel
	
	mov [pix],31
	mov [x],27
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	call draw_pixel
	
	
		
	mov[pix],15
	mov[x],14
	inc[y]
	call draw_line
	
	mov[pix],25
	mov[x],15
	call draw_line
	
	mov[pix],26
	mov[x],25
	call draw_pixel
	
	mov [pix],31
	mov [x],26
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	
	mov[pix],42
	mov[x],41
	call draw_pixel
	
	
	mov[pix],26
	mov[x],14
	inc[y]
	call draw_line
	
	 
	
	mov [pix],31
	mov [x],25
	call draw_line
	
	mov [pix],32
	mov [x],31
	call draw_pixel
	
	
	mov[pix],40
	mov[x],32
	call draw_line
	
	
	mov[pix],41
	mov[x],40
	call draw_pixel
		
	
	mov[pix],25
	mov[x],15
	inc[y]
	call draw_line
	
	mov [pix],32
	mov [x],24
	call draw_line
	
	mov[pix],41
	mov[x],32
	call draw_line
	
	
	
	mov[pix],17
	mov[x],16
	inc[y]
	call draw_pixel
	
	mov [pix],32
	mov [x],17
	call draw_line
	
	mov[pix],33
	mov[x],32
	call draw_pixel
	
	
	
	mov[pix],18
	mov[x],17
	inc[y]
	call draw_pixel
	
	mov [pix],32
	mov [x],18
	call draw_line
	
	mov[pix],33
	mov[x],32
	call draw_pixel
	
	
	
	
	mov[pix],25
	mov[x],18
	inc[y]
	call draw_line
	
	mov [pix],32
	mov [x],25
	call draw_line
	
	mov[pix],33
	mov[x],32
	call draw_pixel
 
 
 
 
	mov[pix],32
	mov[x],25
	inc[y]
	call draw_line
	 
 
	
	popa
	ret
	
		endp clear_char
	 
	
INCLUDE "MOR_LIB.asm"
END start