IDEAL
MODEL small
STACK 100h
DATASEG
p186

x dw 150
y dw 50
color db 2
counter db 24

CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	;grapic mode
	mov ax , 013h
	int 10h
; --------------------------
;ציור של שורה 24 פעמים
	mov cl ,24
	jcxz after

loop2:	
	call drawLine
	mov [x] , 150
	inc [y]
	;לולאה
	loop loop2

after:
;ציור ריבוע במקום אחר 
	;wait for key
	mov ah ,0h
	int 16h
	
	mov cl ,24
	jcxz after

loop5:	
	call drawLine
	mov [x] , 250
	inc [y]
	;לולאה
	loop loop5
exit:

	;wait for key
	mov ah ,0h
	int 16h
	
	;return to text mode
	mov ax,03h
	mov ah,0
	int 10h

	mov ax, 4c00h
	int 21h
	
;====================================================	
; PROC : set_Pixel  - print red dot
; IN   :  cx= x , dx =y ,al =color
; OUT  : NONE
;====================================================	
proc set_Pixel
	pusha
	
	;מצייר פיקסל בבמיקום וצבע מסויימים
	mov cx ,[x]
	mov dx,[y]
	mov al ,[color]
	mov ah , 0ch
	int 10h
	popa
	
	ret
endp

	
;====================================================	
; PROC : drawLine  - draw line
; IN   :  cx= x , dx =y ,al =color , ah = width
; OUT  : NONE
;====================================================	
proc drawLine
	pusha
;מצייר שורה של 24
	
	mov cl ,24
	jcxz after3
loop1:	
;קריאה לציור פיקסל ולאחר מכן שינוי של האיקס כדי להזיז את ציור הפיקסל לפלוס אחד
	call set_Pixel
	inc [x]
	;לולאה
	loop loop1
	
after3:
	popa
	ret
endp


END start

