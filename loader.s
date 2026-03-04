global loader                   ; Torna o rótulo 'loader' visível para o linker (é o ponto de entrada do ELF)

; ==========================================
; CONSTANTES DO CABEÇALHO MULTIBOOT
; Necessárias para que o bootloader (GRUB) reconheça que isso é um Sistema Operacional
; ==========================================
MAGIC_NUMBER equ 0x1BADB002     ; Número mágico padrão que identifica um kernel Multiboot
FLAGS        equ 0x0            ; Flags de configuração (0 = sem requisitos especiais para o bootloader)
CHECKSUM     equ -MAGIC_NUMBER  ; A soma matemática (magic + flags + checksum) precisa ser igual a zero
KERNEL_STACK_SIZE equ 4096      ; Define o tamanho da pilha do nosso kernel (4096 bytes = 4 KB)

; ==========================================
; SEÇÃO BSS (Block Started by Symbol)
; Usada para declarar variáveis não inicializadas. Ocupa espaço na RAM, mas não pesa no arquivo .elf
; ==========================================
section .bss
align 4                         ; Garante que a memória seja alinhada em blocos de 4 bytes
kernel_stack:                   ; Rótulo que marca o início do espaço da nossa pilha na memória
    resb KERNEL_STACK_SIZE      ; Reserva os 4096 bytes definidos ali em cima para a pilha

; ==========================================
; SEÇÃO TEXT (Código Executável)
; Aqui ficam as instruções do processador e os dados do cabeçalho
; ==========================================
section .text                   ; Início da seção de código (removi os dois pontos ':' que dariam erro)
align 4                         ; O cabeçalho Multiboot OBRIGATORIAMENTE precisa estar alinhado em 4 bytes
    
    ; Escrevendo a assinatura Multiboot nos primeiros bytes do binário
    dd MAGIC_NUMBER             ; dd (Define Double Word) escreve 32 bits do número mágico
    dd FLAGS                    ; Escreve os 32 bits das flags
    dd CHECKSUM                 ; Escreve os 32 bits do checksum
    

extern kmain                    ; Avisa ao compilador que a função 'kmain' existe, mas está em outro arquivo (em C)

; ==========================================
; FUNÇÃO LOADER (Ponto de Entrada)
; É aqui que o GRUB nos "joga" após carregar o SO na memória
; ==========================================
loader:
    ; Configurando a Pilha (Stack):
    ; Na arquitetura x86, a pilha cresce "para baixo" (dos endereços maiores para os menores).
    ; Portanto, apontamos o ESP (Stack Pointer) para o FINAL do espaço de 4KB que reservamos.
    mov esp, kernel_stack + KERNEL_STACK_SIZE
    
    ; Passando o bastão para o C:
    call kmain                  ; Chama a função principal do SO. O retorno (se houver) ficará no registrador EAX.

; Trava de segurança:
.loop:
    jmp .loop                   ; Loop infinito. Se a função kmain() terminar/retornar, o SO trava aqui e não quebra.