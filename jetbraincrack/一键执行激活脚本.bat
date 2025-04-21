@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 1. 检查Java环境
echo 正在检查Java环境...
java -version 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [错误] Java未安装或未配置环境变量！
    echo 请安装JDK并设置JAVA_HOME环境变量后重试
    pause
    exit /b 1
)
for /f "tokens=3" %%j in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set "jver=%%j"
    set "jver=!jver:"=!"
)
echo 检测到Java版本: !jver!
echo.

:: 2. 用户输入License ID和User Name
:input
set /p license_id=请输入License ID： 
set /p user_name=请输入User Name： 

:: 3. 生成key.txt
echo 正在生成key.txt...
java -jar sniarbtej-2024.2.8.jar -genkey -id=%license_id% -user=%user_name% > key.txt 2>nul

if not exist "key.txt" (
    echo 生成失败，未生成key.txt
    goto input
)

for %%F in ("key.txt") do set size=%%~zF
if %size% EQU 0 (
    del "key.txt" >nul 2>&1
    echo.
    echo [错误] 生成失败，可能是输入的License ID或User Name无效
    echo 请重新输入
    echo.
    goto input
)

echo.
echo key.txt 生成成功！
echo.

:: 4. 获取补丁文件的绝对路径（修正路径格式）
for %%A in ("%~dp0sniarbtej-2024.2.8.jar") do set "jar_path=%%~fA"
set "jar_path=%jar_path:\=/%"

:: 5. 用户拖放或输入路径处理
:input_path
set "target_file="
set /p "target_file=请拖放JetBrains的.exe或快捷方式到窗口，或输入路径："

:: 移除路径首尾的引号（如果存在）
set "target_file=!target_file:"=!"

:: 6. 解析快捷方式（如果是.lnk文件）
if /i "!target_file:~-4!"==".lnk" (
    for /f "tokens=*" %%A in (
        'powershell -command "(New-Object -ComObject WScript.Shell).CreateShortcut(''!target_file!'').TargetPath" 2^>nul'
    ) do (
        set "target_file=%%~A"
        set "target_file=!target_file:"=!"
    )
)

:: 7. 检查文件是否存在
if not exist "!target_file!" (
    echo.
    echo [错误] 文件不存在: !target_file!
    goto input_path
)

:: 8. 提取文件名（如idea64.exe）
for %%F in ("!target_file!") do set "exe_name=%%~nxF"

:: 9. 验证是否为JetBrains可执行文件
set "valid_exe=false"
for %%I in (
    clion64.exe datagrip64.exe dataspell64.exe goland64.exe idea64.exe 
    phpstorm64.exe pycharm64.exe rider64.exe rubymine64.exe 
    rustrover64.exe webstorm64.exe
) do (
    if /i "!exe_name!"=="%%~I" set "valid_exe=true"
)

if "!valid_exe!"=="false" (
    echo.
    echo [错误] 不是有效的JetBrains可执行文件: !exe_name!
    echo 支持的可执行文件包括：
    echo clion64.exe, datagrip64.exe, dataspell64.exe, goland64.exe, idea64.exe
    echo phpstorm64.exe, pycharm64.exe, rider64.exe, rubymine64.exe
    echo rustrover64.exe, webstorm64.exe
    pause
    goto input_path
)

:: 10. 构造.vmoptions文件路径（与exe同目录）
for %%F in ("!target_file!") do set "vmoptions_path=%%~dpF!exe_name!.vmoptions"

:: 11. 备份原文件（如果存在）
if exist "!vmoptions_path!" (
    copy "!vmoptions_path!" "!vmoptions_path!.bak" >nul
    echo.
    echo 已备份原文件: !vmoptions_path!.bak
)

:: 12. 生成完整的.vmoptions内容（修正javaagent路径格式）
(
    echo -Xms128m
    echo -Xmx2048m
    echo -XX:+HeapDumpOnOutOfMemoryError
    echo -XX:-OmitStackTraceInFastThrow
    echo -XX:+IgnoreUnrecognizedVMOptions
    echo -ea
    echo -Dsun.io.useCanonCaches=false
    echo -Dsun.java2d.metal=true
    echo -Djbr.catch.SIGABRT=true
    echo -Djdk.http.auth.tunneling.disabledSchemes=""
    echo -Djdk.attach.allowAttachSelf=true
    echo -Djdk.module.illegalAccess.silent=true
    echo -Dkotlinx.coroutines.debug=off
    echo -XX:CICompilerCount=2
    echo -XX:ReservedCodeCacheSize=512m
    echo -XX:+UnlockDiagnosticVMOptions
    echo -XX:TieredOldPercentage=100000
    echo -javaagent:%jar_path%
) > "!vmoptions_path!"

:: 13. 输出结果
echo.
echo ========================================
echo 已生成文件: !vmoptions_path!
echo 补丁路径: %jar_path%
echo ========================================
echo.
pause