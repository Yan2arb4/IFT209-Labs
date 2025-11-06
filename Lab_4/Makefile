AS = as
LD = ld


ARMV8:	entiers.o main.o
	@echo
	@echo ------------------
	@echo Edition des liens
	@echo ------------------
	@echo

	$(LD) -e Main main.o entiers.o  -o entiers -lc


main.o: main.as
	@echo
	@echo ---------------------------------------------
	@echo Compilation du programme principal, main.as
	@echo ---------------------------------------------
	@echo

	$(AS) --gstabs main.as -o main.o

entiers.o: entiers.as
	@echo
	@echo ---------------------------------------------
	@echo Compilation du sous-programme, entiers.as
	@echo ---------------------------------------------
	@echo

	$(AS) --gstabs entiers.as -o entiers.o
