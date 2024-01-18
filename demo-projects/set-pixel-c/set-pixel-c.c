
void setpixel(int x, int y)
{
    volatile unsigned int *display = (volatile unsigned int *)0xffff8000;
    
    display[y] = display[y] | (0x1 << x);
}
    
void resetpixel(int x, int y)
{
    volatile unsigned int *display = (volatile unsigned int *)0xffff8000;
    
    display[y] = display[y] & ( (0x1 << x) ^ 0xffffffff );
}
    
    
int main()
{
    setpixel(5,8);
    //resetpixel(5,8);
}

