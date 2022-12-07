#include "main.h"

using namespace std;

int main()
{
    struct salesRecord sales[MONTHS];
    char command[ARR_SIZE];

    printTitle();
    printMenu();
    readFile(sales);

    while (1)
    {
        cout << "Command: ";
        cin >> command;

        if (strcmp(command, "show") == 0)
        {
            show(sales);
        }
        else if (strcmp(command, "view") == 0)
        {
        }
        else if (strcmp(command, "quit") == 0)
        {
            break;
        }
        else
        {
            cout << "Invalid command, try again." << endl;
        }
    }

    return 0;
}

void printTitle()
{
    cout << "Product Sales Management System" << endl;
}

void printMenu()
{
    cout << "Show => Show all sales amounts" << endl;
    cout << "Max  => Print highest sales amounts" << endl;
    cout << "Max  => Print highest sales amounts" << endl;
}

void readFile(struct salesRecord *sales)
{
    FILE *ptr;
    char line[ARR_SIZE];
    char *substr;
    int i, j;

    ptr = fopen("monthly_sales.txt", "r");

    if (ptr == NULL)
    {
        cout << "Unable to open the file" << endl;
    }
    else
    {
        i = 0;
        while (feof(ptr) == 0)
        {
            fgets(line, ARR_SIZE, ptr);

            substr = strtok(line, "\t");

            while (substr != NULL)
            {
                if (j == 0)
                {
                    strcpy(sales[i].month, substr);
                    j++;
                }
                else
                {
                    sales[i].amount = atoi(substr);
                }
                substr = strtok(NULL, "\t");
            }
            i++;
        }
    }
}

void writeFile(struct salesRecord *sales)
{
}

int getAmount()
{
}

void quit()
{
}