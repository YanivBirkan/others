IDEAL
MODEL small
STACK 100h
DATASEG

KOTERET db   '****  S N A K E -  just a start   ( use WASD as arrows+ Q to quit)  ***$'
smily_x db  10
smily_y db  10
KEY_PRESSED   DB ?


CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------

; CLEAR SCREEN   ניקוי מסך    NIKUY MASACH
	mov ax, 2h
	int 10h
	
; HIDE CURSOR 	
	MOV CX,2607h
	MOV AH,01
	INT 10H

; PRINT KOTERET
	mov  dx, offset KOTERET
	mov  ah, 9h
	int  21h
  
draw_one_smily :

; MOVE CURSOR TO X Y
	mov dh, [smily_y] 	;  row 
	mov dl, [smily_x] 	; column
	mov bh, 0   	; page number
	mov ah, 2		; 2=MOVE CURSOR		
	int 10h


;DRAW SMILY  - ascii 2 at cursor position
	mov al, 2 		; al = ASCII code of character to print
	mov bh, 0 		; bh = Background color
	mov bl, 0Eh 	; bl = Foreground color
	mov cx, 1 		; cx = number of times to write character
	mov ah, 9		; 9= print character with color
	int 10h

; wait and read keyboard - into AL
    mov ah,7 ; without echo on screen
	int 21h

; check what key was pressed	
    cmp al,'q' ; is it Quit ?
	je 	exit
	
; check WASD - W=up A=left S=down D=right	
    cmp al,'d'
	jne no_d
	inc [smily_x]	; change location one place right
	;check borders
	jmp key_done
no_d:
    cmp al,'a'
	jne no_a
	dec [smily_x]
	;check borders
	jmp key_done
no_a:
    cmp al,'w'
	jne no_w
	dec [smily_y]
	;check borders
	jmp key_done
no_w:
    cmp al,'s'
	jne no_s
	inc [smily_y]
	;check borders
	jmp key_done

no_s:
key_done:
	jmp  draw_one_smily 

	
exit:
	; CLEAR SCREEN   
	mov ax, 2h
	int 10h

	mov ax, 4c00h
	int 21h

END start