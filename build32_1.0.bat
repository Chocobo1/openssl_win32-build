@echo off
rem Place this file at the root of the src lib

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64_x86

set OPENSSL_X32_DIR=c:\openssl_32

perl Configure VC-WIN32 no-shared --prefix="%OPENSSL_X32_DIR%"
call ms\do_nasm
powershell -Command "& { (Get-Content 'makefile') | ForEach-Object { $_ -replace '/MT', '/MT /Zc:wchar_t-' } | ForEach-Object { $_ -replace '/debug', '/debug /dynamicbase /nxcompat /incremental:no' } |  Set-Content 'makefile' }"

nmake -f "ms\nt.mak" install

copy "tmp32\lib.pdb" "%OPENSSL_X32_DIR%\lib"
copy "tmp32\app.pdb" "%OPENSSL_X32_DIR%\lib"
