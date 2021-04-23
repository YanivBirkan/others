;יניב

IDEAL
MODEL small
STACK 100h
DATASEG
msg_1	DB 10,'Enter a small digit (0-4): $'
msg_2	DB 10,'Enter another small digit (0-4): $'
msg_result1  DB 10,'Here i add the first num to the second = $'
msg_result2  DB ' + $'
msg_result3  DB '= $'
msg_max DB 10, 'the max number = $'
msg_mul DB 10, 'mul the numbers  number = $'
msg_2_digit DB 10, 'result is too big $'
first 		DB ?
second 		DB ?
result 		DB ?	
max DB ?
max2 DB 39h
mul_result DB ?


CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------

	mov dx,offset msg_1  
	mov ah,9
	int 21h

    mov ah,1 
	int 21h
	
; the ASCII codes for keys 0 to 9 are 30h to 39h
	sub al,'0'  ; turn ASCII DIGIT into a number 
	mov [first],al	; store the number

	
	mov dx,offset msg_2 
	mov ah,9
	int 21h


    mov ah,1 
	int 21h
	
; the ASCII codes for keys 0 to 9 are 30h to 39h
	sub al,'0'  ; turn ASCII DIGIT into a number
	;add al,'0'; turn the result to ASCII DIGIT	
	mov [second],al	; store the number
	

	
; print result message
	lea dx,[msg_result1]
	mov ah,9
	int 21h
;print the first var	
	mov dl,[first]
	add dl,'0'
	mov ah,2
	int 21h
; print  another result message
	lea dx,[msg_result2]
	mov ah,9
	int 21h
;print the second var
	mov dl,[second]
	add dl,'0'
	mov ah,2
	int 21h
; print  another result message	
	lea dx,[msg_result3]
	mov ah,9
	int 21h
	; calculate the result
	add al,[first]
	mov [result],al

; print the result	
	mov dl,al
	mov ah,2
	int 21h
;מדפיס 1+5 = 6 

	mov al,[first]
	mov bl,[second]
	cmp al,bl
	; אם 1>2 אז הוא ישר יקפוץ ל B_IS_BIGGER
	;ואם לא אז הוא ימשיך לתוכנית
	jb B_IS_BIGGER
	
A_is_BIGGER :
	mov [max],al ;[first] is bigger
	jmp After1
	;לדלג להמשך במקום להמשיך בתוכנית

B_is_BIGGER :
	mov [max],bl ;[second] is bigger
After1 :
; print  another result message
	lea dx,[msg_max]
	mov ah,9
	int 21h
;print the second var
	mov dl,[max]
	add dl,'0'
	mov ah,2
	int 21h
;mul the numbers 	
	mov al,[first]
	mov bl,[second]
	mul bl
	mov [mul_result],al

	
	
; the ASCII codes for keys 0 to 9 are 30h to 39h
	;sub al,'0'  ; turn ASCII DIGIT into a number
	mov al,[max]
	;משווה האם התוצאה גדולה יותר מBL
	cmp [mul_result],  10
	ja DIGIT_2
	
DIGIT_1 :
	jmp After2
	;לדלג להמשך במקום להמשיך בתוכנית
DIGIT_2:
	lea dx,[msg_2_digit]
	mov ah,9
	int 21h	
	jmp exit
After2:	
; print  another result message
	lea dx,[msg_mul]
	mov ah,9
	int 21h	
	;print the second var
	mov dl,[mul_result]
	add dl,'0'
	mov ah,2
	int 21h
exit:
	mov ax, 4c00h
	int 21h
END start
; --------------------------
	
