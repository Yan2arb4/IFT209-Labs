/*******************************************************************************
	Ce sous-programme calcule la somme de deux entiers représentés comme des
	vecteurs d'octets, puis conserve le résultat dans un vecteur d'octets.


	Entrées:
		x0: adresse du premier entier (VECTEUR)
		x1: adresse du second entier (VECTEUR)
		x2: adresse du résultat (VECTEUR)
		x3: longueur des entiers et du résultat en octets (n)


	Sorties:
		[x2]: Résultat de la somme des entiers
		x0: débordement (0 = faux, 1 = vrai)
		bit C des codes condition: report final de l'opération

	Auteur.e.s:
	Yanéric Roussy
	Jihane Adjeb
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Addition


.section ".text"




Addition:
		SAVE
		mov x19, 0 //index
		mov x20, x0 //addresse vecteur A
		mov x21, x1 //addresse vecteur B
		mov x22, x3 //longueur d'octets (n)

boucle:
		cmp x19, x22
		b.ge sortir

		ldrb w23, [x20, x19] //adresse de chaque elt du vecteur 1
		ldrb w24, [x21, x19] //adresse de chaque elt du vecteur 2

		cmp x19, 0
		b.eq first_add

		adcs w25, w23, w24
		b	store_bytes

first_add:
		adds w25, w23, w24

store_bytes:
		strb w25, [x2, x19]

		add x19, x19, 1
		b boucle

sortir:
		sub x23, x22, 1

		ldrb w26, [x20, x23]
		ldrb w26, [x21, x23]
		ldrb w28, [x2, x23]

		lsr w26, w26, 7
		lsr w27, w27, 7
		lsr w28, w28, 7

		cmp w26, w28
		b.eq no_overflow

overflow:
		mov x0, 1
		b fin

no_overflow:
		mov x0, 0
		b fin

fin:

		RESTORE
		ret
