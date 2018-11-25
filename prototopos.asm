%macro endl 0
    mov EAX, 4
    mov EBX, 1
    mov ECX, endlineeee
    mov EDX, 1
    int 80h
%endmacro

%macro sum1 1
    add byte [%1], 1
%endmacro

%macro return 1
    mov EAX, 1
    mov EBX, %1 
    int 80h
%endmacro

%macro ler 2
    mov EAX, 3
    mov EBX, 0
    mov ECX, %1
    mov EDX, %2
    int 80h
%endmacro

%macro escreve 2
    mov EAX, 4
    mov EBX, 1
    mov ECX, %1
    mov EDX, %2
    int 80h
%endmacro

mult:
    enter 0,0
    push EBX
    push ECX
    push EDX
    mov EBX, [ebp+8]
    mov EBX, [EBX]
    mov EDX, EAX
    imul EBX
    cmp EAX,0
    jl low
gre:     
    cmp EDX, 0x00000000
    je contmul
    jmp over
low:
    cmp EDX, 0xffffffff
    je contmul
over:
    escreve dword overflow101010, TAMoverflow101010
    return 1
contmul:
    pop EDX
    pop ECX
    pop EBX
    leave
ret 4

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

swap: ; swap(**char, **char)
     enter 0, 0
     pusha
    mov EAX, [EBP+12]
    mov ECX, [EBP+8]
    add ECX, EAX
l1: cmp EAX, ECX
    jae co
    mov BL, [EAX]
    mov DL, [ECX]
    mov [EAX], DL
    mov [ECX], BL
    inc EAX
    dec ECX
    jmp l1
co:
    popa
    leave   
ret 8

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


S_INPUT: ; INPUT(** char, int) 
    enter 0,0
    push EBX
    push ECX
    push EDX
    mov ECX, [EBP+8]
    mov EBX, [EBP+12] ; inicio do vetor
    add ECX, EBX    ; fim do vetor
loopsinput:
    push EBX
    call C_INPUT
    cmp byte [EBX], 0xa   ;confere se eh fim de linha
    je fimsinput
    inc EBX
    cmp EBX, ECX
    jb loopsinput
    mov byte [EBX], 0xa 
fimsinput:
    mov EAX, EBX
    sub EAX,[EBP+12]
    pop EDX
    pop ECX
    pop EBX
    leave
ret 8

S_OUTPUT: ; INPUT(** char, int) 
    enter 0,0
    push EBX
    push ECX
    push EDX
    mov ECX, [EBP+8]
    mov EBX, [EBP+12] ; inicio do vetor
    add ECX, EBX    ; fim do vetor
loopsoutput:
    push EBX
    call C_OUTPUT
    cmp byte [EBX], 0xa   ;confere se eh fim de linha
    je fimsinput
    inc EBX
    cmp EBX, ECX
    jb loopsoutput
    endl
fimsoutput:
    mov EAX, EBX
    sub EAX,[EBP+12]
    pop EDX
    pop ECX
    pop EBX
    leave
ret 8



C_INPUT: ; INPUT(* char) 
    enter 0,0
    push EBX
    push ECX
    push EDX
    ler [EBP+8], 1 
    ;endl
    pop EDX
    pop ECX
    pop EBX
    leave
ret 4
    
C_OUTPUT: ; OUTPUT(* char) 
    enter 0,0
    push EAX
    push EBX
    push ECX
    push EDX
    escreve dword [EBP+8], 1 
    ;endl
    pop EDX
    pop ECX
    pop EBX
    pop EAX
    leave
ret 4

INPUT: ; INPUT(* int) 
    enter 6,0
    push EAX
    push EBX
    push ECX
    push EDX
    mov dword [EBP-6], 0
    mov byte [EBP-2], 0
    mov EAX, 3
    mov EBX, 0
    mov ECX, EBP
    sub ECX, 1
    mov EDX, 1
    int 80h
    cmp byte [EBP-1], '-'
    jne pli
    mov byte [EBP-2], '-'
loopinput:
    mov EAX, 3
    mov EBX, 0
    mov ECX, EBP
    sub ECX, 1
    mov EDX, 1
    int 80h
pli:
    mov ESI, [EBP-6]
    cmp byte [EBP-1], 0xa   ;confere se eh fim de linha
    je fiminput
    cmp byte [EBP-1], 0x30  ;verifica se eh um numero valido
    jb inv
    cmp byte [EBP-1], 0x39  ;verifica se eh um numero valido
    ja inv
    mov EAX, 10
    mul dword [EBP-6]
    add byte AL, [EBP-1]
    adc AH, 0
    sub EAX, 0x30
    mov dword [EBP-6], EAX
    jmp loopinput
inv: 
    escreve dword numInvalido101010, TAMnumInvalido101010
fiminput:
    cmp byte [EBP-2], '-'
    jne fimfiminput
    neg dword [EBP-6]
fimfiminput:
    mov EAX, [EBP-6]
    mov EBX, [EBP+8]
    mov dword [EBX], EAX
    pop EDX
    pop ECX
    pop EBX
    pop EAX
    leave
ret 4


OUTPUT: ; OUTPUT(**char, int) 
    enter 4,0
    pusha
    mov ECX, 0
    mov EAX, [EBP+8]
    mov EBX, [EBP+12]
    mov dword [EBP-4],10
    cmp EAX, 0
    jge l
    neg EAX
l:  cdq
    div dword [EBP-4]
    add EDX, 0x30
    mov byte [EBX + ECX], DL
    inc ECX
    ;sub EDX, EDX
    cmp EAX, 0
    jne l
    ;inc ECX
    mov EAX, [EBP+8]
    cmp EAX, 0
    jge s
    mov byte [EBX + ECX ], '-'
    inc ECX
s:  mov EAX, ECX
    dec ECX
    push EBX
    push ECX
    call swap
    ;mov byte [%2 + ECX], 0
    mov EDX, EAX
    mov ECX, EBX
    mov EAX, 4
    mov EBX, 1
    int 80h
    endl
    add EAX,1
    popa
    leave
ret 8


section .text

global _start
_start:
    mov EBP, ESP; for correct debugging
    push n
    call INPUT
    push b
    push dword [n]
    call OUTPUT
    push d
    push dword 100
    call S_INPUT
    push d
    push dword 100
    call S_OUTPUT
    stop


section .data
    a: db "12"
    ;4294967295
    TAMa EQU $-a
    cd: db "isso eh um teste", 0xa
    
    ;linhas adicionadas automaticamente para avisar de erros durante a execução
    overflow101010:  db "overflow", 0xa
    TAMoverflow101010 EQU $-overflow101010
    numInvalido101010:  db "Esperava-se um numero, um caracter invalido foi digitado", 0xa
    TAMnumInvalido101010 EQU $-numInvalido101010
    
    n2: dd 10
    ;b: db "0"
    k: dd 329496712
    endlineeee: db 0xa
section .bss
    n: resd 1
    b: resb 100
    d: resb 100
