

; Stupid game - Oren Gross 2021
; SG1 - 

IDEAL
MODEL small  
STACK 100h
P186  ; !!!!!!!!

DATASEG

; CONSTANTS
BALL_SIZE EQU  20
bomb_size EQU  8
; attribute of the ball 
	
ball_x		dw 50
ball_y		dw 100
ball_color 	db  4 ; red
tail_color db 3
bomb_x		dw ?
bomb_y		dw ?
bomb_color	db 0
apple_x		dw ?
apple_y		dw ?
apple_color	db 12;brown
; DELTA -number of pixel that squere moves
; signed number:
; positiv = move right   negative = move left
ball_delta_x 	dw   2  ; +- signed number 
ball_delta_y 	dw   0  ; +- signed number 
; messages  
msg_start_game  db ' SNAKE GAME !$' 
msg_start_game2  db '[use keys A & D / W & S ]$' 
msg_bomb db 'the bombs are in black $'
msg_bomb2 db 'and if you eat them you will die !!!! $'
msg_apple db 'if you eat the pink apples $'
msg_apple2 db 'you will grow$'
msg_end_game db ' GAME OVER !!!! $'
msg_border db 'if you touch the border you will die$' 
msg_start db 'press any key to start$'
msg_quit db 'press Q key to quit the game$'
msg_score db 'score: 0$'
msg_score2 db 'score: 1$'
;msg_score2 db 0
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
	MOV DH, 2   ; row pixber
	MOV DL, 12  ; column pixber
	MOV CX, offset msg_start_game
	call putMessage
	 
	 
	; print message
	MOV DH, 5   ; row pixber
	MOV DL,	7   ; column pixber
	MOV CX, offset msg_start_game2
	call putMessage
	
	
	
	; print message
	MOV DH, 8   ; row pixber
	MOV DL,	8 ; column pixber
	MOV CX, offset msg_bomb
	call putMessage
	
	
	; print message
	MOV DH, 10   ; row pixber
	MOV DL,	2 ; column pixber
	MOV CX, offset msg_bomb2
	call putMessage
	
	
	; print message
	MOV DH, 12   ; row pixber
	MOV DL,	7 ; column pixber
	MOV CX, offset msg_apple
	call putMessage
	
	; print message
	MOV DH, 14   ; row pixber
	MOV DL,	12 ; column pixber
	MOV CX, offset msg_apple2
	call putMessage
	
	
	; print message
	MOV DH, 16   ; row pixber
	MOV DL,	1   ; column pixber
	MOV CX, offset msg_border
	call putMessage

		; print message
	MOV DH, 18  ; row pixber
	MOV DL,	5   ; column pixber
	MOV CX, offset msg_quit
	call putMessage
			; print message
	MOV DH, 21  ; row pixber
	MOV DL,	8   ; column pixber
	MOV CX, offset msg_start
	call putMessage
	; sleep 
	; mov ax,5000
	; call MOR_SLEEP

	; Wait for key press
	mov ah,8
	int 21h
	
	mov [pix],319
	;מצייר את הרקע
back :
	call draw_line
	inc [y]
	mov [x],0
	;השורה הבאה מציירת כמה פעמים לצייר שורה
	cmp [y], 250
	jne back
	
	;ציור של קיר שמאלי
	; draw a wall
	mov cx,0 ; dx stay the same 
	mov dx,0  ; dx stay the same 
	mov al,3 
	mov ah,5
	mov bl,200
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 

	;ציור של קיר עליון
	; draw a wall
	mov cx,0 ; dx stay the same 
	mov dx,0  ; dx stay the same 
	mov al,3  
	mov ah,255
	mov bl,5
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
	
	;המשך ציור של קיר עליון
	; draw a wall
	mov cx,255 ; dx stay the same 
	mov dx,0  ; dx stay the same 
	mov al,3  
	mov ah,65
	mov bl,5
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
	

	
	;קיר תחתון
	; draw a wall
	mov cx,0 ; dx stay the same 
	mov dx,195  ; dx stay the same 
	mov al,3 
	mov ah,255
	mov bl,5
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
	
	;המשך ציור של קיר תחתון
	; draw a wall
	mov cx,255 ; dx stay the same 
	mov dx,195  ; dx stay the same 
	mov al,3  
	mov ah,65
	mov bl,5
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 

	
	;ציור של קיר ימני
	; draw a wall
	mov cx,315 ; dx stay the same 
	mov dx,0  ; dx stay the same 
	mov al,3  
	mov ah,5
	mov bl,200
	call drawRect  ;   IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH , BL = HIGHT 
	

	
; draw ball for the first time 
	mov cx,[ball_x]  ; dx stay the same 
	mov dx,[ball_y]  ; dx stay the same 
	mov al,[ball_color] ; red 
	call drawBall
	

	;ציור פצצה 
	mov ax ,310
	call MOR_RANDOM		
	add ax ,1
	mov [bomb_x] ,ax
	mov cx,[bomb_x]  

	
	mov ax ,190
	call MOR_RANDOM		
	add ax ,1
	mov [bomb_y] ,ax
	mov dx,[bomb_y]  ; dx stay the same 
	mov al,[bomb_color] ; red 

	call drawbomb
	
	
	
	
	
 	;ציור תפוח

	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov [apple_x] ,ax
	mov cx,[apple_x]  

	
	mov ax ,200
	call MOR_RANDOM		
	add ax ,50
	mov [apple_y] ,ax
	mov dx,[apple_y]  ; dx stay the same 
	mov al,[apple_color] ; red 

	call drawapple

; =========================================
; =====      game loop             ========
; =========================================
	
main_loop:   

    ; print game over
	MOV DH, 0     ; row number
	MOV DL, 2     ; column number
	MOV CX, offset msg_score
	call putMessage
	

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
    cmp cx,303
	ja game_over
	

    cmp dx,195
	ja game_over
	
	
;chek if tocu the bomb	
	; x bomb check
	cmp cx,[bomb_x]
	ja checky
	jmp next
	
checky:
    cmp dx,[bomb_y]
	je game_over
	jmp mov_ball
	
next:	

    ; cmp cx,1
	; ja above_20
	; mov cx,20 ; if less than set to 20
; above_20:

mov_ball:
	; draw ball in new position - according to cx
	;mov dx,[ball_y]  ; dx stay the same 
	mov al,[ball_color]
	call moveBall
	
	jmp main_loop	; JUMP TO START OF MAIN LOOP

game_over:
    ; print game over
	MOV DH, 0     ; row number
	MOV DL, 2     ; column number
	MOV CX, offset msg_score2
	call putMessage
exit:

    ; print game over
	MOV DH, 17        ; row number
	MOV DL, 11     ; column number
	MOV CX, offset msg_end_game
	call putMessage

	MOV DH, 0     ; row number
	MOV DL, 2     ; column number
	MOV CX, offset msg_score2
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

proc drawapple
	PUSHA 
	mov cx,[apple_x]
	mov dx,[apple_y]
	mov ah,bomb_size
	mov bl,bomb_size
	;MOV AL,[apple_color]
    call drawRect  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT
	;mov cx,[bomb_x]
	;mov dx,[bomb_y]
	;MOV AL,7
	;call drawRect2  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT	
	POPA
	ret 
endp

proc drawbomb
	PUSHA 
	mov cx,[bomb_x]
	mov dx,[bomb_y]
	mov ah,bomb_size
	mov bl,bomb_size
    call drawRect  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT
	;mov cx,[bomb_x]
	;mov dx,[bomb_y]
	;MOV AL,7
	;call drawRect2  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT	
	POPA
	ret 
endp


proc drawRect2 
	PUSHA 
ONE_LINE2	:
    call drawLine  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH 
	dec dx
	inc cx 
	dec bl
	jnz ONE_LINE2
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

        








