#include <cstdio>
#include <bitset>
#include <cmath>


using namespace std;


/*******************************************************************************
	Ce programme teste un générateur de nombres aléatoires (fonction Random).
	Il récupère un échantillon de nombres en appelant la fonction Random un
	grand nombre de fois (345000).

	La période du générateur est testée en vérifiant que la valeur initiale
	n'est pas répétée avant la fin de l'échantillon.

	La qualité de la distribution de valeur est testée en prenant les valeurs
	générées comme un flot d'octets, puis en comptant le nombre de bits allumés
	par octet et en catégorisant cette valeur en 5 classes. La distribution de
	la fréquence de	l'apparition de chaque séquence de 5 classes possible est
	évaluée à l'aide d'un écart-type.

	Plus l'écart-type est faible, plus la distribution est uniforme.

	Entrées:
		(clavier): Valeur initiale du générateur (entier de 32 bits en hexa)
		(clavier): Constante multiplicative (entier de 32 bits en hexa)
		(clavier): Constante additive (entier de 32 bits en hexa)

	Sorties:
		(écran): Période
		(écran): Écart-type de la distribution des fréquences d'apparition des
				 groupes de 5 classes de décomptes de bits par octet.


	Auteur.e.s: Mikaël Fortin, 2022
	L'algorithme de décompte de fréquences (count ones) est tiré de l'ensemble
	de tests DIEHARD de Marsaglia.
*******************************************************************************/

/*
	Déclaration de la fonction Random. La balise extern C indique au compilateur
	le style de la signature de fonction. Permet de connecter C++ et assembleur.
*/
extern "C"{
	uint32_t Random (uint32_t* seed,uint32_t mconst,uint32_t addconst);
}

/*
	Données globales: échantillon et statistiques
*/

const int size = 345000;	//Taille de l'échantillon
const int words = 3125;		//Nombre de combinaisons de 5 octets
int stats [words];
int echantillon [size];

void verifFrequence (unsigned char data[],int stats[],int size);
double ecartType(int stats[],int size);
int verifPeriode(int data[],int size);

void genererEchantillon (int data[],int size,unsigned int seed,unsigned int mconst, unsigned int addconst);

int main(){


	uint32_t seed;
	uint32_t mconst;
	uint32_t addconst;

	//Obtention des paramètres du générateur: valeur initiale, constante
	//multiplicative et constante additive.
	scanf("%x%x%x",&seed,&mconst,&addconst);

	genererEchantillon(echantillon,size,seed,mconst,addconst);

	//Calcul des fréquences sur la suite de nombres (traitée comme flot d'octets)
	verifFrequence((unsigned char*)echantillon,stats,size*4);

	int periode = verifPeriode(echantillon,size);
	printf("Periode: %d",periode);
	if(periode==size){
		printf(" (maximale)");
	}
	printf("\nEcart-type: %f\n",ecartType(stats,words));

	return 0;
}

/*
	Fonction qui prépare l'échantillon en appelant la fonction Random.
*/
void genererEchantillon (int data[],int size,unsigned int seed,unsigned int mconst, unsigned int addconst)
{
	for (int i=0;i<size;i++){
		data[i] =Random(&seed,mconst,addconst);
	}
}

/*
	Vérification de la période.
*/
int verifPeriode(int data[],int size){
	int seed=data[0];
	int i=1;
	for(;i<size;i++){
		if(data[i]==seed){
			break;
		}
	}
	return i;
}

/*
	Calcul de l'écart-type.
*/
double ecartType(int stats[],int size){

	double moyenne=0;
	for(int i=0;i<size;i++){
		moyenne+=stats[i];
	}
	moyenne/=size;

	double ecart=0;
	for(int i=0;i<size;i++){
		ecart+= (moyenne-stats[i])*(moyenne-stats[i]);
	}
	ecart/=size;
	ecart=sqrt(ecart);
}

/*
	Fonction qui calcule la distribution des fréquences des groupes de 5
	classes de nombre de bits allumés par octets.

	Chaque octet de la séquence de données est évalué par son décompte de bits
	allumés et catégorisé comme suit:
	Catégorie    Nb bits à 1
		0			0,1,2
		1			3
		2			4
		3			5
		4			6,7,8

	Les groupes de 5 catégories consécutives générées (5^5 = 3125 possibilités)
	sont ensuite comptabilisées dans un tableau de statistiques.
*/

void verifFrequence (unsigned char data[],int stats[],int size){

	const int bits[9] = {0,0,0,1,2,3,4,4,4};

	int show = size/100;
	for(int i=0;i<size;i+=5){
		int index = 0;
		int pow=1;
		for(int j=4;j>=0;j--){
			bitset<8> b(data[i+j]);
			index+=pow*bits[b.count()];
			pow*=5;
		}
		stats[index]++;
	}
}
