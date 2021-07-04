#!/bin/bash

nasm -felf64 -o $1.o $1
ld -o $1.exe $1.o
rm $1.o
