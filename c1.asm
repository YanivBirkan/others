IDEAL
MODEL small
STACK 100h

DATASEG
; --------------------------
; Your variables here
; --------------------------

CONST_10 DB 10 
chr1 db ?
chr2 db ? 
sum db ?
sum2 db ?
ten db 10
msg1	DB 10,'Enter a  digit : $'
msg2	DB 10,'Enter another  digit : $'
msg3	DB 10,'sum of 2 numbers =  $'
ko db 10, '********** $'
MOresult db ?
Dresult db ?
mulResult db ?
CODESEG
;====================================================
;   MAIN - example for using the PRINT_AL procedure 
;====================================================

start:
	
	mov ax, @data
	mov ds, ax

	call ADD_TWO_DIGIT
	mov al,[sum] 
	
	mov [sum] ,al
	
	; חילוק ב10
	;העברה של השארית למשתנה
	mov ah,0
	mov cl ,10
	div cl
	mov [MOresult],ah
	mov [Dresult],al
	

	; העברה לסי אל את תוצאת החילוק
	; לאחר סיום הלולאה קיפצה לאפטר
	
	mov cl ,[Dresult]
	jcxz after
	
loop1:	
	;הודעה
	mov dx,offset ko  
	mov ah,9
	int 21h
	
	; new line 
	MOV DL,10
	MOV ah,2
	INT 21H
	
	;לולאה
	loop loop1
	
	
	
after:
	mov cl ,[MOresult]
	jcxz after2
	
loop2:	
	;הדפסה של כוכבית
	MOV DL, '*' 
	MOV AH,02h
	INT 21H
	
	;לולאה
	loop loop2
after2:	
		; new line 
	MOV DL,10
	MOV ah,2
	INT 21H
exit:
	mov ax, 4c00h
	int 21h
	

;====================================================	
; PROC : PRINT_AL  - calc the sum of 2 numbers
; IN   :  AL = the number
; OUT  : NONE
; EFFECTED REGISTERS : AX	,dx
;====================================================
proc ADD_TWO_DIGIT

	;הודעה
	mov dx,offset msg1  
	mov ah,9
	int 21h
	
	
	;קליטה של מספר
    mov ah,1 
	int 21h
	
	;הפיכה מאסקי ושמירה במשתנה
	sub al,'0'  
	mov [chr1],al	
	
	
	
	;הודעה
	mov dx,offset msg2  
	mov ah,9
	int 21h
	
	
	;קליטה של מספר
    mov ah,1 
	int 21h
	
	;הפיכה מאסקי ושמירה במשתנה
	sub al,'0'  
	mov [chr2],al	
	
	
	;מעבר שורה
	;mov dl, 10 
	;mov ah, 2h	
	;int 21h

	;חיבור
	mov al ,[chr1]
	add al , [chr2]
	mov [sum] ,al
	mov [sum2] ,al
	
	;הודעה
	mov dx,offset msg3  
	mov ah,9
	int 21h
	
	;פונקציה שמדפיסה
	mov al, [sum]
	;mov [sum],al
	call PRINT_AL
	
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