int main()
{
    int x, y, z;
    x = 10;
    y = 5;

    do
    {
        z = x + y;
    
        if ( z > 10 )
            x = x - 1;
    
        printf("%i\n", z);
        
        y = y - 1;
    }
    while ( y != 0 );

    for (x=1; x<10; x++) {
        z = z + y;
    }
}
