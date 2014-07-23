MAINDIR		= $(CURDIR)

ASM			= nasm

ASMFLAGS	= -f bin -w+all -ikernel/src/
LDFLAGS		= -m elf_i386 -Tkernel.ld

.PHONY: all clean

all: fsaos.iso
	@echo -e "\033[32m	\033[1mDONE\033[0m"

fsaos.iso: CD/boot/grub/stage2_eltorito kernel.bin
	@echo -e "\033[33m	\033[1mCopying kernel.bin to correct directory\033[0m"
	@cp kernel.bin CD/kernel.bin
	@echo -e "\033[33m	\033[1mCreating fsaos.iso\033[0m"
	@genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4\
				-boot-info-table -o fsaos.iso CD

CD/boot/grub/stage2_eltorito:
	@echo -e "\033[33m	\033[1mDownloading GRUB stage 2 binary\033[0m"
	@curl -o CD/boot/grub/stage2_eltorito https://arabos.googlecode.com/files/stage2_eltorito

kernel.bin: $(KERNOBJS)
	@echo -e "\033[33m	\033[1mAssembling kernel\033[0m"
	@$(ASM) $(ASMFLAGS) kernel/src/kernel.asm -o kernel.bin




clean:
	@rm -f kernel.bin
	@rm -f fsaos.iso
