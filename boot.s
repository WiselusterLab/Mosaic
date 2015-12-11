.text
.global _start

.code16

_start:
	jmp main16
	nop

	.ascii "WisLabHW"
	.word 0x0200
	.byte 0x01
	.word 0x0001
	.byte 0x02
	.word 0x00E0
	.word 0x0B40
	.byte 0xF8
	.word 0x0009
	.word 0x0012
	.word 0x0002
	.long 0x00000000
	.long 0x00000000
	.byte 0x00
	.byte 0x00
	.byte 0x29
	.long 0x00000000
	.ascii "MosaicX86FD"
	.ascii "FAT12   "

main16:
	mov %cs, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	mov %ax, %ss
	mov $_start, %sp

	cli

	lgdt gdt_ptr

	in $0x92, %al
	or $0x02, %al
	out %al, $0x92

	mov %cr0, %eax
	or $0x00000001, %eax
	mov %eax, %cr0

	ljmp $0x0008, $main32

.code32

main32:
	mov $0x00000010, %eax
	mov %eax, %ds
	mov %eax, %es
	mov %eax, %fs
	mov %eax, %gs
	mov %eax, %ss
	mov $0x000A0000, %esp

	mov $0x07200720, %eax
	mov $0x000B8000, %edi
	mov $0x000003E8, %ecx
	push %edi
	rep stosl

	mov $0x0A, %ah
	mov $msg, %esi
	pop %edi
	mov $msg_len, %ecx
1:
	lodsb
	stosw
	loop 1b

	jmp .

gdt:
	.quad 0x0000000000000000
	.quad 0x00CF9A000000FFFF
	.quad 0x00CF92000000FFFF

gdt_ptr:
	.word . - gdt - 0x0001
	.long gdt

msg:
	.ascii "Mosaic's now in protected mode!"
	.equ msg_len, . - msg

	.org 0x01FE
	.word 0xAA55
