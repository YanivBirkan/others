

; Stupid game - Oren Gross 2021
; SG1 - 

IDEAL
MODEL small  
STACK 100h
P186  ; !!!!!!!!

DATASEG

; CONSTANTS
BALL_SIZE EQU  20

; attribute of the ball 
	
ball_x		dw 50
ball_y		dw 100
ball_color 	db  4 ; red
bomb_x		dw ?
bomb_y		dw ?
bomb_color	db 6;brown
; DELTA -number of pixel that squere moves
; signed number:
; positiv = move right   negative = move left
ball_delta_x 	dw   2  ; +- signed number 
ball_delta_y 	dw   0  ; +- signed number 
; messages  
msg_start_game  db ' Snake Game !$' 
msg_start_game2  db '[use keys A & D / W & S ]$' 
msg_end_game db 'Game Over $'
rnd_num db ?
x dw 0
	y dw 0 
	color db 2 
pix dw 0
	pix1 db  0 
 
CODESEG

start:
	mov ax, @data
	mov ds, ax 
	
	; set GRAPHIC MODE
	mov ax, 13h
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
	mov ax,3000
	call MOR_SLEEP

	
	mov [pix],319
	;מצייר את הרקע
back :
	call draw_line
	inc [y]
	mov [x],0
	;השורה הבאה מציירת כמה פעמים לצייר שורה
	cmp [y], 250
	jne back
	
	
	; draw a wall
	mov cx,263 ; dx stay the same 
	mov dx,30  ; dx stay the same 
	mov al,5  
	mov ah,5
	mov bl,60
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 

	;ציור של חור
	;קיר2
	mov cx,263 ; dx stay the same 
	mov dx,130  ; dx stay the same 
	mov al,5  
	mov ah,5
	mov bl,60
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 

; draw ball for the first time 
	mov cx,[ball_x]  ; dx stay the same 
	mov dx,[ball_y]  ; dx stay the same 
	mov al,[ball_color] ; red 
	call drawBall
	
	
; draw ball for the first time 

	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov [bomb_x] ,ax
	mov cx,[bomb_x]  
	
	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov [bomb_y] ,ax
	mov dx,[bomb_y]  ; dx stay the same 
	mov al,[bomb_color] ; red 

	call drawbomb
; =========================================
; =====      game loop             ========
; =========================================
	
main_loop:   

	; sleep 
	mov ax,300
	call MOR_SLEEP
	
	; read from keyboard ( but dont wait !!!)
	CALL MOR_GET_KEY
	
	; change delat acording to key pressed :   d= 10  a= -10 
	
	cmp al,'d'
	jne not_d
	mov [ball_delta_x] , 10
	mov [ball_delta_y] , 0
	mov [ball_color],4 ; red
not_d:
	cmp al,'s'
	jne not_s
	mov [ball_delta_y] , 10   ; !!!!  MINUS 10
	mov [ball_delta_x] , 0
	mov [ball_color],4 ; red
not_s:
	cmp al,'w'
	jne not_w
	mov [ball_delta_y] , -10   ; !!!!  MINUS 10
	mov [ball_delta_x] , 0
	mov [ball_color],4 ; green

not_w:
	;ממקם במקום רנדומלי את האיקס בין 50 ל200
	cmp al,'r'
	jne not_r 
	
	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov cx , ax
	;ממקם במקום רנדומלי את הוואי בין 50 ל200
	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov dx , ax
	
	mov al,4 ; red
	;דילוג ישר לציור
	jmp mov_ball
	
not_r:

	cmp al,'a'
	jne not_a
	mov [ball_delta_x] , -10   ; !!!!  MINUS 10
	mov [ball_delta_y] , 0
	mov [ball_color],4 ; red	
	
not_a:

	cmp al, 'q'			 ; QUIT PROGRAM
	je exit

	; calculate new position ( in CX )
	mov cx,[ball_x]
	add cx,[ball_delta_x]

	; calculate new position ( in dX )
	mov dx,[ball_y]
	add dx,[ball_delta_y]
	
	; RIGHT BORDER : check if over 250 = game over
    cmp cx,250
	ja game_over


;chek if tocu the bomb	
	; x bomb check
	cmp cx,[bomb_x]
	ja checky
	jmp next
checky:
    cmp dx,[bomb_y]
	ja game_over
	jmp next
	
next:	
	; LEFT BORDER : dont let it move too much left	( less than 20)
    cmp cx,20
	ja above_20
	mov cx,20 ; if less than set to 20
above_20:

mov_ball:
	; draw ball in new position - according to cx
	;mov dx,[ball_y]  ; dx stay the same 
	mov al,[ball_color]
	call moveBall
	
	jmp main_loop	; JUMP TO START OF MAIN LOOP

game_over:
exit:

    ; print game over
	MOV DH, 20        ; row number
	MOV DL, 16     ; column number
	MOV CX, offset msg_end_game
	call putMessage

; Wait for key press
	mov ah,8
	int 21h

	; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h

	mov ax, 4c00h
	int 21h

;==================================================================
; =====      PROCEDURES 
;==================================================================


;==============================================
;   drawLine  – draw a line starting at  X,Y  
;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH
;   OUT:  NONE
;	EFFECTED REGISTERS : NONE
; ==============================================
proc drawLine 
	PUSHA 
	mov bl,ah ; loop counter (cause ah is needed)
	mov bh,0
	mov ah,0ch
ONE_PIXEL	:
	int 10h
	inc cx
	dec bl
	jnz ONE_PIXEL
	POPA
	ret 
endp


;==============================================
;   drawRect  – draw a rectangle starting at  X,Y  
;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
;   OUT:  NONE
;	EFFECTED REGISTERS : NONE
; ==============================================

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
		


proc drawRect 
	PUSHA 
ONE_LINE	:
    call drawLine  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH 
	inc dx
	dec bl
	jnz ONE_LINE
	POPA
	ret 
endp



	

;==============================================
;   drawBall  – draw the ball (10x10) acording to  ball_x , ball_y
;   IN:  AL= COLOR ,[ball_x], [ball_y]
;   OUT:  NONE
;	EFFECTED REGISTERS : NONE
; ==============================================

proc drawBall 
	PUSHA 
	mov cx,[ball_x]
	mov dx,[ball_y]
	mov ah,BALL_SIZE
	mov bl,BALL_SIZE
	;במקום DRAW_RECT
    call drawRect  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT 
	POPA
	ret 
endp


proc drawbomb
	PUSHA 
	mov cx,[bomb_x]
	mov dx,[bomb_y]
	mov ah,BALL_SIZE
	mov bl,BALL_SIZE
    call draw_char  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT 
	POPA
	ret 
endp
;====================================================================
;   moveBall  – erase the ball and repaint it in its new location
;   IN:  [ball_x], [ball_y] , CX = NEW X  DX = NEW Y , AL= NEW COLOR 
;   OUT:  update [ball_x], [ball_y] to the new location
;	EFFECTED REGISTERS : NONE
; ====================================================================

proc moveBall 
	PUSHA 
	PUSHA ; !!!!   TWICE
	
; erase current ball 
	MOV AL,2  ; color = black
    call drawBall  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT 

; update ball_x and ball_y and draw ball in new place
	POPA	; restore registers .bcs i need the new color and new XY
	mov [ball_x],cx
	mov [ball_y],dx
	mov [ball_color],al
    call drawBall  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT 
	POPA
	ret 
endp




;==============================================
;   putMessage  - print message on screen
;   IN: DH= row number  , DL = column number  , cx = the message (offset)
;   OUT:  NONE
;	EFFECTED REGISTERS : NONE
; ==============================================

proc putMessage
	pusha

	; set cursor position acording to dh dl
	MOV AH, 2       ; set cursor position
	MOV BH, 0       ; display page number
	INT 10H         ; video BIOS call
	
	; print msg
	mov dx,cx
	mov ah,9
	int 21h

	popa
	ret
endp 



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

INCLUDE "MOR_LIB.asm"
END start

        








