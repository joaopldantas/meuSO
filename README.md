# Sistemas Operacionais

Projeto de desenvolvimento de um Kernel simples (x86), implementando bootloader, GDT, IDT e tratamento de interrupções básicas.

## Alunos

- Gabriel de Albuquerque Simplício
- João Pedro Lima Dantas
- João Henrique Alves de Sousa
- Lucas Franca de Melo Batista

## Como Executar
O projeto utiliza `Make` para automatizar a compilação e execução.

Deve ter instalado: `build-essential` / `nasm` / `genisoimage` / `bochs` e `bochs-x`
Para compilar todo o projeto, gerar a ISO e abrir o emulador automaticamente, rode:

```bash
make run
```

## macOS (sem WSL)

No macOS, use Homebrew e a toolchain cross `i686-elf`:

```bash
brew update
brew install nasm bochs xorriso i686-elf-binutils i686-elf-gcc
```

Depois, compile e rode:

```bash
make clean
make run
```

Para abrir no debugger do Bochs (comandos `c`, `r`, `s` no terminal):

```bash
make debug
```

Se o Bochs reclamar de `romimage`/`vgaromimage`, ajuste no `bochsrc.txt` para o caminho do Homebrew:

```bash
brew --prefix bochs
```

Normalmente fica em:

- Apple Silicon: `/opt/homebrew/share/bochs`
- Intel: `/usr/local/share/bochs`

## Entrega parcial (11/02) - CAP: 02, 03
- Booting: Configuração do cabeçalho Multiboot e inicialização do Kernel via GRUB.
- Transição para C: Configuração da pilha (stack) e chamada da função principal kmain em C.

## Entrega parcial (02/03) - CAP: 04, 05, 06
- Output: Implementação de drivers para Framebuffer (saída de vídeo VGA) e Porta Serial (COM1 para logs).
- GDT (Global Descriptor Table): Configuração da segmentação de memória para permitir o acesso aos 4GB de endereçamento em modo protegido.
- IDT & Interrupções: Criação da Interrupt Descriptor Table e configuração do PIC para capturar eventos de hardware, como o Driver de Teclado.

## Entrega parcial (11/03) - CAP: 07
- Módulos GRUB: Carregamento de programa externo via `module /modules/program` no `menu.lst`, com empacotamento do binário em `iso/modules`.
- Multiboot & kmain: Atualização do cabeçalho Multiboot (alinhamento de módulos) e repasse do registrador `ebx` para leitura de `mods_addr` e `mods_count`.
- Execução de Programa: Compilação do programa externo em binário flat (`nasm -f bin`) e salto para seu endereço a partir do kernel em C.
