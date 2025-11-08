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
		    mov x19, 0      // index
		    mov x20, x0     // adresse A
		    mov x21, x1     // adresse B
		    mov x22, x3     // longueur n

boucle:
		    cmp x19, x22			//compare l'index avec le length d'octets du vecteur
		    b.ge sortir				// x19 >= x22 -> sortir

		    ldrb w23, [x20, x19]  	// On lit le vecteur A[i]
		    ldrb w24, [x21, x19]  	// On lit le vecteur B[i]

		    cmp x19, 0				// compare l'index a zero
		    b.eq first_add			// si x19 == 0 -> first_add

		    adcs w25, w23, w24		// Addition des octets A[i] et B[i] en tenant compte du carry.
		    b store_bytes			// -> store_bytes

/*
 First_add consiste a utiliser l'instruction adds.
 Adds permet l'initialisation propre des flags (NZCV).
 Ce qui nous importe surtout c'est le flag C.
*/
first_add:
    		adds w25, w23, w24		// Addition des octets A[i] et B[i] avec possibilité de carry.

store_bytes:
		    strb w25, [x2, x19]		// On store l'octet additionner (w25) dans le registre de retour (x2) en mentionnant la position (x19, l'index)
		    add x19, x19, 1			// Incrémente l'index

			// Définie le registre x26 comme 0 ou 1 dépendemment du carry
			cset x26, cs			// cs est le Carry Set
		    b boucle				// On continue dans la boucle

sortir:
		    sub x23, x22, 1			// On obtient la vraie longueur des vecteurs
		    ldrb w26, [x20, x23]	// On lit le dernier octet du vecteur A
		    ldrb w27, [x21, x23]	// On lit le dernier octet du vecteur B
		    ldrb w28, [x2, x23]		// On lit le dernier octet du vecteur C (la somme des deux vecteurs)

		    lsr w26, w26, 7			// On déplace les 7 bits à droite pour garder le plus important (Vecteur A)
		    lsr w27, w27, 7			// Pareil (Vecteur B)
		    lsr w28, w28, 7			// Pareil (Vecteur C)

			// On revérifie en comparant le C flag qu'on a store dans le registre x26
			cmp x26, 1

			/*
			 On veut savoir s'il y a un overflow, comme dit dans l'énoncé, c'est la cas si
			 Le signe des deux nombres est identique, mais diffère de celui du résultat, on a donc un débordement.
			*/
		    eor w18, w26, w27		// Si A == B, alors w18 = 0, sinon w18 = 1
		    eor w19, w26, w28		// Si A == C, alors w18 = 0, sinon w18 = 1
		    eor w18, w18, 1			// w18 devient 1 si A et B ont le même signe
		    and w20, w18, w19		// Si A et B ont le même signe (w18 == 1) ET A et C ont des signes différents (w19 == 1), alors débordement (1)
		    cbz w20, no_overflow	// Si w20 == 0 -> no_overflow

overflow:
		    mov x0, 1				// Retourne 1 pour débordement
		    b fin
no_overflow:
    		mov x0, 0				// Retourne 0 pour aucun débordement

fin:
		    RESTORE
		    ret
