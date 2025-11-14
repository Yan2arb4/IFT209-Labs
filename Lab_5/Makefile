AS = as
LD = ld
CC = gcc


Test:  rngtest.cc rng.o

	@echo
	@echo ----------------------------------------------
	@echo Compilation du programme de test
	@echo ----------------------------------------------
	@echo

	$(CC) rngtest.cc rng.o -o rngtest -lstdc++ -lm -std=c++11

rng.o:  rng.as

	@echo
	@echo ----------------------------------------------
	@echo Compilation de votre algorithme, rng.as
	@echo ----------------------------------------------
	@echo

	$(AS) --gstabs rng.as -o rng.o

Gen: rng1.cc rng.o

	@echo
	@echo ----------------------------------------------
	@echo Compilation des générateurs
	@echo ----------------------------------------------
	@echo

	$(CC) rng1.cc rng.o -o rng1 -lstdc++ -lm -std=c++11
