@echo off
@echo Replacing Notepad with Notepad++
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" /v "Debugger" /t REG_SZ /d "\"%ProgramFiles%\Notepad++\notepad++.exe\" -notepadStyleCmdline -z" /f
@echo Notepad++ replaced Notepad as the notepad run command.
pause
exit
