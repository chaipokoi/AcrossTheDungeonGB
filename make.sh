rm build/rom.gb
rgbasm -o rom.o main.asm && rgblink -o build/rom.gb *.o && rgbfix -v build/rom.gb && wine build/bgb.exe build/rom.gb
rm *.o
