#include <stdio.h>
#include <string.h>
int main(int argc, char**argv)
{
int i;
printf("Vous avez entré %d mots\n", argc-1);
puts("Leurs longueurs sont :");
for (i=1 ; i<argc ; i++)
{
printf("%s : %d\n", argv[i], strlen(argv[i]));
}
return 0;
}
