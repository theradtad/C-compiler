#!/bin/bash

lex phase2.l
yacc phase2.y
gcc y.tab.c -ll -w
./a.out < phase2_input.c
