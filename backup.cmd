::We're just setting up a few things here. We disable echo so that we won't get the c:\users bit, checking if we have admin rights with net session, clear the screen with cls and output a few lines of text.
echo off
net session > NUL
cls
echo One-click Backup version 1.0
echo Written by Andrea Luciano Damico and released under the MIT license.
echo For more information, visit www.github.com/Tech4Freelancers
::This part checks if we have admin rights. If the %ERRORLEVEL% variable has a value of 0, we're admins and we may backup everything, otherwise we can only back up public folders and the current user's.
if %ERRORLEVEL% EQU 0 (
	echo The program is running as administrator. You may back up all users.
) else (
	echo The program is running as a normal user. You may only back up public folders and the %username% folder.
)
::We're asking the user what she wants to back up. Valid choices are all valid folders, only the current user's, or only public folders. Then, we check the choice and jump to a particular part of the script.
choice /C ACP /N /M "What to backup? (A)ll valid users, (C)urrent user, (P)ublic only"
if %ERRORLEVEL% EQU 1 goto allusers
if %ERRORLEVEL% EQU 2 goto currentuser
if %ERRORLEVEL% EQU 3 goto publiconly
::This bit backs up everything in the c:\users folder. We're excluding the appdata folder because it takes up a lot of space and log files because we don't need to recover them.
:allusers
echo Backing up all users.
robocopy c:\users\ %~dp0\Backup\users /e /xj /copy:dat /r:1 /w:1 /xd appdata /xf *.log
goto completed
::This bit only backs up the current user's folder, represented by the variable %username%. We're excluding the appdata folder because it takes up a lot of space and log files because we don't need to recover them.
:currentuser
echo Backing up %username%
robocopy "c:\users\%username%" "%~dp0\Backup\users\%username%" /e /xj /copy:dat /r:1 /w:1 /xd appdata /xf *.log
goto completed
::This bit only backs up the All users and Public folder under Users. We're excluding the appdata folder because it takes up a lot of space and log files because we don't need to recover them.
:publiconly
echo Backing up public only
robocopy "c:\users\All users" "%~dp0\Backup\users\All users" /e /xj /copy:dat /r:1 /w:1 /xd appdata /xf *.log
robocopy "c:\users\Public" "%~dp0\Backup\users\Public" /e /xj /copy:dat /r:1 /w:1 /xd appdata /xf *.log
goto completed
::This marks the end of the program. We're showing a message and ask the user to press any key to close the program.
:completed
echo Process completed. Press any key to close the program.
pause > NUL
