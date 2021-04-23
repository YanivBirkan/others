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

; DELTA -number of pixel that squere moves
; signed number:
; positiv = move right   negative = move left
ball_delta_x 	dw   2  ; +- signed number 
ball_delta_y	dw   2  ; +- signed number 
; messages  
msg_start_game  db ' Stupid Game ! [use keys A & D]$' 
msg_end_game  	db 'Game Over !!! $' 
 
CODESEG

start:
	mov ax, @data
	mov ds, ax 
	
	; set GRAPHIC MODE
	mov ax, 13h
	int 10h

	; print message
	MOV DH, 2        ; row number
	MOV DL, 2     ; column number
	MOV CX, offset msg_start_game
	call putMessage

	; draw a wall
	mov cx,263 ; dx stay the same 
	mov dx,40  ; dx stay the same 
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
	mov [ball_color],4 ; red
not_d:
	cmp al,'s'
	jne not_s
	mov [ball_delta_y] , -10   ; !!!!  MINUS 10
	mov [ball_color],5 ; purple
not_s:
	cmp al,'w'
	jne not_w
	mov [ball_delta_y] , 10   ; !!!!  MINUS 10
	mov [ball_color],2 ; green

not_w:

	cmp al,'a'
	jne not_a
	mov [ball_delta_x] , -10   ; !!!!  MINUS 10
	mov [ball_color],9 ; blue
not_a:

	cmp al, 'q'			 ; QUIT PROGRAM
	je exit

	; calculate new position ( in CX )
	mov cx,[ball_x]
	add cx,[ball_delta_x]

	mov cx,[ball_y]
	add cx,[ball_delta_y]

	; RIGHT BORDER : check if over 250 = game over
    cmp cx,250
	ja game_over
	
	; LEFT BORDER : dont let it move too much left	( less than 20)
    cmp cx,20
	ja above_20
	mov cx,20 ; if less than set to 20
above_20:


	; draw ball in new position - according to cx
	mov dx,[ball_y]  ; dx stay the same 
	mov al,[ball_color]
	call moveBall
	
	jmp main_loop	; JUMP TO START OF MAIN LOOP

game_over:
exit:

    ; print game over
	MOV DH, 18      ; row number
	MOV DL, 10     ; column number
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
    call drawRect  ; IN: CX=X  , DX =Y , AL = COLOR , AH = WIDTH ,  BL = HIGHT 
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
	MOV AL,0  ; color = black
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


INCLUDE "MOR_LIB.asm"
END start
