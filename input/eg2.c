int main ()
{
    int a[5];
    a[0]=99;
    a[1]=44;
    a[2]=3;
    a[3]=89;
    a[4]=1;
    printf ("%d\n", maxin(a,5));
}

int maxin (int a[5],int n)
{
    int m=-999999999;
    int i;
    for (i=0; i<n; i++)
        if (a[i] > m) m=a[i];
    return m;
}
