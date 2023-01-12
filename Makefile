#########################################
## Preamble
SHELL       := $(shell which bash)
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:             ;   # Recipes execute in same shell
.NOTPARALLEL:          ;   # Wait for this target to finish
.SILENT:               ; 	 # No need for @
.EXPORT_ALL_VARIABLES: ;   # Export variables to child processes.
.DELETE_ON_ERROR:      ;	 # Delete files on error

# Modify the block character to be `-\t` instead of `\t`
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = -

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


#########################################
## Setup
# Assign the default goal
.DEFAULT_GOAL := help
default: $(.DEFAULT_GOAL)
all: help


#########################################
## Variables
PROJECT_DIR := $(shell pwd)
SRC_DIR 		:= $(PROJECT_DIR)/src
BUILD_DIR 	:= $(PROJECT_DIR)/build
DEBUG_DIR 	:= $(BUILD_DIR)/debug


#########################################
## Help Command
.PHONY : help
help : ## List commands
-	echo -e "USAGE: make \033[36m[COMMAND]\033[0m\n"
-	echo "Available commands:"
-	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\t\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


#########################################
##
PHONY : bootloader
bootloader : | setup  ## Compile the Bootloader
-	echo -e "\033[36mCompiling the bootloader...\033[0m"
- cd $(SRC_DIR)
- nasm \
-		-f bin \
-		bootloader.asm \
-		-l $(BUILD_DIR)/debug/bootloader.lst \
-		-o $(BUILD_DIR)/bootloader.bin
# -		-w+all \


#########################################
##
PHONY : floppy
floppy : | setup  ## Compile the Bootloader
-	echo -e "\033[36mCopying kernel to first sector...\033[0m"
- cd $(PROJECT_DIR)
-	dd status=noxfer \
-		conv=notrunc \
-		if=$(BUILD_DIR)/bootloader.bin \
-		of=$(BUILD_DIR)/bootloader.flp


#########################################
##
PHONY : iso
iso: | setup floppy
-	mkisofs \
-		-o $(BUILD_DIR)/bootloader.iso \
-		-b $(BUILD_DIR)/bootloader.flp \
-		$(BUILD_DIR)/


# TODO - Emulate SeaBIOS
# git clone https://github.com/coreboot/seabios
# cd seabios
# make
# qemu -bios out/bios.bin


#########################################
##
PHONY : debug
debug : | clean setup bootloader  ## Setup debugging environment
-	echo -e "\033[36mLoading the debug environment...\033[0m"
-	cd $(BUILD_DIR)
- dd if=/dev/zero count=719 bs=512 2>/dev/null | tr "\000" "\377" > \
-		./debug/hda.img
- dd if=/dev/zero of=./debug/hdb.img count=719 bs=512 2>/dev/null
-	qemu-system-x86_64 \
-	  -fda bootloader.bin \
-	  -boot d \
-	  -hda ./debug/hda.img \
-	  -hdb ./debug/hdb.img \
# -	  -S -s
# -	  -vga none -nograsphic


#########################################
# TODO - Attach gdb
# https://github.com/gotoco/PE_Bootloader_x86

#########################################
# TODO - Dump hex of attached images
# hexdump -C hdb_zero.img
# hexdump -C hda_padded.img

#########################################
##
PHONY: test
test: test.img ## Test the images
	qemu -hda ./$(DISK_IMG) -net nic -net user -boot n -tftp $(DIR_TFTP) -bootp /pxelinux.0

#########################################
##
PHONY : setup
setup : ## Setup the build directory
-	echo -e "\033[36mSetting up the build directory...\033[0m"
-	mkdir --parents $(BUILD_DIR)/{,debug}


#########################################
##
PHONY : clean
clean :
-	rm -rf $(BUILD_DIR)

