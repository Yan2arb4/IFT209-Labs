/*******************************************************************************
	Ce programme calcule la somme des termes de valeur paires de la suite
	de Fibonacci. La définition utilisée pour ce programme est la suivante:

	fib(1) = 1
	fib(2) = 1
	fib(n) = fib(n-1) + fib(n-2)

	Entrées:
		(clavier) Nombre de termes de la suite sur lesquels on fait la sommation (entier)


	Sorties:
		(écran)	Somme des termes de valeur paire de la suite (entier)




	Auteur.e.s: Jihane Adjeb et Yanéric Roussy
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"



Main:
		SAVE				//Sauvegarde l'environnement de l'appelant

		/*
			Lecture du nombre de termes
		*/
		adr		x0,fmtscan	//Param1: adresse du format de lecture
		adr		x1,scantemp	//Param2: Place l'adresse du tampon dans x0
		mov		x19,x1		//Conserve l'adresse du tampon dans x19
		bl		scanf		//Lecture du nombre de termes

		ldr		w20,[x19]	//Récupère le nombre de termes dans x20


		/*
			Calcul de la somme des termes de valeur paire.
			Écrivez votre solution ici. Le nombre de termes se trouve dans
			x20 à ce point-ci du programme.
		*/

		/*x20 contient le nb de termes*/
		mov x21, 1 	//fib(1)
		mov x22, 1 	//fib(2)
		mov x23, 0 	//somme (ce qu'on retourne)
		mov x25, 2	//index

		boucle:
			cmp	x25, x20	//vérifier si compteur = n
			bge finboucle	//quitter loop si vrai

			add x26, x21, x22	//Faire fibonacci

			mov x21, x22	//décaler valeur fib
			mov x22, x26	//décaler valeur fib
			add x25, x25, 1		//Incrémente compteur de 1

			tbnz x26, 0, boucle	//si x26[0] != 1: rerentrer dans la boucle

			add x23, x23, x26	//ajoute fib à la somme

			b boucle
		finboucle:
			mov x1, x23		//déplace la somme (x23) dans x1
			b mainEnd
		/*
			Affichage de la valeur résultante.
			Votre résultat doit être dans le registre x1 à ce point-ci du
			programme pour que ça fonctionne.
		*/
mainEnd:
		adr		x0,fmtprint		//Param1: adresse du message et format decimal
		bl 		printf			//Affichage du resultat

        mov		x0,0			//Code d'erreur 0: aucune erreur
		bl		exit			//Fin du programme






/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

fmtscan:		.asciz "%d"		//format décimal: suite de chiffres en base 10
fmtprint:		.asciz "%lld\n"		//format décimal 64 bits suivi d'un saut de ligne.


/* Espace réservé pour recevoir le résultat de scanf. */

.section ".bss"

scantemp:	.skip	 4		//un entier lu en format %d prend 4 octets.
