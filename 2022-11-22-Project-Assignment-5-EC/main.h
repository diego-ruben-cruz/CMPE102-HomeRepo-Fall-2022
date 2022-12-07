#include <iostream>

#define ARR_SIZE 50
#define MON_SIZE 4
#define MONTHS 12

struct salesRecord
{
    char month[MON_SIZE];
    double amount;
}

void
printTitle(void);

extern "C"
{
    int getAmount(char *prompt) void writeFile(struct salesRecord *sales);
}