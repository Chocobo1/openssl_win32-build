@echo off
rem Place this file at the root of the src lib

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set OPENSSL_X64_DIR=c:\openssl_64

perl Configure VC-WIN64A no-shared --prefix="%OPENSSL_X64_DIR%"
call ms\do_win64a
powershell -Command "& { (Get-Content 'makefile') | ForEach-Object { $_ -replace '/MT', '/MT /Zc:wchar_t-' } | ForEach-Object { $_ -replace '/debug', '/debug /dynamicbase /nxcompat /incremental:no' } |  Set-Content 'makefile' }"

nmake -f "ms\nt.mak" install

copy "tmp32\lib.pdb" "%OPENSSL_X64_DIR%\lib"
copy "tmp32\app.pdb" "%OPENSSL_X64_DIR%\lib"
