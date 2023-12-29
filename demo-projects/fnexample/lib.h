/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This is a header file that declares utility functions for reading and printing strings and numbers
 * from/to MMIO Display and Keyboard
 *
 * See lib.c for explanations 
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
