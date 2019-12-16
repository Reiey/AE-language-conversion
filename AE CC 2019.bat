@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
set #=AE-language-conversion [CC 2019]
title %#%
cd /d "%~dp0"
set "cn=zh_CN"
set "us=en_US"
set "file=application.xml"
cls
if exist "%file%" (
    call :check "%file%"
    echo;1:切换中文
    echo;2:切换英文
    echo;0:—退出—
    set /p c=输入序号进行语言切换:
    setlocal enabledelayedexpansion
    if "!c!" equ "1" (
        call :modify "%file%" "%cn%"
		echo;切换中文成功！
    )
    if "!c!" equ "2" (
        call :modify "%file%" "%us%"
		echo;切换英文成功！
    )
    endlocal
    goto end
)
set "list=\Support Files\AMT\%file%"
for %%a in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
    if exist %%a:\ (
        echo;%%a: 正在搜索配置文件……
        for /f "delims=" %%b in ('dir /ad/b/s "%%a:\Adobe After Effects CC 2019"') do (
            if exist "%%b%list%" (
                echo;找到啦！
				call :check "%%b%list%"
                echo;1:切换中文
                echo;2:切换英文
                echo;0:—退出—
                set /p c=输入序号进行语言切换:
                setlocal enabledelayedexpansion
                if "!c!" equ "1" (
                    call :modify "%%b%list%" "%cn%"
					echo;切换中文成功！
                )
                if "!c!" equ "2" (
                    call :modify "%%b%list%" "%us%"
					echo;切换英文成功！
                )
                endlocal
                goto end
            )
        )
    )
)
:end
echo;开袋即食 - www.reiey.com
pause&exit
:check
powershell -NoProfile -ExecutionPolicy bypass ^
    $encoding=New-Object System.Text.UTF8Encoding $False;^
    $text=[IO.File]::ReadAllText('%~1', $encoding);^
    $m=[regex]::match($text,'^<Data key=\"installedLanguages\"^>[^^^<]*^<\/Data^>');^
    if($m.Success){write-host $m.groups[0].value;};
exit/b
:modify
powershell -NoProfile -ExecutionPolicy bypass ^
    $encoding=New-Object System.Text.UTF8Encoding $False;^
    $text=[IO.File]::ReadAllText('%~1', $encoding);^
    $text=$text -replace '(?^<=^<Data key=\"installedLanguages\"^>)[^^^<]*','%~2';^
    [IO.File]::WriteAllLines('%~1', $text, $encoding);
exit/b
