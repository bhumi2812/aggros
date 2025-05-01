@echo off
echo Cleaning previous build...
if exist build rmdir /s /q build
if exist target rmdir /s /q target

echo Creating build directories...
mkdir build\classes
mkdir build\lib

echo Creating file list...
dir /s /b src\main\java\com\pesticides\*.java src\main\java\com\fertilizer\*.java > sources.txt

echo Compiling Java files...
javac -d build\classes -cp ".;src\main\webapp\WEB-INF\lib\*" @sources.txt

echo Copying web resources...
xcopy /s /y src\main\webapp\* build\classes\

echo Cleaning up...
del sources.txt

echo Build completed! 