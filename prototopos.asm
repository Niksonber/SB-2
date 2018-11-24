%macro sum1	1
	add byte [%1], 1
%endmacro

%macro return 1
	mov EAX, 1
	mov EBX, %0 
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
lp:	cmp ECX, %3 
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
	mov ECX, 0
	mov EAX, [%2]
	mov EBX, 10
l:	cdq
	div EBX
	add EDX, 0x30
	mov byte [%1 + ECX], DL
	inc ECX
;	sub EDX, EDX
	cmp EAX, 0
	jne l
;	inc ECX
	dec ECX
	swap %1, ECX
;	mov byte [%2 + ECX], 0
%endmacro


section .text

global _start
_start:
	atoi n, a, TAMa 
;	sub dword [n], 12
	itoa b, n
	S_OUTPUT 1, b, TAMa
	sum1 a

	return 0


section .data
	a: db "567865456"
   ;      4294967295
	TAMa EQU $-a
	cd: db "isso eh um teste"
	n2: dd 1234
;	b: db "0"
	k: dd 329496712
section .bss
	n: resd	1
	b: resb 100
