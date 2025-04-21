@echo off
setlocal enabledelayedexpansion

title JetBrains IDE �����

:: ������ɫ
color 0A

echo ===================================================
echo             JetBrains IDE �����
echo ===================================================
echo.

:: ��ȡ��ǰĿ¼
set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"
set "JAR_FILE=%CURRENT_DIR%\sniarbtej-2024.2.8.jar"

:: �����㣺����Ƿ��Ѿ��޲�������
if exist "%CURRENT_DIR%\key.txt" (
    echo ��⵽�����ѱ��޲����Ƿ������޲���
    choice /c YN /m "ѡ�� Y(��) �� N(��)"
    if errorlevel 2 (
        echo �����޲����裬ֱ�ӽ��벽����...
        echo.
        goto step_four
    ) else (
        echo �����½����޲�...
        echo.
    )
) else (
    echo δ�޲��������޲�...
    echo.
)

:: ����һ�����Java����
echo ���ڼ��Java����...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ����: Java�汾�����ڣ���δΪ�����û���������
    echo �밲װJava�����û��������������д˽ű���
    echo.
    pause
    exit /b 1
)

for /f "tokens=2 delims= " %%a in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVA_VERSION=%%a
)
set JAVA_VERSION=%JAVA_VERSION:"=%
echo ��⵽Java�汾: %JAVA_VERSION%
echo.

:: ����������ɼ�����Կ
:generate_key
echo ������License ID��User Name�����ɼ�����Կ
set /p "LICENSE_ID=License ID: "
set /p "USER_NAME=User Name: "

echo.
echo �����޲�����ing....
java -jar "%JAR_FILE%" -genkey -id=%LICENSE_ID% -user=%USER_NAME% > "%CURRENT_DIR%\key.txt"

:: ������������Ƿ�������key.txt�ļ�
if not exist "%CURRENT_DIR%\key.txt" (
    echo �޲�ʧ�ܣ�δ������key.txt�ļ���
    goto generate_key
)

:: ���key.txt�Ƿ�Ϊ��
for %%F in ("%CURRENT_DIR%\key.txt") do if %%~zF equ 0 (
    del "%CURRENT_DIR%\key.txt"
    echo �޲�ʧ�ܣ������������License ID��User Name��ֵ����������ţ���ɾȥ������ź��������롣
    goto generate_key
)

echo �����޲��ɹ���
echo.

:: �����ģ�����IDE�����ļ�
:step_four
:process_ide
echo ������IDE��ִ���ļ����ݷ�ʽ������·��
echo ����: D:\Program Files\JetBrains\IntelliJ IDEA\bin\idea64.exe
echo ����: D:\��ݷ�ʽ\IntelliJ IDEA.lnk
echo.
set /p "IDE_PATH=·��: "

:: ��������·�����ܴ��е�����
set "IDE_PATH=%IDE_PATH:"=%"

if not exist "%IDE_PATH%" (
    echo ����: �ļ������ڣ�����·�������ԡ�
    echo.
    goto process_ide
)

:: ����Ƿ��ǿ�ݷ�ʽ
set "ext=%IDE_PATH:~-4%"
set "TARGET_PATH=%IDE_PATH%"

if /i "%ext%"==".lnk" (
    echo ��⵽��ݷ�ʽ�����ڽ���...
    
    :: ������ʱVBS�ű���������ݷ�ʽ
    echo On Error Resume Next > "%temp%\resolvelnk.vbs"
    echo Set objShell = CreateObject("WScript.Shell") >> "%temp%\resolvelnk.vbs"
    echo Set objLink = objShell.CreateShortcut("%IDE_PATH%") >> "%temp%\resolvelnk.vbs"
    echo If Err.Number ^<^> 0 Then >> "%temp%\resolvelnk.vbs"
    echo   WScript.Echo "ERROR:" ^& Err.Description >> "%temp%\resolvelnk.vbs"
    echo   WScript.Quit >> "%temp%\resolvelnk.vbs"
    echo End If >> "%temp%\resolvelnk.vbs"
    echo WScript.Echo objLink.TargetPath >> "%temp%\resolvelnk.vbs"
    echo WScript.Echo objLink.WorkingDirectory >> "%temp%\resolvelnk.vbs"
    
    :: ����VBS�ű���������
    set "error="
    for /f "tokens=*" %%a in ('cscript //nologo "%temp%\resolvelnk.vbs" 2^>^&1') do (
        set "line=%%a"
        if "!line:~0,6!"=="ERROR:" (
            set "error=!line:~6!"
        ) else if not defined TARGET_PATH (
            set "TARGET_PATH=%%a"
        )
    )
    
    :: ɾ����ʱVBS�ű�
    del "%temp%\resolvelnk.vbs" > nul 2>&1
    
    if defined error (
        echo ����: !error!
        goto process_ide
    )
    
    echo ��ݷ�ʽָ��: "!TARGET_PATH!"
    echo.
)

:: ��ȡ�ļ�����Ŀ¼
for %%F in ("!TARGET_PATH!") do (
    set "FILE_NAME=%%~nxF"
    set "TARGET_DIR=%%~dpF"
)

:: ����Ƿ���֧�ֵ�JetBrains IDE
set "SUPPORTED=0"
set "VMOPTIONS_FILE="

for %%I in (clion64.exe datagrip64.exe dataspell64.exe goland64.exe idea64.exe phpstorm64.exe pycharm64.exe rider64.exe rubymine64.exe rustrover64.exe webstorm64.exe) do (
    if /i "!FILE_NAME!"=="%%I" (
        set "SUPPORTED=1"
        set "VMOPTIONS_FILE=!TARGET_DIR!%%I.vmoptions"
    )
)

if "!SUPPORTED!"=="0" (
    echo ����: ��֧�ֵ�JetBrains IDE����ȷ��ѡ�����JetBrains IDE�Ŀ�ִ���ļ���
    echo ֧�ֵ��ļ���: clion64.exe, datagrip64.exe, dataspell64.exe, goland64.exe, idea64.exe, 
    echo               phpstorm64.exe, pycharm64.exe, rider64.exe, rubymine64.exe, rustrover64.exe, webstorm64.exe
    echo.
    goto process_ide
)

:: ���vmoptions�ļ��Ƿ����
if not exist "!VMOPTIONS_FILE!" (
    echo ����: δ�ҵ�vmoptions�ļ�: !VMOPTIONS_FILE!
    echo ��ȷ��IDE����ȷ��װ��
    echo.
    goto process_ide
)

:: ����vmoptions�ļ�
if not exist "!VMOPTIONS_FILE!.bak" (
    copy "!VMOPTIONS_FILE!" "!VMOPTIONS_FILE!.bak" > nul
    echo �ѱ���ԭʼvmoptions�ļ�Ϊ: !VMOPTIONS_FILE!.bak
)

:: �����ļ��������µ�vmoptions�ļ�
echo ���������µ�vmoptions�ļ�...

:: ��ȡ�ļ�����������չ����
for %%F in ("!FILE_NAME!") do set "IDE_NAME=%%~nF"

:: ����IDE����ѡ���Ӧ����������
set "CONTENT="

if /i "!IDE_NAME!"=="clion64" (
    set "CONTENT=-Xms256m^
-Xss2m^
-XX:NewSize=128m^
-XX:MaxNewSize=128m^
-Xmx2048m^
-XX:+HeapDumpOnOutOfMemoryError^
-XX:-OmitStackTraceInFastThrow^
-XX:+IgnoreUnrecognizedVMOptions^
-ea^
-Dsun.io.useCanonCaches=false^
-Dsun.java2d.metal=true^
-Djbr.catch.SIGABRT=true^
-Djdk.http.auth.tunneling.disabledSchemes=""^
-Djdk.attach.allowAttachSelf=true^
-Djdk.module.illegalAccess.silent=true^
-Dkotlinx.coroutines.debug=off^
-XX:CICompilerCount=2^
-XX:ReservedCodeCacheSize=512m^
-XX:+UnlockDiagnosticVMOptions^
-XX:TieredOldPercentage=100000^
-javaagent:!JAR_FILE!"
) else if /i "!IDE_NAME!"=="datagrip64" (
    set "CONTENT=-Xms256m^
-Xmx750m^
-XX:+HeapDumpOnOutOfMemoryError^
-XX:-OmitStackTraceInFastThrow^
-XX:+IgnoreUnrecognizedVMOptions^
-ea^
-Dsun.io.useCanonCaches=false^
-Dsun.java2d.metal=true^
-Djbr.catch.SIGABRT=true^
-Djdk.http.auth.tunneling.disabledSchemes=""^
-Djdk.attach.allowAttachSelf=true^
-Djdk.module.illegalAccess.silent=true^
-Dkotlinx.coroutines.debug=off^
-XX:CICompilerCount=2^
-XX:ReservedCodeCacheSize=512m^
-XX:+UnlockDiagnosticVMOptions^
-XX:TieredOldPercentage=100000^
-javaagent:!JAR_FILE!"
) else if /i "!IDE_NAME!"=="dataspell64" (
    set "CONTENT=-Xms256m^
-Xmx2048m^
-XX:+HeapDumpOnOutOfMemoryError^
-XX:-OmitStackTraceInFastThrow^
-XX:+IgnoreUnrecognizedVMOptions^
-ea^
-Dsun.io.useCanonCaches=false^
-Dsun.java2d.metal=true^
-Djbr.catch.SIGABRT=true^
-Djdk.http.auth.tunneling.disabledSchemes=""^
-Djdk.attach.allowAttachSelf=true^
-Djdk.module.illegalAccess.silent=true^
-Dkotlinx.coroutines.debug=off^
-XX:CICompilerCount=2^
-XX:ReservedCodeCacheSize=512m^
-XX:+UnlockDiagnosticVMOptions^
-XX:TieredOldPercentage=100000^
-javaagent:!JAR_FILE!"
) else (
    :: Ĭ�����ã�����������IDE��
    set "CONTENT=-Xms128m^
-Xmx2048m^
-XX:+HeapDumpOnOutOfMemoryError^
-XX:-OmitStackTraceInFastThrow^
-XX:+IgnoreUnrecognizedVMOptions^
-ea^
-Dsun.io.useCanonCaches=false^
-Dsun.java2d.metal=true^
-Djbr.catch.SIGABRT=true^
-Djdk.http.auth.tunneling.disabledSchemes=""^
-Djdk.attach.allowAttachSelf=true^
-Djdk.module.illegalAccess.silent=true^
-Dkotlinx.coroutines.debug=off^
-XX:CICompilerCount=2^
-XX:ReservedCodeCacheSize=512m^
-XX:+UnlockDiagnosticVMOptions^
-XX:TieredOldPercentage=100000^
-javaagent:!JAR_FILE!"
)

:: ���⴦��rubymine64�����ж����Xss2m����
if /i "!IDE_NAME!"=="rubymine64" (
    set "CONTENT=-Xss2m^
-Xms128m^
-Xmx2048m^
-XX:+HeapDumpOnOutOfMemoryError^
-XX:-OmitStackTraceInFastThrow^
-XX:+IgnoreUnrecognizedVMOptions^
-ea^
-Dsun.io.useCanonCaches=false^
-Dsun.java2d.metal=true^
-Djbr.catch.SIGABRT=true^
-Djdk.http.auth.tunneling.disabledSchemes=""^
-Djdk.attach.allowAttachSelf=true^
-Djdk.module.illegalAccess.silent=true^
-Dkotlinx.coroutines.debug=off^
-XX:CICompilerCount=2^
-XX:ReservedCodeCacheSize=512m^
-XX:+UnlockDiagnosticVMOptions^
-XX:TieredOldPercentage=100000^
^
-javaagent:!JAR_FILE!"
)

:: ʹ��UTF-8����д���ļ�
echo !CONTENT! > "!VMOPTIONS_FILE!"

:: ����ļ��Ƿ�ɹ�����
if exist "!VMOPTIONS_FILE!" (
    echo ��������ɹ����뾡����ˣ�ɣ�
    echo ���޸������ļ�: !VMOPTIONS_FILE!
) else (
    echo ����: �޷�����vmoptions�ļ���
    echo ��ȷ�������㹻��Ȩ�ޡ�
)

echo.
echo �Ƿ������������IDE��
choice /c YN /m "ѡ�� Y(��) �� N(��)"
if errorlevel 2 goto end
if errorlevel 1 goto process_ide

:end
echo.
echo ��лʹ��JetBrains IDE����ߣ�
echo ===================================================
pause
exit /b 0