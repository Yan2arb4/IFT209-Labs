AS = as
LD = ld




syscall: tp5.o
	@echo
	@echo ------------------
	@echo Edition des liens
	@echo ------------------
	@echo

	$(LD) -e Main tp5.o -o tp5



tp5.o: tp5.as
	@echo
	@echo ---------------------------------------------
	@echo Compilation programme principal, tp5.as
	@echo ---------------------------------------------
	@echo

	$(AS) -gstabs tp5.as -o tp5.o
