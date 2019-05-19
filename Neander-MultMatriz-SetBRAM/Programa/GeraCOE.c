//Gera .COE a partir do arquivo de texto da memória

#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
	if (argc != 3)
		return 0;

	FILE *ent = fopen(argv[1], "r");
	FILE *sai = fopen(argv[2], "w");

	int aux, inst;
	char linha[100], saida[1500];

	saida[0] = '\0';

	fprintf(sai, "memory_initialization_radix = 10;\nmemory_initialization_vector =\n");

	while(!feof(ent) && fgets(linha, 100, ent)){
		//fgets(linha, 100, ent);
		sscanf(linha, "%d %d", &aux, &inst);
		if(strlen(linha) > 2)
			sprintf(saida,"%s%d,\n", saida, inst);

			//fprintf(sai, "%d,\n", inst);

		//sprintf(saida, "%s %d", saida, inst);
	}

	saida[strlen(saida)-2] = ';';

	fprintf(sai, "%s", saida);
	//printf("%s", saida);

	fclose(ent);
	fclose(sai);

	return 0;
}