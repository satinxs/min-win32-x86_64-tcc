@echo off

echo Cleaning previous exes...
rm -f *.dll *.exe

echo Build tcc.exe

rem clang tcc.c -DTCC_TARGET_PE -DTCC_TARGET_X86_64 -DONE_SOURCE=1 -D_CRT_SECURE_NO_WARNINGS -Os -s
rem tcc tcc.c -o tcc-stage0.exe -DTCC_TARGET_PE -DTCC_TARGET_X86_64 -DONE_SOURCE=1
gcc tcc.c -o tcc-stage0.exe -DTCC_TARGET_PE -DTCC_TARGET_X86_64 -DONE_SOURCE=1 -Os -s -flto -ffunction-sections -fdata-sections -Wl,--gc-sections

tcc-stage0 -c lib\libtcc1.c
tcc-stage0 -c lib\crt1.c
tcc-stage0 -c lib\crt1w.c
tcc-stage0 -c lib\wincrt1.c
tcc-stage0 -c lib\wincrt1w.c
tcc-stage0 -c lib\dllcrt1.c
tcc-stage0 -c lib\dllmain.c
tcc-stage0 -c lib\chkstk.S
tcc-stage0 -c lib\alloca86_64.S
tcc-stage0 -c lib\alloca86_64-bt.S

tcc-stage0 -ar lib\libtcc1-64.a libtcc1.o crt1.o crt1w.o wincrt1.o wincrt1w.o dllcrt1.o dllmain.o chkstk.o alloca86_64.o alloca86_64-bt.o

rm -f *.o

tcc-stage0 -c lib\bcheck.c -o lib\bcheck.o -g 
tcc-stage0 -c lib\bt-exe.c -o lib\bt-exe.o 
tcc-stage0 -c lib\bt-log.c -o lib\bt-log.o 
tcc-stage0 -c lib\bt-dll.c -o lib\bt-dll.o 

tcc-stage0 -Os -s -o tcc.exe tcc.c -DTCC_TARGET_PE -DTCC_TARGET_X86_64 -DONE_SOURCE=1

strip --strip-all -s -R .comment -R .gnu.version --strip-unneeded *.exe