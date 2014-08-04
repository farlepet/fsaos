#!/bin/bash

ASMFLAGS="-f bin -w+all -ikernel/src/"

echo -e "\033[33m	\033[1mAssembling kernel\033[0m"
nasm $ASMFLAGS kernel/src/kernel.asm -o kernel.bin

echo -e "\033[33m	\033[1mCopying kernel.bin to correct directory\033[0m"
cp kernel.bin CD/kernel.bin
echo -e "\033[33m	\033[1mCreating fsaos.iso\033[0m"
genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4\
			 -boot-info-table -o fsaos.iso CD