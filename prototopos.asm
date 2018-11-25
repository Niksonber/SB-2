%macro sum1	1
    add byte [%1], 1
%endmacro

%macro return 1
    mov EAX, 1
    mov EBX, %1 
    int 80h
%endmacro

%macro mult 1
    mov ebx, [%1]
    mov edx, eax
    imul ebx
    cmp eax,0
    jl low
gre:     
    cmp edx, 0x00000000
    je contmul
    jmp over
low:
    cmp edx, 0xffffffff
    je contmul
over:
    S_OUTPUT 1, o, 8
    return 1
contmul:
%endmacro

%macro jmpn 1
    cmp EAX,0
    jl %1
%endmacro

%macro jmpp 1
    cmp EAX,0
    jg %1
%endmacro

%macro jmpz 1
    cmp EAX,0
    jz %1
%endmacro

%macro copy 2
    mov EBX, [%1]
    mov [%2], EBX
%endmacro

%macro load 1
	mov EAX, [%1]
%endmacro

%macro store 1
	mov [%1], EAX
%endmacro


%macro stop 0
	mov EAX, 1
	mov EBX, 0 
	int 80h
%endmacro

%macro S_INPUT 3
	mov EAX, 3
	mov EBX, %1
	mov ECX, %2
	mov EDX, %3
	int 80h
%endmacro

%macro S_OUTPUT 3
	mov EAX, 4
	mov EBX, %1
	mov ECX, %2
	mov EDX, %3
	int 80h
%endmacro

%macro swap 2
	mov EAX, %1
	mov ECX, %2
	add ECX, %1
l1:	cmp EAX, ECX
	jae co
	mov BL, [EAX]
	mov DL, [ECX]
	mov [EAX], DL
	mov [ECX], BL
	inc EAX
	dec ECX
	jmp l1
co:
	
%endmacro

%macro atoi 3
    mov ECX, 0
    mov EAX, 0
    mov EBX, 10
lp: cmp ECX, %3 
    jae cont
    mul EBX
    add AL, [%2 + ECX]
    adc AH, 0
    sub EAX, 0x30
    inc ECX
    jmp lp
cont:
    mov dword [%1], EAX
%endmacro

%macro itoa 2
    enter 0,0
    pusha
    mov ECX, 0
    mov EAX, [%2]
    mov EBX, 10
    cmp EAX, 0
    jge l
    neg EAX
l:  cdq
    div EBX
    add EDX, 0x30
    mov byte [%1 + ECX], DL
    inc ECX
    ;sub EDX, EDX
    cmp EAX, 0
    jne l
    ;inc ECX
    cmp word [%2], 0
    jge s
    mov byte [%1 + ECX ], '-'
    inc ECX
s:  mov EAX, ECX
    dec ECX
    swap %1, ECX
    ;S_OUTPUT 1, %1, ECX
    ;mov byte [%2 + ECX], 0
%endmacro
%macro ler 2
    mov eax, 3
    mov ebx, 0
    mov ecx, [%1]
    mov edx, %2
    int 80h
%endmacro

%macro escreve 2
    mov eax, 4
    mov ebx, 1
    mov ecx, [%1]
    mov edx, %2
    int 80h
%endmacro

C_INPUT: ; INPUT(* char) 
    enter 0,0
    push eax
    push ebx
    push ecx
    push edx
    ler ebp+8, 1 
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret

INPUT: ; INPUT(* int) 
    enter 6,0
    push eax
    push ebx
    push ecx
    push edx
    mov dword [ebp-6], 0
    mov byte [ebp-2], 0
    mov eax, 3
    mov ebx, 0
    mov ecx, ebp
    sub ecx, 1
    mov edx, 1
    int 80h
    cmp byte [ebp-1], '-'
    jne pli
    mov byte [ebp-2], '-'
loopinput:
    mov eax, 3
    mov ebx, 0
    mov ecx, ebp
    sub ecx, 1
    mov edx, 1
    int 80h
pli:
    mov esi, [ebp-6]
    cmp byte [ebp-1], 0xa   ;confere se eh fim de linha
    je fiminput
    cmp byte [ebp-1], 0x30  ;verifica se eh um numero valido
    jb inv
    cmp byte [ebp-1], 0x39  ;verifica se eh um numero valido
    ja inv
    mov EAX, 10
    mul dword [ebp-6]
    add byte AL, [ebp-1]
    adc AH, 0
    sub EAX, 0x30
    mov dword [ebp-6], eax
    jmp loopinput
inv: 

fiminput:
    cmp byte [ebp-2], '-'
    jne fimfiminput
    neg dword [ebp-6]
fimfiminput:
    mov eax, [ebp-6]
    mov ebx, [ebp+8]
    mov dword [ebx], eax
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
ret

section .text

global _start
_start:
    mov ebp, esp; for correct debugging
    push n
    call INPUT
;	atoi n, a, TAMa 
;	sub dword [n], 12
;        mov eax, 1023  
 ;       mult n2
 ;       mov [n],eax
        itoa b, n
        S_OUTPUT 1, b, 10
       ; S_OUTPUT 1, b, TAMa
        sum1 a
        mov eax, 10
      ;  mult n2

	stop


section .data
	a: db "567865456"
   ;      4294967295
	TAMa EQU $-a
	cd: db "isso eh um teste"
        o:  db "overflow"
	n2: dd 10
;	b: db "0"
	k: dd 329496712
section .bss
	n: resd	1
	b: resb 100

