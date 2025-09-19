/********************************************************************************
*																				*
*	Sous-programme qui teste les nombres pour savoir s'ils sont premiers.   	*
*																				*
*	Entrées:                                                                    *
*        x0: quantite de nombres premiers à tester								*
*		 x1: premier nombre à tester											*
*		 x2: 1: mode silencieux, 0: non-silencieux                     			*
*																				*
*	Sorties: (écran) suite de nombre premiers (entiers)							*
*	Auteurs: Jihane Adjeb et Yanéric Roussy 																	*
*																				*
********************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Prime



.section ".text"



Prime:  SAVE						//Sauvegarde l'environnement de l'appelant


  		/*
			Écrivez votre algorithme ici
		*/
		mov x20, x0		//quantité de nombres premiers à tester
		mov x21, x1		//premier nombre à tester
		mov x22, x2		//1: mode silencieux, 0: non-silencieux (pas fait encore)

		add x23, x21, x20	//Représente le range de nombres à calculer


		boucle:
			cmp x21, x23	//On commence au nombre initial et loop jusqu'à la fin du given range
			bgt PrimeEnd

			//Le # est utilisé pour appeler une constante
			cmp x21, 2        // si n < 2 = pas premier (car 2 est le premier nombre premier)
			blt suivant

			// test de primalité pour n = x21
			mov x24, 2        // diviseur d = 2
			mov x25, 1        // flag premier = 1 (on suppose que n est premier)


		/*En gros ici on regarde si le nombre peut se faire diviser (partant à 2)
		  Si on continue à obtenir un reste, on incrémente de 1 le diviseur et on continue
		  Si on obtient 0 reste, on se déplace a la secion non_prime
		*/
		test_div:
			cmp x24, x21       	// si d >= n, plus de diviseurs à tester
			bge verif_prime

			udiv x26, x21, x24			//q = n / d (division entière)
			msub x27, x26, x24, x21 	//r = n - q*d (les décimals du résultat de la division)
			cbz x27, non_prime 			//si r == 0 -> pas premier

			add x24, x24, 1   // d++
			b test_div


		non_prime:
        	mov x25, 0        // j'utilise le flag comme un booléen

		verif_prime:
		 	cbz x25, suivant   // si pas premier -> skip
		  	mov x0, x21        // mettre n dans x0 (c'est ce que le programme de base s'attend)
		  	bl Afficher        // afficher n

		suivant:
		 	add x21, x21, 1   // n++ (on continue dans la boucle)
		  	b boucle



PrimeEnd:

        RESTORE						//Ramène l'environnement de l'appelant
        ret							//Retourne au programme principal
