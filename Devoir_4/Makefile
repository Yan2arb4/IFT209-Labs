AS = as
LD = ld


ARMV8:	tp4.o
	@echo
	@echo ------------------
	@echo Edition des liens
	@echo ------------------
	@echo

	$(LD) -e Main tp4.o  -o tp4 -lc



tp4.o: tp4.as
	@echo
	@echo ----------------------------------------------
	@echo Compilation du programme principal, tp4.as
	@echo ----------------------------------------------
	@echo

	$(AS) --gstabs tp4.as -o tp4.o
