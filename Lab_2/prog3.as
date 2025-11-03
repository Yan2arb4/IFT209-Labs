/*******************************************************************************
Programme 3 : Vérifie si un nombre est divisible par un autre.

Entrées: (clavier) nombre à diviser
		 (clavier) diviseur

Sorties: (écran) message indiquant la divisibilité




	Auteur.e.s:
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"



Main:

		adr		x0,fmtwelcome
		bl		printf

		adr		x0,fmtscan
		adr		x1,scantemp
		mov		x19,x1
		bl		scanf

		adr		x0,fmtscan
		add		x1,x19,4
		bl		scanf


		ldr		w20,[x19]
		ldr		w21,[x19,4]



		mov		x0,x20
		mov		x1,x21
		bl		Divisible


		mov		x20,x0

		cmp		x20,1
		b.eq	main10


		adr		x0,fmtdiv
		bl 		printf

        mov		x0,0
		bl		exit

main10:
		adr		x0,fmtnodiv
		bl 		printf



fmtscan:		.asciz "%d"
fmtdiv	:		.asciz "Le nombres sont divisibles.\n"
fmtnodiv:		.asciz "Le nombres ne sont pas divisibles.\n"
fmtwelcome: 	.asciz "Entrez deux valeurs:   "



		/*Verifie si un nombre est divisible par un autre*/

Divisible:
		SAVE
		//Changé le registre x30 pour x2 (à revoir)
		sdiv	x2,x0,x1
		mul		x2,x2,x1
		cmp		x2,x0
		mov		x0,0
		b.eq	divi10

		mov		x0,1

		RESTORE
divi10:
	ret





.section ".bss"

scantemp:	.skip	 8
