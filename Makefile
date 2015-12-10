AS = as
ASFLAGS = 
BINARY = boot.bin
DD = dd
IMAGE = boot.img
LD = ld
LDFLAGS = -Ttext=0x7C00 --oformat=binary
OBJECT = boot.o
QEMU = qemu-system-x86_64
SOURCE = boot.s

.PHONY: all clean run

all: ${IMAGE}
	

run: ${IMAGE}
	${QEMU} $^

${IMAGE}: ${BINARY}
	${DD} if=/dev/zero of=${IMAGE} bs=1 count=1474560
	${DD} if=${BINARY} of=${BINARY} bs=512 count=1 conv=notrunc

${BINARY}: ${OBJECT}
	${LD} ${LDFLAGS} -o $@ $^

${OBJECT}: ${SOURCE}
	${AS} ${ASFLAGS} -o $@ $^
