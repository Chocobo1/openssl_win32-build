@echo off
rem Place this file at the root of the src lib

if not defined CL_EXIST (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
	set CL_EXIST=1
)

set OPENSSL_X64_DIR=c:\openssl_64

mkdir _build && cd _build

perl ..\Configure VC-WIN64A no-shared --prefix="%OPENSSL_X64_DIR%" --openssldir="%OPENSSL_X64_DIR%\ssl"
powershell -Command "& { (Get-Content 'makefile') | ForEach-Object { $_ -replace '/MT', '/MT /Zc:wchar_t-' } | ForEach-Object { $_ -replace '/debug', '/debug /dynamicbase /nxcompat /incremental:no' } |  Set-Content 'makefile' }"

nmake install

copy "app.pdb" "%OPENSSL_X64_DIR%\lib"
