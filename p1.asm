IDEAL
MODEL small
STACK 100h



DATASEG
; --------------------------
; Your variables here
; --------------------------

CONST_10 DB 10 
result db ?
num db ?
MOresult db ?
counter db 30
msg1		DB 10, 'BOOM $'
msg2		DB 10, 'NOT boom $'
msg3		db 10,'TRACH (7) $'
msg4		db 10,'not TRACH ( not 7)$'
CODESEG



;====================================================
;   MAIN - example for using the PRINT_AL procedure 
;
;====================================================

start:
	mov ax, @data
	mov ds, ax
	
Loop1:	
	;מדפיס את המספר
	mov al, [counter]
	mov [counter] , al
	call PRINT_AL
	
	;פונקציה לבדיקת חילוק
	call CHECK_DIV_BY_7
	;פונקציה לבדיקת 7
	call CHECK_TRACH

	; new line 
	MOV DL,10
	MOV ah,2
	INT 21H
	
	;חיסור של קאנטר עד 0
	dec [counter]
	cmp [counter],0
	;dec [num]	
	jne Loop1 
exit:
	mov ax, 4c00h
	int 21h
	


;--------------------------------------------------------------------------------------
;    CHECK_DIV_BY_7 : check is number is divided by 7
;    IN :  AL - the number 
;    OUT:  PRINT BOOM / not Boom
;    AFFECTED REGISTERS :  ax  , cl , dx
;--------------------------------------------------------------------------------------


 proc CHECK_DIV_BY_7
; לחלק את המספר ב7
	mov ah,0
	mov al , [counter]
	mov cl ,7
	div cl
	mov [MOresult],ah
	
	;בדיקת השארית וקפיצה לתנאים
	mov al,[MOresult]
	CMP Al,0
	JE boom
	jmp notBoom
notBoom:
	mov dx,offset msg2  
	mov ah,9
	int 21h	
	jmp after
boom:
	mov dx,offset msg1  
	mov ah,9
	int 21h

after:	
	ret
endp	


;--------------------------------------------------------------------------------------
;    CHECK_DIV_BY_7 : check if YECHIDOT is  7
;    IN :  AL - the number 
;    OUT:  PRINT BOOM / not Boom
;    AFFECTED REGISTERS :  ah , cl , dx 
;--------------------------------------------------------------------------------------
proc CHECK_TRACH
; חלק את המספר ב10
	mov ah,0
	mov al , [counter]
	mov cl ,10
	div cl
	mov [MOresult],ah
	
	;בדיקת השארית וקפיצה לתנאים
	mov al,[MOresult]
	CMP Al,7
	JE seven
	jmp notseven
notseven:
	mov dx,offset msg4  
	mov ah,9
	int 21h	
	jmp after2
seven:
	mov dx,offset msg3  
	mov ah,9
	int 21h

after2:	
	ret
endp	


;====================================================	
; PROC : PRINT_AL  - print the decimal number that in AL ( TWO DIGITS ONLY)
; IN   :  AL = the number
; OUT  : NONE
; EFFECTED REGISTERS : DX,AX	
;====================================================

proc PRINT_AL
	; dived by 10 to get two digits
    MOV AH,0
	DIV [CONST_10] ; al-/   ah=%
	
	;print ASHAROT
	MOV DX,AX
	ADD DL,'0'
	ADD DH,'0'
	MOV AH,2
	INT 21H
	
	;PRINT YECHIDOT 
	MOV DL,DH
	INT 21H

	
	ret
endp	

	
END start