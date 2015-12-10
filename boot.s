.text
.global _start

.code16

_start:
	jmp main_16
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

main_16:
	mov %cs, %ax
	mov %ax, %ds

	cli

	lgdt gdt_ptr

	in $0x92, %al
	or $0x02, %al
	out %al, $0x92

	mov %cr0, %eax
	or $0x01, %al
	mov %eax, %cr0

	ljmp $0x0008, $main_32

.code32

main_32:
	mov $0x00000010, %eax
	mov %eax, %es
	mov $0x04400440, %eax
	mov $0x000B8000, %edi
	mov $0x000003E8, %ecx
	rep stosl

	jmp .

gdt:
	.quad 0x0000000000000000
	.quad 0x00CF9A000000FFFF
	.quad 0x00CF92000000FFFF

gdt_ptr:
	.word . - gdt - 0x0001
	.long gdt

	.org 0x01FE
	.word 0xAA55
