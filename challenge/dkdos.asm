IDEAL
MODEL small
STACK 100h
DATASEG
    message db 'MS-DOS KIPOD SHOP', 10, 13
            db '------------------------------------------------', 10, 13, 10, 13
            db 'Wanna buy some KIPODIM?', 10, 13
            db 'First, I have to make sure you', 39, 're allowed to.', 10, 13, 10, 13
            db 'Please log in with you password:', 10, 13, '$'

    password db 9, 11 dup (0)
    hash dw 0

    validPass db 10, 13, 10, 13, 'Congrats! You are allowed to buy some KIPODIM!', 10, 13
              db 'You can do it with `nc ctf.kaf.sh 6000`', 10, 13, '$'
    invalidPass db 10, 13, 'No KIPODIM today :|', 10, 13, '$'

CODESEG
proc HashPassword
    passwordLength equ [bp+8]
    passwordAddress equ [bp+6]
    hashAdress equ [bp+4]

    push bp
    mov bp, sp

    mov bx, passwordAddress
    mov cx, passwordLength

HashLoop:
    mov cl, [bx]
    mov ah, 0

    push bx
        mov bx, hashAdress
        shr [word ptr bx], 2
        sub [word ptr bx], ax
    pop bx

    inc bx

    dec cx
    cmp cx, 0
    jne HashLoop

    pop bp

    ret
endp HashPassword

proc DisplayMessage
    lea dx, [message]
    mov ah, 9h
    int 21h
    
    ret
endp DisplayMessage

proc GetPassword
    mov [word ptr cs:15h], 0701h

    lea dx, [password]
    mov ah, 0Ah
    int 21h
    
    ret
endp GetPassword

proc Branch
    pop ax

    lea bx, [cs:07Ah]
    cmp ax, bx

    je InvalidPassword

    lea bx, [cs:0A0h]
    cmp ax, bx

    je ValidPassword

    lea bx, [cs:0AAh]
    cmp ax, bx

    je Exit

    jmp ax
endp Branch

Start:
	mov ax, @data
	mov ds, ax

    call DisplayMessage
    
    mov [word ptr cs:11h], 027D1h
    mov [word ptr cs:13h], 027D1h

    call GetPassword

    mov al, [password+9]
    test al, al
    jz JumpToInvalidPassword

    cmp [password+1], 8
    je CallHashPassword

JumpToInvalidPassword:
    call Branch ; Here -> invalid

CallHashPassword:
    lea bx, [password+1]

    mov cl, [bx]
    mov ch, 0

    push cx

    inc bx
    push bx

    lea bx, [hash]
    push bx

    mov [word ptr cs:09h], 078Ah

    call HashPassword
    add sp, 6

VerifyPassword:
    cmp [word ptr hash], 0CFE1h
    jne InvalidPassword

    call Branch ; Here -> valid

InvalidPassword:
    lea dx, [invalidPass]
    mov ah, 9h
    int 21h

    call Branch ; Here -> exit

ValidPassword:
    lea dx, [validPass]
    mov ah, 9h
    int 21h

Exit:
	mov ax, 4c00h
	int 21h

END Start
