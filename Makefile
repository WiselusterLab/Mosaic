AS = ${CROSS_COMPILE}as
AS_FLAGS = ${ASFLAGS}
BINARY = boot.bin
CROSS_COMPILE = 
DD = dd
DD_FLAGS = 
IMAGE = boot.img
LD = ${CROSS_COMPILE}ld
LD_FLAGS = -Ttext=0x7C00 --oformat=binary ${LDFLAGS}
OBJECT = boot.o
RM = rm
RM_FLAGS = -rf
QEMU = qemu-system-i386
QEMU_FLAGS = 
SOURCE = boot.s
TARGET = ${IMAGE}

.PHONY: all clean install

all: ${TARGET}
	

clean: 
	${RM} ${RM_FLAGS} ${BINARY} ${IMAGE} ${OBJECT}

run: ${TARGET}
	${QEMU} ${QEMU_FLAGS} ${^}

${BINARY}: ${OBJECT}
	${LD} ${LD_FLAGS} ${^} -o ${@}

${IMAGE}: ${BINARY}
	${DD} ${DD_FLAGS} if=/dev/zero of=${@} bs=1474560 count=1
	${DD} ${DD_FLAGS} if=${^} of=${@} bs=512 count=1 conv=notrunc

${OBJECT}: ${SOURCE}
	${AS} ${AS_FLAGS} ${^} -o ${@}
