
/********************************************************************************
*																				*
*	Programme qui lit, affiche et vérifie un sudoku.                          	*
*																				*
*															                    *
*	Auteurs: Jihane Adjeb et Yanéric Roussy										*
*																				*
********************************************************************************/

.include "/root/SOURCES/ift209/tools/ift209.as"

.global Main

.section ".text"

Main:
    adr     x20, Sudoku          // x20 = adresse du début du tableau Sudoku
                                  // on l'utilise comme pointeur global pour les fonctions

    mov     x0, x20
    bl      LireSudoku           // appel à la fonction pour lire le sudoku depuis stdin
                                  // x0 contient le pointeur sur le tableau

    mov     x0, x20
    bl      AfficherSudoku       // appel à la fonction pour afficher le sudoku
                                  // x0 = pointeur sur le tableau à afficher

    mov     x0, x20
    bl      VerifierSudoku       // appel pour vérifier si le sudoku est correct
                                  // les erreurs seront affichées ligne/colonne/bloc

    mov     x0, #0
    bl      fflush

    mov     x0, #0
    bl      exit

/************************ LireSudoku ***********************************/
LireSudoku:
    SAVE                         // sauvegarde du contexte (registre LR etc)
    mov     x20, x0              // x20 = base pointer du tableau sudoku
    mov     x25, #0              // x25 = compteur de cellules (0..80)

BoucleLecture:
    cmp     x25, #81             // comparer compteur à 81 (total des cellules)
    b.ge    FinLecture           // si compteur >= 81, fin de lecture

    adr     x0, scfmt1           // x0 = adresse du format "%hhu" pour scanf
    add     x1, x20, x25         // x1 = adresse de la cellule courante
    bl      scanf                // lit un octet et le stocke dans le sudoku

    add x25, x25, #1             // passer à la cellule suivante
    b BoucleLecture

FinLecture:
    RESTORE                      // restaurer le contexte précédent
    ret                           // retour à Main

/************************ AfficherSudoku ***********************************/
AfficherSudoku:
    SAVE
    mov     x21, x20             // x21 = pointeur courant sur le sudoku
    mov     x28, #0              // compteur de lignes

	BoucleRows:
	    cmp x28, #9                  // comparer le compteur de ligne x28 à 9 (toutes les lignes ?)
	    b.ge FinAfficher             // si toutes les lignes affichées, sortir de la boucle

	    /* ---------------------------------------------------------------
	       Affichage d'une ligne de séparation toutes les 3 lignes.
	       Objectif : tracer une ligne "|-------|-------|-------|"
	       au-dessus des lignes 0, 3, 6 (indices 0,3,6)
	    --------------------------------------------------------------- */

	    mov x0, x28                  // x0 = ligne courante
	    mov x1, #3                   // x1 = taille d'un bloc de 3 lignes
	    udiv x2, x0, x1              // division entière x28 / 3 → numéro de "groupe de 3 lignes"
	    mul x2, x2, x1               // x2 = multiple de 3 le plus proche inférieur
	                                  // Ex : x28 = 5 → 5 / 3 = 1 → 1*3 = 3
	    cmp x28, x2                  // comparer la ligne actuelle avec le multiple de 3 inférieur
	    b.ne pas_separator            // si x28 n'est pas un multiple de 3, on saute le séparateur

	    adr x0, ptfmt2                // charger le format pour la ligne de séparation
	    bl printf                     // afficher la ligne de séparation

	pas_separator:
	    /* ---------------------------------------------------------------
	       Objectif : Afficher une ligne du sudoku en 3 groupes de 3 cellules.
	       Chaque ligne du sudoku est composée de 9 cellules :
	       | 0 1 2 | 3 4 5 | 6 7 8 |
	       Le pointeur x21 parcourt le tableau Sudoku linéairement.
	    --------------------------------------------------------------- */

	    /* --- Premier groupe de 3 cellules --- */
	    adr x0, groupfmt             // format d'affichage pour un groupe : "| %d %d %d "
	    ldrb w1, [x21], #1           // lire la 1ère cellule du groupe, avancer le pointeur
	    ldrb w2, [x21], #1           // lire la 2ème cellule du groupe
	    ldrb w3, [x21], #1           // lire la 3ème cellule du groupe
	    bl printf                     // afficher le groupe : "| a b c "

	    /* --- Deuxième groupe de 3 cellules --- */
	    adr x0, groupfmt             // même format pour le 2e groupe
	    ldrb w1, [x21], #1           // lire la 4ème cellule
	    ldrb w2, [x21], #1           // lire la 5ème cellule
	    ldrb w3, [x21], #1           // lire la 6ème cellule
	    bl printf                     // afficher le groupe : "| d e f "

	    /* --- Troisième groupe de 3 cellules et fin de ligne --- */
	    adr x0, groupfmt_line        // format avec "| ... | \n" pour terminer la ligne
	    ldrb w1, [x21], #1           // lire la 7ème cellule
	    ldrb w2, [x21], #1           // lire la 8ème cellule
	    ldrb w3, [x21], #1           // lire la 9ème cellule
	    bl printf                     // affiche le dernier groupe et passe à la ligne suivante

	    add x28, x28, #1             // incrémente le compteur de ligne
	    b BoucleRows                 // passe à la ligne suivante

FinAfficher:
    adr x0, ptfmt2               // affiche dernière ligne de séparation
    bl printf
    RESTORE
    ret

	/************************ VerifierSudoku ***********************************/
	VerifierSudoku:
	    SAVE
	    mov x20, x0                  // x20 = pointeur vers le tableau Sudoku (base)

	    /* ---------------- Vérification des lignes ---------------- */
	    mov x28, #0                  // x28 = compteur de lignes (0..8)

	RowLoop:
	    cmp x28, #9                  // avons-nous traité toutes les lignes ?
	    b.ge ColLoop                 // si oui, passer à la vérification des colonnes

	    mov w29, #0                  // w29 = bitmask pour vérifier doublons dans la ligne
	                                  // Chaque bit correspond à un chiffre 1..9
	    mov x30, #0                  // compteur de colonnes pour cette ligne

	RowInner:
	    cmp x30, #9                  // toutes les colonnes de la ligne traitées ?
	    b.ge RowNext

	    /* Calcul de l'index linéaire de la cellule dans le tableau */
	    mov x1, x28                  // numéro de ligne
	    mov x2, #9
	    mul x3, x1, x2               // row*9
	    add x3, x3, x30              // index = row*9 + col
	    ldrb w4, [x20, x3]           // lire la valeur de la cellule

	    cbz w4, SkipRowMask           // ignorer si la cellule est vide (0)

	    /* ---------------- Logique du bitmask ----------------
	       w29 contient un bit pour chaque chiffre présent dans la ligne.
	       Exemple : si w4 = 5, on décale 1 de 4 positions (1 << (5-1)) pour créer le masque
	       tst w29, w5 teste si ce chiffre a déjà été rencontré
	       b.ne RowError : si doublon trouvé, afficher l'erreur
	       orr w29, w29, w5 : sinon, marquer ce chiffre comme présent
	    ------------------------------------------------------- */
	    mov w5, #1
	    sub w6, w4, #1
	    lsl w5, w5, w6               // créer le bitmask du chiffre
	    tst w29, w5                  // tester si ce chiffre existe déjà
	    b.ne RowError
	    orr w29, w29, w5             // marquer le chiffre dans le bitmask

	SkipRowMask:
	    add x30, x30, #1
	    b RowInner

	RowNext:
	    add x28, x28, #1
	    b RowLoop

	RowError:
	    adr x0, rowerrfmt
	    add x1, x28, #1
	    bl printf                     // afficher la ligne contenant un doublon
	    add x28, x28, #1
	    b RowLoop

	    /* ---------------- Vérification des colonnes ---------------- */
	ColLoop:
	    mov x28, #0                  // compteur de colonnes

	ColOuter:
	    cmp x28, #9
	    b.ge BlockLoop               // si toutes les colonnes vérifiées, passer aux blocs
	    mov w29, #0                  // bitmask pour cette colonne
	    mov x30, #0                  // compteur de cellule dans la colonne

	ColInner:
	    cmp x30, #9                  // toutes les cellules de la colonne traitées ?
	    b.ge ColNext

	    /* Calcul de l'index linéaire pour la colonne */
	    mov x1, x30                  // numéro de ligne
	    mov x2, #9
	    mul x3, x1, x2               // row*9
	    add x3, x3, x28              // row*9 + col
	    ldrb w4, [x20, x3]           // valeur de la cellule
	    cbz w4, SkipColMask           // ignorer les cellules vides

	    /* ---------------- Logique bitmask identique à RowInner ---------------- */
	    mov w5, #1
	    sub w6, w4, #1
	    lsl w5, w5, w6
	    tst w29, w5
	    b.ne ColError
	    orr w29, w29, w5

	SkipColMask:
	    add x30, x30, #1
	    b ColInner

	ColNext:
	    add x28, x28, #1
	    b ColOuter

	ColError:
	    adr x0, colerrfmt
	    add x1, x28, #1
	    bl printf                     // afficher colonne contenant doublon
	    add x28, x28, #1
	    b ColOuter

	    /* ---------------- Vérification des blocs 3x3 ---------------- */
	BlockLoop:
	    mov x28, #0                  // compteur de blocs (0..8)

	BlockOuter:
	    cmp x28, #9
	    b.ge VerifDone                // tous les blocs vérifiés
	    mov w29, #0                  // bitmask pour le bloc
	    mov x30, #0                  // compteur cellule dans le bloc


	BlockInner:
	    cmp x30, #9
	    b.ge BlockNext

	    /* ---------------------------------------------------------------
	       Objectif : Calculer l'index linéaire dans le tableau Sudoku
	       pour la cellule x30 du bloc x28.

	       Le sudoku est un tableau 9x9 stocké linéairement (81 octets) :
	       Index linéaire = row*9 + col

	       x28 = numéro du bloc (0 à 8) :
	           Bloc 0 1 2
	           Bloc 3 4 5
	           Bloc 6 7 8

	       x30 = numéro de la cellule dans le bloc (0 à 8) :
	           Cellules disposées aussi en 3x3
	    --------------------------------------------------------------- */

	    /* --- Calcul de la ligne de départ du bloc --- */
	    mov x1, x28          // x1 = numéro du bloc
	    mov x2, #3           // diviseur pour déterminer ligne/colonne du bloc
	    udiv x3, x1, x2      // x3 = numéro de la ligne du bloc (0,1,2)
	    mul x3, x3, x2       // x3 = ligne de départ dans la grille (0,3,6)

	    /* --- Calcul de la colonne de départ du bloc --- */
	    mov x4, x1
	    udiv x5, x4, x2
	    mul x5, x5, x2
	    sub x6, x1, x5       // numéro de la colonne du bloc (0,1,2)
	    mul x6, x6, x2       // colonne de départ dans la grille (0,3,6)

	    /* --- Calcul de la ligne absolue de la cellule dans le bloc --- */
	    mov x7, x30
	    udiv x8, x7, x2      // ligne interne dans le bloc (0,1,2)
	    add x9, x3, x8       // ligne absolue dans la grille

	    /* --- Calcul de la colonne absolue de la cellule dans le bloc --- */
	    mov x10, x30
	    udiv x11, x10, x2
	    mul x11, x11, x2
	    sub x12, x10, x11    // colonne interne dans le bloc (0,1,2)
	    add x13, x6, x12     // colonne absolue dans la grille

	    /* --- Conversion ligne/colonne absolue en index linéaire --- */
	    mov x14, #9
	    mul x9, x9, x14      // ligne*9
	    add x15, x9, x13     // index = ligne*9 + colonne
	    ldrb w4, [x20, x15]  // lire valeur de la cellule


    cbz w4, SkipBlockMask
    mov w5, #1
    sub w6, w4, #1
    lsl w5, w5, w6
    tst w29, w5
    b.ne BlockError
    orr w29, w29, w5

SkipBlockMask:
    add x30, x30, #1
    b BlockInner

BlockNext:
    add x28, x28, #1
    b BlockOuter

BlockError:
    adr x0, blockerrfmt
    add x1, x28, #1
    bl printf
    add x28, x28, #1
    b BlockOuter

VerifDone:
    RESTORE
    ret

/************************ Data & Formats ***********************************/
.section ".rodata"

scfmt1:         .asciz  "%hhu"                   // format pour scanf
ptfmt2:         .asciz  "|-------|-------|-------|\n"
groupfmt:       .asciz  "| %d %d %d "
groupfmt_line:  .asciz  "| %d %d %d |\n"
rowerrfmt:       .asciz "Le sudoku contient une erreur dans la ligne %d\n"
colerrfmt:       .asciz "Le sudoku contient une erreur dans la colonne %d\n"
blockerrfmt:     .asciz "Le sudoku contient une erreur dans le bloc %d\n"

.section ".bss"
.align 2
Sudoku: .skip 81                              // 9x9 = 81 octets
