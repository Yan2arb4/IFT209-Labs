.include "/root/SOURCES/ift209/tools/ift209.as"

.global MultMatVec
 
 
.section ".text"
 
 
/***********************************************************************
 
	MultMatVec
 
	Effectue la multiplication d'une matrice par un vecteur.
 
 
	Entrées:

		(paramètre) x0: adresse de la matrice

		(paramètre) x1: adresse du vecteur

		(paramètre) x2: adresse du vecteur de résultats

		(paramètre) x3: nombre de lignes (ou hauteur)

		(paramètre) x4: nombre de colonnes (ou largeur)
 
 
	Sorties:

		(écran)	Affichage de l'opération

		(écran) vecteur résultant (suite d'entiers)
 
 
	Auteur:

***********************************************************************/

MultMatVec:

		SAVE // sauvegarde l'environnement
 
		mov x19,x0 // recuperer ladresse de base de la matrice

		mov x20,x1// recuperer ladresse de base du vecteur

		mov x21,x2// recuperer ladresse de base du vecteur de resultat

		mov x22,x3// recuperer le nombre de ligne max

		mov x23,x4// recuperer le nombre de colonne max

		mov x24,0 // initialise un index de 0 pour les lignes
 
boucle_ligne:

		cmp X24, x22 //compare l'index avec le nombre max de ligne

		b.ge end
 
		mov x25,0 // initialise un index de 0 pour les colonnes
 
		mov x26,0 // initialise un total de 0 pour le calcul final

boucle_colonne:

		cmp x25,x23

		b.ge Total
 
//		baseM + ((ixn)+j)x4

		mul x10, x24,x23 // x10 = i *n

		add x10, x10,x25 // x10 = x10 +j

		lsl x10, x10,2 // x10 = x10 *4

		add x10, x19,x10 // x10 = x19 + x10

		ldr w11, [x10]
 
		// baseV +j*4

		lsl x12, x25, 2 //

		add x12, x20, x12

		ldr w13, [x12]
 
		smull x14, w11, w13

		add x26 , x26, x14
 
		add x25, x25, 1

		b boucle_colonne
 
Total:

		// r[i] = sum

		lsl x10, x24, 2

		add x10, x21, x10

		str w26, [x10]
 
		add x24, x24, 1

		b boucle_ligne
 
 
 
end:

		RESTORE

		ret
 