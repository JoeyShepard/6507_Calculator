@echo off
title 6507 Calculator
echo.
for /f %%i in ('time /T') do set datetime=%%i
echo [%datetime%] Assembling...
cd src
"C:\Program Files\nasm\nasm" --no-line -e -Z main.err -l main.lst nasm.asm > main.i
copy main.i ..\main.i > nul
copy main.err ..\main.err > nul
cd ..
type main.err
echo.
del processed.asm
python "..\..\projects\6502 Optimizer\NASM based\main.py" main.i
type mem_template.asm >> processed.asm
echo.
echo Re-assembling...
..\..\AS\bin\asw processed.asm -P -G -U -L -g -q -cpu 6502 > asm.txt
python "remove escape.py" asm.txt
echo Generating hex file...
..\..\AS\bin\p2hex processed.p -F Intel -l 32 -r $0000-$FFFF > hex.txt
copy processed.hex emu.hex > nul
echo :02FFFC000009BF >> emu.hex
echo Copying...
copy processed.lst "..\..\projects\6502 emu\main\listing.lst" > nul
REM copy processed.hex "..\..\projects\6502 emu\main\prog.hex" > nul
copy emu.hex "..\..\projects\6502 emu\main\prog.hex" > nul
REM copy emu.hex "..\..\projects\6502 emu\node.js\prog.hex" > nul
copy input.txt "..\..\projects\6502 emu\main\input.txt" > nul
REM break > "..\..\projects\6502 emu\main\keys.txt"
copy keys.txt "..\..\projects\6502 emu\main\keys.txt" > nul
echo.