/********************************************************************************
*																				*
*	Programme qui affiche le bit de parité d'un caractère
*                    lu avec une interruption           	*
*							*
*															                    *
*	Auteurs: 												*
*																				*
********************************************************************************/
//Pour calculer la parité paire, on regarde au niveau de bits
//et on compte le nombre de bits égal à 1 parmi les 7 bits,
//si ce nombre est pair, le bit de parité paire est 0,
//sinon il est à 1.

.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"

/* Début du programme */

Main:
	mov x20, xzr //compteur
			/*
				Affichage d'un message préparé
			*/
			mov		x8,64		//code de service 64: write
			mov		x0,1		//Param1: identificateur de flot (1=stdout)
			adr		x1,Welcome	//Param2: adresse de la chaîne à imprimer
			mov		x2,54		//Param3: longueur de la chaîne
			svc		0			//Appel système catégorie de service 0


			/*
				Lecture d'un caractère
			*/
			mov		x8,63		//code de service 63: read
			mov		x0,0		//Param1: identificateur de flot (0=stdin)
			adr		x1,tampon	//Param2: adresse où écrire les caractères
			mov		x2,1		//Param3: nombre de caractères = 1
			svc		0			//Appel système catégorie de service 0

/*
			 Un masque permet
			 de spécifier les bits à isoler. Si nous changeons 4 pour le masque 9 = 10012 dans
			 l’exemple précédent, alors tous les bits sont mis à zéro à l’exception du premier
			 et quatrième bits de poids faible:
*/

			ldrb	w10, [x1]	//met la valeur de l'entree de tampon (genre le chiffre rentre)
			and		w10, w10, 127 // masque les 7 derniers bits (transforme le reste (le premier) en 0)

			mov 	w11, w10 //w11 = w10
			mov 	w20, wzr // compteur de bit = 1 (=0 pour l'instant)

			compteur:

			cmp 	w11, 0	//si le reste de w11 =0 on sort (exemple : si cest 010 on reste, si cest 000 on sort )
			b.eq	fin

			and		w13, w11, 1 //regarde seulement le premier bit contenu dans 11
			add		w20, w20, w13 // si le bit lu = 1 va ajouter si non ajoute rien

			lsr     w11, w11, 1  //decale le contenu de w11 vers la droite pour pouvoir lire le prochain bit
			b	compteur

fin:
	and     w14, w20, 1 //verifie si le dernier bit du compteur de bit est 1, donc impaire, car si 0000 0001 est le seul bit qui peut rendre impaire

//PAS COMPRIS CA
	add     w14, w14, #'0'    // devient '0' (0x30) ou '1' (0x31)
	strb    w14, [x1, 1]     // on remplace le '\n' par '0' ou '1'

    mov     w15, #'\n'        // remettre un saut de ligne après
    strb    w15, [x1, 2]     // tampon[2] = '\n'
// A LA
			/*
				Affichage du caractère lu avec un saut de ligne
			*/
			mov		x8,64		//code de service 64: write
			mov		x0,1		//Param1: identificateur de flot (1=stdout)
			adr		x1,tampon	//Param2: adresse de la chaîne à imprimer
			mov		x2,3		//Param3: longueur de la chaîne
			svc		0			//Appel système catégorie de service 0


			/*
				Vidange des flots
			*/
			mov		x8,57		//Code de service 57: close
			mov		x0,0		//Param1: tous les flots
			svc		0			//Appel système catégorie de service 0

			/*
				Fin du programme
			*/
			mov		x8,93		//Code de service 93: exit
			mov		x0,0		//Param1: code de sortie 0 (aucune erreur)
			svc		0			//Appel système catégorie de service 0


.section ".rodata"


Welcome:     .asciz	"Programme de démonstration pour les appels système.\n"




.section ".data"

tampon:			.asciz " \n"
