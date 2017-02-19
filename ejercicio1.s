/////////////////////////////////////////////////////
/// Lab ARMv8 - Calculadora
/// Para compilar gcc -o calculadora ejercicio1.s
/// Para ejecutar ./calculadora
/////////////////////////////////////////////////////

.data
message: .asciz "El resultado de la operacion es: %d\n"
error_message: .asciz "No se recibieron 3 parametros\n"
no_operation: .asciz "Operacion invalida\n"
.text
  .globl main

sum:
    // x0 = x0 + x1
    // aqui solo hay que utilizar la funcion add
    add x0, x0, x1
    ret
resta:
    subs x0, x0, x1
    ret
mult:
    mul x0, x0, x1
    ret
div:
    sdiv x0, x0, x1
    ret
and:
    and x0, x0, x1
    ret
or:
    orr x0, x0, x1
    ret
xor:
    neg x2, x0
    neg x3, x0
    and x2, x2, x1
    and x3, x3, x0
    orr x0, x2, x3
    ret
sll:
    lsl x0, x0, x1
    ret
srl:
    mov x2, #1
    lsl x2, x2, #63
    neg x2, x2
    cmp x1, #0
    beq finish 
    ror x0, x0, #1
    and x0, x0, x2
    b srl
finish:
    ret
sra:
    asr x0, x0, x1
    ret

main:
    add SP, SP, #-16
    str x30, [SP]         // guardamos x30 para poder llamar a funciones
    cmp x0, #4
    bne error

no_error:
    add SP, SP, #-32
    str x19,[SP]
    str x20,[SP,#16]
    mov x19, x1
    ldr x0,[x19,#8]
    bl atoi //llamada a atoi
    mov x20, x0
    ldr x0, [x19,#24]
    bl atoi
    mov x1, x0
    mov x0, x20
    ldr x2,[x19,#16]
    ldrb w2,[x2,0]
    ldr x19,[SP]
    ldr x20,[SP,#16]
    add SP, SP, #32

    cmp w2,'+'
    beq case_sum
    cmp w2,'-'
    beq case_sub
    cmp w2,'*'
    beq case_mul
    cmp w2,'/'
    beq case_div
    cmp w2,'&'
    beq case_and
    cmp w2,'|'
    beq case_or
    cmp w2,'^'
    beq case_xor
    cmp w2,'<'
    beq case_sll

    ldr x0,=no_operation
    bl printf
    b exit
    
case_sum:
    bl sum
    b display
case_sub:
    bl resta
    b display
case_mul:
    bl mult
    b display
case_div:
    bl div
    b display
case_and:
    bl and
    b display
case_or:
    bl or
    b display
case_xor:
    bl xor
    b display
case_sll:
    bl sll
    b display

display:
    mov x1, x0
    ldr x0,=message
    bl printf
    b exit

error:
   ldr x0,=error_message
   bl printf
   b exit

exit:
    // restauramos los registros
    ldr x30, [SP]
    add SP, SP, #16 // retornamos el espacio prestado del stack
    ret // retornamos al SO

