/*******************************************************************************
	Programme 1 : calcule la partie entière de la racine carrée d'un nombre.

	Entrées: (clavier) le nombre dont on veut calculer la racine

	Sorties: (écran) la partie entière de la racine.




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

		ldrsw	x20,[x19]
		mov x21, 0				//On attribue 0 a x21 avant la boucle



main10:
		//mov		x21,0
		mul		x22,x21,x21		//multiplie x21 par x21  (x21 = 0)
		cmp		x22,x20			//Regarde si x22 == x20
		b.gt	mainEnd

		//ge		x22 = 25, x20 =25
		//gt		x22 = 25, x20 =25

		add		x21,x21,1		//fait rien

		b.al	main10





mainEnd:

		sub		x1,x21,1
		adr		x0,fmtprint
		bl 		printf

        mov		x0,0
		bl		exit


mainErreur:
		adr		x0,fmterreur
		bl		printf
		mov		x0,0
		bl		exit





.section ".rodata"

fmtscan:		.asciz "%d"
fmtprint:		.asciz "La racine carree est: %d\n"
fmtwelcome: 	.asciz "Entrez une valeur:"
fmterreur:		.asciz "Valeur inadmissible.\n"




.section ".bss"

scantemp:	.skip	 4
