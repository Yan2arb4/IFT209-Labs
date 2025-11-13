/***********************************************************************

	Calculatrice notation polonaise inverse

***********************************************************************/


.include "/root/SOURCES/ift209/tools/ift209.as"

.global Main



.section ".text"

Main:

    // Prologue : sauvegarde du cadre d'appel

    stp     x29, x30, [sp, #-16]!   // empile frame pointer et link reg

    mov     x29, sp



    // Lecture d'une ligne de l'entrée standard (expression en NPI)

    adr     x0, scanf_fmt          // format "%[^\n]"

    adr     x1, tampon             // adresse du tampon

    bl      scanf                  // scanf("%[^\n]", tampon)



    // Initialisation : pointeurs pour la pile et parcours de la chaîne

    adr     x19, pile              // x19 = adresse de base de la pile (vide au départ)

    adr     x20, tampon            // x20 = pointeur de lecture dans la chaîne

boucle_analyse:

    ldrb    w1, [x20]              // charge caractère courant

    cbz     w1, fin_evaluation     // si fin de chaîne ('\0'), on sort

    // Test du premier caractère pour savoir si c'est un opérande (chiffre) ou autre

    cmp     w1, #'0'

    blt     traiter_operateur      // si < '0', ce n'est pas un chiffre

    cmp     w1, #'9'

    bgt     traiter_operateur      // si > '9', pareil

    // --- C'est un chiffre, on commence à lire un nombre (entier) ---

    mov     x21, #0                // x21 accumule le nombre

lecture_nombre:

    sub     w2, w1, #'0'           // w2 = valeur du chiffre (0..9)

    mov     x23, 10

    mul     x21, x21, x23          // x21 = x21 * 10

    add     x21, x21, x2           // x21 += w2

    add     x20, x20, #1           // passe au caractère suivant

    ldrb    w1, [x20]              // lit le suivant

    cmp     w1, #'0'

    blt     fin_lecture_nombre     // sort si non-chiffre

    cmp     w1, #'9'

    ble     lecture_nombre         // continue si chiffre

fin_lecture_nombre:

    // Empilement du nombre lu (x21) dans la pile virtuelle

    str     x21, [x19]

    add     x19, x19, #8

    b       boucle_analyse



traiter_operateur:

    // Comparaisons pour déterminer l'opérateur

    cmp     w1, #'+'

    beq     addition

    cmp     w1, #'-'

    beq     soustraction

    cmp     w1, #'*'

    beq     multiplication

    cmp     w1, #'/'

    beq     division

    // Si ce n'est ni chiffre ni opérateur valide, on passe au suivant

    add     x20, x20, #1

    b       boucle_analyse



addition:

    sub     x19, x19, 8

    ldr     x22, [x19]

    sub     x19, x19, 8

    ldr     x21, [x19]

    add     x21, x21, x22

    str     x21, [x19]

    add     x19, x19, 8

    add     x20, x20, 1

saut_espace_add:

    ldrb    w0, [x20]

    cmp     w0, #' '

    beq     increment_add

    b       boucle_analyse

increment_add:

    add     x20, x20, 1

    b       saut_espace_add



soustraction:

    sub     x19, x19, 8

    ldr     x22, [x19]

    sub     x19, x19, 8

    ldr     x21, [x19]

    sub     x21, x21, x22

    str     x21, [x19]

    add     x19, x19, 8

    add     x20, x20, 1

saut_espace_sous:

    ldrb    w0, [x20]

    cmp     w0, #' '

    beq     increment_sous

    b       boucle_analyse

increment_sous:

    add     x20, x20, #1

    b       saut_espace_sous



multiplication:

    sub     x19, x19, 8

    ldr     x22, [x19]

    sub     x19, x19, 8

    ldr     x21, [x19]

    mul     x21, x21, x22

    str     x21, [x19]

    add     x19, x19, 8

    add     x20, x20, 1

saut_espace_mult:

    ldrb    w0, [x20]

    cmp     w0, #' '

    beq     increment_mult

    b       boucle_analyse

increment_mult:

    add     x20, x20, 1

    b       saut_espace_mult



division:

    sub     x19, x19, 8

    ldr     x22, [x19]

    sub     x19, x19, 8

    ldr     x21, [x19]

    sdiv    x21, x21, x22

    str     x21, [x19]

    add     x19, x19, 8

    add     x20, x20, 1

saut_espace_div:

    ldrb    w0, [x20]

    cmp     w0, #' '

    beq     increment_div

    b       boucle_analyse

increment_div:

    add     x20, x20, #1

    b       saut_espace_div



// === Fin de la lecture, récupération du résultat ===

fin_evaluation:

    sub     x19, x19, #8

    ldr     x21, [x19]



    // Affichage du résultat

    adr     x0, printf_fmt

    mov     x1, x21

    bl      printf



    // Épilogue et sortie

    ldp     x29, x30, [sp], #16

    mov     x0, #0

    bl      exit



.section ".bss"

.align 3

tampon: .skip   256             // tampon pour l'entrée (expression)

.align 3

pile:   .skip   800             // pile virtuelle pour les valeurs (100 entrées)



.section ".rodata"

scanf_fmt:   .asciz " %[^\n]"   // format scanf : lit jusqu'au saut de ligne

printf_fmt:  .asciz "%d\n"      // format printf : résultat numérique avec '\n'


