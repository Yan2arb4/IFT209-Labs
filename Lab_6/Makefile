AS = as
LD = ld


ARMV8:	log.o
	@echo
	@echo ------------------
	@echo Edition des liens
	@echo ------------------
	@echo

	$(LD) -e Main log.o  -o log -lc



log.o: log.as
	@echo
	@echo ---------------------------------------------
	@echo Compilation du programme principal, log.as
	@echo ---------------------------------------------
	@echo

	$(AS) --gstabs log.as -o log.o
