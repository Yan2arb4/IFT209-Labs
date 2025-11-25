/*******************************************************************************
	Ce programme est un exemple d'un calcul simple qui utilise les
	opérations à virgule flottante.

	Calcule le logarithme d'un nombre simple précision lu au clavier, puis
	affiche le résultat à l'écran en double précision.

	Entrées:
		(clavier) Nombre duquel on veut calculer le logarithme (float)
		(clavier) Base du logarithme (float)

	Sorties:
		(écran)	Racine carrée simple précision (double)




	Auteur: Mikaël Fortin

	Note importante sur le format %f:
	En lecture (pour scanf), %f sera toujours simple précision.
	En écriture, (pour printf), %f sera toujours double précision.
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main

.section ".text"
Main:
		SAVE				//Sauvegarde l'environnement de l'appelant
		adr		x0,ptfmt1	//Param1: adresse du message à afficher
		bl		printf		//Affiche le message initial

		adr		x0,scfmt1	//Param1: adresse du format de lecture
		adr		x1,scantemp	//Param2: Place l'adresse du tampon dans x0
		mov		x19,x1		//Conserve l'adresse du tampon dans x19
		add		x2,x19,4	//Param3: adresse pour la deuxième valeur
		bl		scanf		//Lecture de deux floats au clavier

		// Recupere les valeurs float
		ldr		s0,[x19]	// s0 = n (nombre)
		ldr		s1,[x19,4]	// s1 = b (base)

		bl		Logarithme	// Appel du sous-programme, resultat dans d0

		adr		x0,ptfmt2	//Param1: adresse du message et format
		// d0 contient deja le resultat (double percision)
		bl 		printf		//Affichage double précision

MainEnd:
		mov		x0,0		//Code d'erreur 0: aucune erreur
		bl		exit		//Fin du programme

/*
	Sous-programme Logarithme
	Calcule log_b(n) avec précision de 0.00001
	Entrées:
		s0: n (nombre, simple précision)
		s1: b (base, simple précision)
	Sorties:
		d0: résultat (double précision)
*/
Logarithme:
	SAVE

	// Conversion en double précision pour meilleure précision de calcul
	fcvt	d2,s0		// d2 = n (quotient actuel)
	fcvt	d3,s1		// d3 = b (base)

	// Initialisation
	fmov	d0,xzr		// d0 = résultat total = 0.0
	fmov	d4,1.0		// d4 = constante 1.0
	adr		x0,delta
	ldr		s5,[x0]
	fcvt	d5,s5		// d5 = précision (0.00001)
	fadd	d6,d4,d5	// d6 = 1.00001 (seuil d'arrêt)

	// La partie entiere du nombre
	// Diviser n par b tant que quotient >= b
logPartieEntiere:
	fcmp	d2,d3		// Compare quotient avec base
	b.lt	logPartieFractionnaire	// Si quotient < base, passer à partie fractionnaire

	fdiv	d2,d2,d3	// quotient = quotient / base
	fadd	d0,d0,d4	// résultat += 1.0
	b		logPartieEntiere

	// La partie fractionnaire du nombre
	// Tester successivement b^(1/2), b^(1/4), b^(1/8), ...
logPartieFractionnaire:
	fcmp	d2,d6 		// Verifier condition d'arrêt: quotient < 1.00001
	b.lt	logFin

	// Initialisation pour partie fractionnaire
	fmov	d7,d3		// d7 = puissance fractionnaire de b (commence à b)
	fmov	d8,0.5		// d8 = fraction à ajouter (commence à 1/2)

logBoucleFractionnaire:
	// Calculer raicne carree de la puissance actuelle: b^(1/2^n)
	fsqrt	d7,d7

	// Comparer quotient avec b^(1/2^n)
	fcmp	d2,d7
	b.lt	logPasDivisible

	// Si quotient >= b^(1/2^n), diviser et ajouter la fraction
	fdiv	d2,d2,d7	// quotient = quotient / b^(1/2^n)
	fadd	d0,d0,d8	// résultat += fraction

logPasDivisible:
	// Diviser la farction par 2 pour la procahine iteration
	fmov	d9,0.5
	fmul	d8,d8,d9	// fraction = fraction / 2

	fcmp	d2,d6		// meme principe
	b.lt	logFin

	// Contiuner la boucle
	b		logBoucleFractionnaire

logFin:
	RESTORE
	ret

/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

ptfmt1:		.asciz "Entrez deux nombres simple précision:\n"
ptfmt2:		.asciz "Le logarithme calculé en double précision est: %.5f\n"
scfmt1:		.asciz "%f%f"


/* Espace réservé pour recevoir le résultat de scanf. */
.section ".bss"
			.align 	 4
scantemp:	.skip	 8

.section ".data"

delta:.single 0r0.00001
