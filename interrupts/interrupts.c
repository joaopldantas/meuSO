#include "idt.h"
#include "io.h"

void interrupt_handler(struct cpu_state cpu, struct stack_state stack, unsigned int interrupt)
{
    (void)cpu; (void)stack;

    if (interrupt == 33) {
        unsigned char scan_code = read_scan_code();
        (void)scan_code;

        pic_acknowledge(interrupt);
    }
}