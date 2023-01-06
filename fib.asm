; nasm -f elf64 fib.asm
; ld fib.o -o fib.x
; gdb fib.x

%define maxChars 3
%define openrw  2102o
%define userWR 644o 

section .data
    str: db "Fibonacci requerido: ", 10, 0
    str2: equ $ - str
    
    erro: db "Digito invalido!",10, 0
    erro2: equ $ - erro

    erro3: db "Fim de Execução! Estouro do tamanho do registrador!", 10
    erro4: equ $ - erro3 
    
    inicio_arq: db "fib("
    inicio_arq2: equ $ - inicio_arq
    
    fim_do_arq: db ").bin", 0 
    fim_do_arq2: equ $ - fim_do_arq   
    
section .bss
    entrada: resb maxChars
    entrada2: resd 1
    nome_arq: resb 255
    f: resd 1
    buffer: resb 1
    num: resq 1
    valor: resq 1
    
section .text
    global _start

_start:
    ;zera os registradores
    xor rax, rax
    xor rdi, rdi
    xor rax, rax
    xor rsi, rsi
    xor edx, edx
    xor rdx, rdx
    xor ebx, ebx 

;----------------------------------

escrever:
    mov rax, 1 
    mov rdi, 1
    lea rsi, [str]
    mov edx, str2
    syscall

leitura:
    mov dword [entrada2], maxChars
    mov rax, 0
    mov rdi, 1
    lea rsi, [entrada]
    mov edx, entrada2
    syscall
    mov [entrada2], eax

;----------------------------------

;string para int
conversao:
    xor rax, rax
    lea esi, [entrada]
    
    mov al, [esi] ;move o 1º byte para dentro
    sub al, "0" ;converte o 1º caracter para int
    inc esi  ;incrementa para pegar o segundo byte
    
    mov bl, [esi]
    cmp bl, 10  ;compara para ver se o número tem apenas 1 dígito
    jne verifica2digitos

    mov [num], rax
    jmp fibo

    verifica2digitos:
        inc esi ; incrementa o ponteiro
        mov cl, [esi]
        cmp cl, 10 ;compara para ver se o número tem 2 dígitos
        jne EncerrarPrograma

    sub bl, "0"
    imul rax, 10
    add al, bl

    mov [num], rax

    cmp rax, 93   ;como fib de 94 para cima estoura o tamanho do reg, o código se encerra  
    jg PararPrograma

;----------------------------------

fibo:   
    xor r9, r9
    xor r13, r13 ;fib = 0
    mov r14, 0x0001 ;fib1 = 1

    ;condição se for um zero
    cmp rax, 0
    je EncerrarPrograma

    inicio:
        cmp r9b, [num]
        je ConcatenacaoNomeArquivo 

        mov r15, r13 ;aux = fib
        add r15, r14 ;aux = aux+fib1
        mov r13, r14 ;fib = fib1
        mov r14, r15 ;fib1 = aux
        inc r9
        jmp inicio

;----------------------------------

ConcatenacaoNomeArquivo:    
    xor r15, r15
    xor r11, r11
    xor r14, r14

    mov r11, 4
    mov r14, qword [entrada]
    mov r15, qword [fim_do_arq]
    mov [inicio_arq + r11], r14
    add r11, [entrada2]
    dec r11
    mov [inicio_arq + r11], r15 

    mov rax, 2         
    lea rdi, [inicio_arq]
    mov esi, openrw     
    mov edx, userWR     
    syscall

    mov [f], eax

escreve_arquivo: 
    mov qword[valor], r13
    mov rax, 1           
    mov edi, [f] 
    lea rsi, [valor]
    mov edx, 8     
    syscall

fecha:
    mov rax, 3 
    mov edi, [f]
    syscall
    jmp fim

;----------------------------------

PararPrograma:
    mov rax, 1
    mov rdi, 1
    lea rsi, [erro3]
    mov edx, erro4
    syscall
    jmp fim

;----------------------------------

EncerrarPrograma:
    mov rax, 1
    mov rdi, 1
    lea rsi, [erro]
    mov edx, erro2
    syscall

;----------------------------------

fim:
    mov rax, 60
    mov rdi, 0
    syscall
