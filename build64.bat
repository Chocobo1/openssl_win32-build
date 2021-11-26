@echo off
rem Place this file at the root of the src lib

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

set OPENSSL_X64_DIR=c:\openssl_64

mkdir _build && cd _build

C:\Strawberry\perl\bin\perl ..\Configure VC-WIN64A no-shared --prefix="%OPENSSL_X64_DIR%" --openssldir="%OPENSSL_X64_DIR%\ssl"
powershell -Command "& { (Get-Content 'makefile') | ForEach-Object { $_ -replace '/debug', '/debug /opt:ref /opt:icf /incremental:no' } |  Set-Content 'makefile' }"

nmake install

copy "app.pdb" "%OPENSSL_X64_DIR%\lib"
