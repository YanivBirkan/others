IDEAL
MODEL small
STACK 100h
DATASEG
;ex2
ten         DB 10
NUMBER		DB 27
msg1		DB 10, 'Enter a  digit: $'
msg2		DB 10, 'NOT PERFECT $'
msg3 		DB 10, 'result $'
msg4		DB 10, ' the number is smaller then 200 $'
msg5		DB 10, ' the number is bigger then 200  $'
msg5_2 		DB 10, ' the  number - 180 = $'
msg6		DB 10, 'Enter a  digit: $'
msg7		DB 10, 'perfect $'
msg8		DB 10, ' not perfect $'

MOresult		DB ?
DIGIT1 		DB ?
DIGIT2 		DB ?


result db ?

CODESEG
start:
	mov ax, @data
	mov ds, ax


	; קולט מספר
	mov dx,offset msg1  
	mov ah,9
	int 21h

    mov ah,1 
	int 21h
	
; the ASCII codes for keys 0 to 9 are 30h to 39h
	sub al,'0'  ; turn ASCII DIGIT into a number 
	mov [DIGIT1],al	; store the number
	
	
	;הכפלה 
	mov bl,[NUMBER]
	mov al,[DIGIT1]
	mul bl
	mov [result] , al
	;השוואה ל200 ואם המספר גדול ממתים קופצים לביגר ואם לא קופצים לסמאלר
	mov al,[result]
	CMP Al,200
	ja Biger
	
smaller:
	;הדפסה וקפיצה להמשך
	mov dx,offset msg4
	mov ah,9
	int 21h	
	jmp after
	
Biger:
	;הודעה
	mov dx,offset msg5
	mov ah,9
	int 21h	
	
	;חיסור מהריסולט 180 ושמירה חדשה של הריסולט של המספר החדש
	sub al , 180
	mov [result] , al
	
	;הודעה
	mov dx,offset msg5_2
	mov ah,9
	int 21h	
	
	;הדפסה כדו ספרתי
	mov al,[result]
	mov ah, 0
	div [ten]
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	int 21h	
	jmp after
after:

 ; קולט מספר חדש
	mov dx,offset msg1  
	mov ah,9
	int 21h

    mov ah,1 
	int 21h 
	
	sub al,'0'  ; turn ASCII DIGIT into a number 
	mov [DIGIT2],al	; store the number	
	;השוואה ל0 ואם הם שווים יציאה מהתוכנית אחרת להמשיך
	mov al,[DIGIT2]
	CMP Al,0
	je exit
	
after2:
	; לחלק את הריסולט בדיגיט שקלטנו 
	mov ah,0
	mov al , [result]
	mov cl ,[DIGIT2]
	div cl
	mov [MOresult],ah
	;אם השארית של החלוקה שווה ל0 אז קופצים לפרפקט אחרת קופצים לנוט פרפקט
	mov al,[MOresult]
	CMP Al,0
	JE perfect
	jmp notPerfect
notPerfect:
	mov dx,offset msg8  
	mov ah,9
	int 21h	
	jmp exit
perfect:
	mov dx,offset msg7  
	mov ah,9
	int 21h
exit:
	mov ax, 4c00h
	int 21h
END start