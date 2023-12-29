#include "lib.h"

int square(int y)
{
    y = y*y;
    return y;
}

int main()
{
    int x=3;
    printint(square(x));
    printint(x);
    return 0;
}
