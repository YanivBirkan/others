; IDEAL
; MODEL small

; STACK 100h
; DATASEG
; note dw 2394h ; 1193180 / 131 -> (hex)
; message db 'Press any key to exit',13,10,'$'
; CODESEG
; start :
; mov ax, @data
; mov ds, ax
;;open speaker
; in al, 61h
; or al, 00000011b
; out 61h, al
;;send control word to change frequency
; mov al, 0B6h
; out 43h, al
;;play frequency 131Hz
; mov ax, [note]
; out 42h, al ; Sending lower byte
; mov al, ah
; out 42h, al ; Sending upper byte
;;wait for any key
; mov dx, offset message
; mov ah, 9h
; int 21h

; mov ah, 1h
; int 21h
;;close the speaker
; in al, 61h
; and al, 11111100b
; out 61h, al
; exit :
; mov ax, 4C00h
; int 21h
; END start



; IDEAL
; MODEL small
; STACK 100h
; DATASEG
; Clock equ es:6Ch
; StartMessage db 'Counting 10 seconds. Start...',13,10,'$'
; EndMessage db '...Stop.',13,10,'$'
; CODESEG
; start :
; mov ax, @data
; mov ds, ax
;;wait for first change in timer
; mov ax, 40h
; mov es, ax
; mov ax, [Clock]
; FirstTick :
; cmp ax, [Clock]

; je FirstTick
;;print start message
; mov dx, offset StartMessage
; mov ah, 9h
; int 21h
;;count 10 sec
; mov cx, 182 ; 182x0.055sec = ~10sec
; DelayLoop:
; mov ax, [Clock]
; Tick :
; cmp ax, [Clock]
; je Tick
; loop DelayLoop
;;print end message
; mov dx, offset EndMessage
; mov ah, 9h
; int 21h
; quit :
; mov ax, 4c00h
; int 21h
; END start


IDEAL
MODEL small
STACK 100h
DATASEG
color db 12
CODESEG
start :
mov ax,@data
mov ds,ax
; Graphics mode
mov ax,13h
int 10h
; Initializes the mouse
mov ax,0h
int 33h
; Show mouse
mov ax,1h
int 33h
; Loop until mouse click

MouseLP :
mov ax,3h
int 33h
cmp bx, 01h ; check left mouse click
jne MouseLP
; Print dot near mouse location
shr cx,1 ; adjust cx to range 0-319, to fit screen
sub dx, 1 ; move one pixel, so the pixel will not be hidden by mouse
mov bh,0h
mov al,[color]
mov ah,0Ch
int 10h
; Press any key to continue
mov ah,00h
 int 16h
; Text mode
mov ax,3h
int 10h
exit :
mov ax,4C00h
int 21h
END start

;;;
; Set graphics mode 320x200x256
mov ax,13h
int 10h
; Read dot
mov bh,0h
mov cx,[x]
mov dx,[y]
פרק 13 – כלים לפרויקטים 277
277
mov ah,0Dh
int 10h