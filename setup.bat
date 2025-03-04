@echo off

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

rem InstallerWindows を opentoonz のディレクトリにクローンしておくこと
pushd ..\toonz

rem rmdir /S /Q build
rem rmdir /S /Q build_srv

rem Qt5.9.2 by default
if "%~1"=="" (
    set QT_VER=5.9
) else (
    set QT_VER=%1
)
if "%~2"=="" (
    set QT_REV=2
) else (
    set QT_REV=%2
)

if "%~3"=="32bit" (
    set IS_32BIT=TRUE
)

echo "%QT_VER%"
echo "%QT_REV%"

rem http://ftp.yz.yamagata-u.ac.jp/pub/qtproject/archive/qt/5.9/5.9.2/qt-opensource-windows-x86-5.9.2.exe
rem "C:\Qt\Qt5.9.2" にインストールしておく

mkdir -p build
pushd build
@echo on
cmake ../sources -G "Visual Studio 14 Win64" -DQT_PATH="C:/Qt/Qt%QT_VER%.%QT_REV%/%QT_VER%/msvc2015_64" -DWITH_STOPMOTION=ON -DOpenCV_DIR="C:/programs/opencv/build"
rem cmake --build . --config Release
@echo off
if errorlevel 1 exit /b 1

MSBuild /m OpenToonz.sln /p:Configuration=Release
if errorlevel 1 exit /b 1

popd
rem build

rem 32bit 版のビルド (t32bitsrv.exe, image.dll, tnzcore.dll 用)
rem http://ftp.yz.yamagata-u.ac.jp/pub/qtproject/archive/qt/5.9/5.9.2/qt-opensource-windows-x86-5.9.2.exe
rem "C:\Qt\Qt5.9.2" にインストールしておく
if DEFINED IS_32BIT (
    mkdir -p build_srv
    pushd build_srv
    @echo on
    cmake ../sources -G "Visual Studio 14" -DQT_PATH="C:/Qt/Qt%QT_VER%.%QT_REV%/%QT_VER%/msvc2015"
    @echo off
    if errorlevel 1 exit /b 1
    MSBuild /m OpenToonz.sln /t:t32bitsrv /p:Configuration=Release
    if errorlevel 1 exit /b 1
    popd
    rem build_srv
)
popd

rem http://www.jrsoftware.org/isdl.php から
rem innosetup-5.5.9-unicode.exe をダウンロードしてインストールしておく

rem clean
rmdir /S /Q program
rmdir /S /Q stuff
rmdir /S /Q Output

rem Program Files
mkdir program
copy /Y ..\toonz\build\Release\*.exe program
copy /Y ..\toonz\build\Release\*.dll program
copy /Y ..\thirdparty\glew\glew-1.9.0\bin\64bit\*.dll program
copy /Y ..\thirdparty\glut\3.7.6\lib\*.dll program
copy /Y ..\thirdparty\libmypaint\dist\64\*.dll program
copy /Y "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\redist\x64\Microsoft.VC140.CRT\*.dll" program
copy /Y "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\redist\x64\Microsoft.VC140.OpenMP\*.dll" program
copy /Y "C:\programs\EDSDK131020CD\Windows\EDSDK_64\Dll\EDSDK.dll" program
copy /Y "C:\programs\libjpeg-turbo64\bin\turbojpeg.dll" program
copy /Y "C:\programs\opencv\build\x64\vc14\bin\opencv_world412.dll" program
@echo on
"C:\Qt\Qt%QT_VER%.%QT_REV%\%QT_VER%\msvc2015_64\bin\windeployqt.exe" --release --dir program program\OpenToonz.exe
@echo off
if errorlevel 1 exit /b 1

rem
if DEFINED IS_32BIT (
mkdir program\srv
    copy /Y ..\toonz\build_srv\Release\*.exe program\srv
    copy /Y ..\toonz\build_srv\Release\*.dll program\srv
    copy /Y "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\redist\x86\Microsoft.VC140.CRT\*.dll" program\srv
    @echo on
    "C:\Qt\Qt%QT_VER%.%QT_REV%\%QT_VER%\msvc2015\bin\windeployqt.exe" --release --dir program\srv program\srv\t32bitsrv.exe
    @echo off
    rem 25/11/2016 for unknown reasons, QtGui.dll is not copied to srv with windeployqt
    copy /Y "C:\Qt\Qt%QT_VER%.%QT_REV%\%QT_VER%\msvc2015\bin\Qt5Gui.dll" program\srv\Qt5Gui.dll
    copy /Y "C:\Qt\Qt%QT_VER%.%QT_REV%\%QT_VER%\msvc2015\bin\Qt5Widgets.dll" program\srv\Qt5Widgets.dll
    if errorlevel 1 exit /b 1
)

rem Stuff Dir
mkdir stuff
xcopy /YE ..\stuff stuff
xcopy /YE ..\toonz\build\loc stuff\config\loc
for /R %%F in (.gitkeep) do del "%%F"

python filelist.py
"C:\Program Files (x86)\Inno Setup 5\ISCC.exe" setup.iss
if errorlevel 1 exit /b 1

exit /b 0
