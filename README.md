# Fibonacci-Nasm


### Um código iterativo que calcule o n-éssimo número fibonacci iterativo.<br>

<br>**Funcionamento:**<br>
 - Máximo de dígitos: 2<br>
 - 3 dígitos ou 0: mensagem de falha genérica, limpeza de buffer e encerramento<br>
 - Verificação de limites de representação<br>

<br>**Sobre o código:**<br>
- Código montável, ligável e executável<br>
- Sem recursividade<br>
- Sintaxe Intel x64_86<br>
 <br>
 
**Para montar e ligar use os seguintes comandos:**
 ```
nasm -f elf64 fib.asm
ld fib.o -o fib.x

 ```
 
 **Para executar use os seguintes comandos:**
 ```
./fib.x

 ```
