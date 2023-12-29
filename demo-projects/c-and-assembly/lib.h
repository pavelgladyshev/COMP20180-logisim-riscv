/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This is a header file that declares utility functions for 
 * 
 * 1) reading and printing strings and numbers from/to MMIO Display and Keyboard
 * 2) displaying pictures on the graphics display
 *
 * See lib.c and display.s for explanations 
 */

#pragma once

// Math
int abs(int n);

// MMIO Display output
void printchar(char chr);
void printstr(char *str);
void printint(int n);
void println();
 
// MMIO Keyboard input
int pollkbd();
int readchar();
int readstr(char *buf, int size);
int readint();

// Graphics display output
void showpic(int picture[32]);
