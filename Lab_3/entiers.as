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
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Addition


.section ".text"




Addition:
		SAVE

		mov x18, 0 // report (carry) = 0 au début (soit 0 ou 1)
		mov x19, 0 //index
		mov x20, x0 //addresse vecteur A
		mov x21, x1 //addresse vecteur B
		mov x22, x3 //longueur de bit (n)

boucle:
		cmp x19, x22
		b.ge sortir

		ldrb w23, [x20, x19] //adresse de chaque elt du vecteur 1
		ldrb w24, [x21, x19] //adresse de chaque elt du vecteur 2


		// Addition avec report
		adds w25, w23, w24 // w25 =  adresse A + Adresse B, flags mise a jour (à cause du addS)
		adc w25, w25, w18

		// Save Result
		add x26
		@ cmp w25,255
		@ b.le pasDeReport // plus besoin de ca si on utilise les commande qui gere les rport et carry automatiquement

		mov w18, 1 // report =1
		sub w25, w25, 255 //pour avoir la vrai valeur de laddition en enlevant le report
		b suite

suite:
		add x19, x19, 1 // incremente l'index
		b boucle


sortir:

@ pasDeReport:
@ 		mov w18, 0 // report = 0 (pas de retenue)





		RESTORE
		ret
