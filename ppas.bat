@echo off
SET THEFILE=c:\users\rodrig~1\desktop\compuv~1\facultad\sintax~1\sys\proyecto.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o c:\users\rodrig~1\desktop\compuv~1\facultad\sintax~1\sys\proyecto.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
