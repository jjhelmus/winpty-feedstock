@echo off

setlocal
cd %~dp0

set GYP_ARGS=
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set MSVC_PLATFORM=Win32) else (set MSVC_PLATFORM=x64)

REM -------------------------------------------------------------------------
REM -- Copy CMakeLists.txt to src

copy CMakeLists.txt src\CMakeLists.txt


REM -------------------------------------------------------------------------
REM -- Run cmake to generate MSVC project files.

cd src
dir

%LIBRARY_BIN%\cmake -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" -DCMAKE_BUILD_TYPE:STRING=Release
if errorlevel 1 (
    echo error: cmake failed
    exit /b 1
)

REM -------------------------------------------------------------------------
REM -- Compile the project.

nmake || (
    echo error: nmake failed
    exit /b 1
)

REM -------------------------------------------------------------------------
REM -- Install the project.

nmake install

rem copy include\winpty.h %LIBRARY_INC%
rem copy include\winpty_constants.h %LIBRARY_INC%

rem copy Release\%MSVC_PLATFORM%\winpty.lib %LIBRARY_LIB%
rem copy Release\%MSVC_PLATFORM%\winpty.dll %LIBRARY_BIN%
rem copy Release\%MSVC_PLATFORM%\winpty-agent.exe %LIBRARY_BIN%
rem copy Release\%MSVC_PLATFORM%\winpty-debugserver.exe %LIBRARY_BIN%