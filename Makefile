AS = as
ASFLAGS = 
BINARY = boot.bin
DD = dd
IMAGE = boot.img
LD = ld
LDFLAGS = -Ttext=0x7C00 --oformat=binary
OBJECT = boot.o
QEMU = qemu-system-x86_64
RM = rm
RMFLAGS = -rf
SOURCE = boot.s

.PHONY: all clean run

all: ${IMAGE}
	

clean: 
	${RM} ${RMFLAGS} ${IMAGE} ${BINARY} ${OBJECT}

run: ${IMAGE}
	${QEMU} ${^}

${IMAGE}: ${BINARY}
	${DD} if=/dev/zero of=${@} bs=1474560 count=1
	${DD} if=${^} of=${@} bs=512 count=1 conv=notrunc

${BINARY}: ${OBJECT}
	${LD} ${LDFLAGS} ${^} -o ${@}

${OBJECT}: ${SOURCE}
	${AS} ${ASFLAGS} $^ -o $@
