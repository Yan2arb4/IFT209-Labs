/*******************************************************************************
	Ce programme calcule la somme de deux entiers représentés sur un
	certain nombre d'octets, puis affiche le résultat ainsi que les conditions
	de report et débordement sur cette addition.

	Ce programme appelle le sous-programme Addition, à implémenter dans le
	fichier entiers.as.

	Entrées:
		(clavier) 2 entiers (entiers)
		(clavier) nombre d'octets sur lesquels les entiers sont représentés (entier)


	Sorties:
		(écran)	Résultat de la somme des entiers (entier)
		(écran) États des bits V et C (booléens)


	Auteur: Mikaël Fortin, 2022.
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"



Main:
		SAVE				//Sauvegarde l'environnement de l'appelant

		/*
			Lecture du nombre d'octets et des valeurs à additionner
		*/
		adr		x0,fmtscan	//Param1: adresse du format de lecture
		adr		x1,scantemp	//Param2: Place l'adresse du tampon dans x0
		mov		x19,x1		//Conserve l'adresse du tampon dans x19
		bl		scanf		//Lecture du d'octets

		ldr		x20,[x19]	//Récupère le nombre d'octets dans x20

		/*
			Vérification: le nombre d'octets est entre 1 et 8
		*/
		cmp		x20,1
		b.lt	mainEnd
		cmp		x20,8
		b.gt	mainEnd

		/*
			Lecture des deux nombres
		*/
		adr		x0,fmtscan
		adr		x1,nombre1
		bl		scanf

		adr		x0,fmtscan
		adr		x1,nombre2
		bl		scanf

		/*
			Appel du sous-programme
		*/
		adr		x0,nombre1		//premier paramètre: adresse du premier nombre
		adr		x1,nombre2		//second paramètre: adresse du second nombre
		adr		x2,resultat		//troisième paramètre: adresse du résultat
		mov		x3,x20			//quatrième paramètre: longueur des nombres
		bl		Addition

		/*
			Affichage de l'opération et du résultat.
		*/
		mov		x22,x0			//conserve le débordement retourné
		mov		x21,0			//Par défaut, le report vaut 0
		b.cc	main10			//si le bit C était éteint, passe à la suite

		mov		x21,1			//Le bit C était allumé, alors report =1
main10:
		/*
			Affichage des deux nombres et du résultat octet par octet,
			séparés par des symboles arithmétiques
		*/
		adr		x0,nombre1
		mov		x1,x20
		bl		PrintNombre

		adr		x0,fmtplus
		bl		printf

		adr		x0,nombre2
		mov		x1,x20
		bl		PrintNombre

		adr		x0,fmtegal
		bl		printf

		adr		x0,resultat
		mov		x1,x20
		bl		PrintNombre

		/*
			Affichage de l'état du report et du débordement
		*/
		adr		x0,fmtCC
		mov		x1,x21
		mov		x2,x22
		bl		printf



mainEnd:
        mov		x0,0			//Code d'erreur 0: aucune erreur
		bl		exit			//Fin du programme


		/*
			Fonction qui affiche un nombre en hexadécimal, octet
			par octet, à partir d'un vecteur d'octets.
		*/
PrintNombre:
		SAVE
		mov		x19,x0
		mov		x20,x1


pn10:
		adr		x0,fmtprint
		sub		x20,x20,1
		ldrb	w1,[x19,x20]
		bl 		printf


		cmp		x20,0
		b.gt	pn10


		adr		x0,fmtbreak
		bl		printf
		RESTORE
		ret





/* Formats de lecture et d'écriture pour printf et scanf */
.section ".rodata"

fmtscan:		.asciz "%llx"		//format décimal: suite de chiffres en base 10
fmtprint:		.asciz "%02x "		//format décimal suivi d'un saut de ligne.
fmtbreak:		.asciz "\n"
fmtCC:			.asciz "Report (C):%d\nDebordement (V):%d\n"
fmtplus:		.asciz "+\n"
fmtegal:		.asciz "=\n"

/* Espace réservé pour recevoir le résultat de scanf. */

.section ".bss"

scantemp:	.skip	 8		//un entier lu en format %d prend 4 octets.
nombre1: .skip 8
nombre2: .skip 8
resultat:.skip 8
