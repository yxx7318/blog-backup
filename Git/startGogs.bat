@echo off
setlocal

:: 设置 Gogs 的安装路径
set GOGS_PATH="C:\ProgramData\Gogs\gogs"

:: 启动 CMD 窗口并执行 Gogs web 命令
start cmd /k "%GOGS_PATH%\gogs.exe web"

endlocal
