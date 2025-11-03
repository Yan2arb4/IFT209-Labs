/*******************************************************************************
Programme 2 : Recherche un nombre dans une liste existante.

Entrées: (clavier) le nombre qu'on veut rechercher dans la liste

Sorties: (écran) la position du nombre dans la liste,
				 ou une indication que le nombre est absent.




Auteur.e.s:
*******************************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"
.global Main


.section ".text"



Main:

		adr		x0,fmtwelcome
		bl		printf

		adr		x0,fmtscan
		adr		x1,scantemp
		mov		x19,x1
		bl		scanf

		ldr		w20,[x19]


		mov		x21,0
		mov		x29,9
		adr		x19,liste

main10:
		ldr		x22,[x19],8		//On augmente de 8 bits pour voir la prochaine adresse (la valeur) dans la liste.

		cmp		x20,x22
		b.eq	mainEnd


		add		x21,x21,1
		cmp		x21,x29			//Ici on compare compteur avec la max index de la liste (au lieu de l'adresse de la liste)
		b.lt	main10			//On veut LESS THAN au lieu de LESS OR EQUAL parce que la liste contient 9 éléments seulement.

		adr		x0,fmtabsent
		bl		printf

		mov		x0,0
		bl		exit


mainEnd:
		mov		x1,x21
		adr		x0,fmttrouve
		bl 		printf

        mov		x0,0
		bl		exit







.section ".rodata"

fmtscan:		.asciz "%d"
fmtprint:		.asciz "%d\n"
fmtwelcome: 	.asciz "Entrez la valeur qu'on cherche:"
fmttrouve:		.asciz "La valeur est a la position %d\n"
fmtabsent:		.asciz "La valeur n'est pas dans la liste.\n"




.section ".data"

/* La liste est constituée de nombres de 64 bits (8 octets) chacun.*/
liste: 		.dword	2,3,5,7,11,13,17,19,23
.skip 8
scantemp:	.skip	8
