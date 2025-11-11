/***********************************************************************

	Calculatrice notation polonaise inverse

***********************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"

Main:

		/*	Lecture d'une chaîne de caractères */



		/* Exemple de préparation de paramètres sur la pile  10+25+32 = 67*/

		mov		x20, 10
		mov		x21, 25
		mov		x22, 32

		str		x20,[sp,-8]
		str		x21,[sp,-16]
		str		x22,[sp,-24]
		sub		sp,sp,24
		bl		Somme

		ldr		x4,[sp]
		add		sp,sp,8

/* Affichage de la somme */
		mov 	x3, x22
		mov 	x2, x21
		mov 	x1, x20

		adr		x0,ptfmt1	//Param1: adresse de la chaîne à imprimer
		bl		printf		//Affiche le message pour obtenir les éléments


		mov		x0,0
		bl		exit


/*
sous fonction : Somme
*/
Somme:


		ldr		x0,[sp,16]
		ldr		x1,[sp,8]
		ldr		x2,[sp]
		add		sp,sp,24

		add		x0,x0,x1
		add		x0,x0,x2
		str		x0,[sp,-8]
		sub		sp,sp,8

		ret



/* Définition des données. */
.section ".bss"
temp:		.align	4


/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

ptfmt1:		.asciz "La somme de %d, %d, %d est: %d\n"
