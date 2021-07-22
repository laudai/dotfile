:: This script will suspend after N seconds via user
:: Before run this script. You need use `powercfg -hibernate off` in cmd via administrator user.

@ECHO OFF
set /p wait_secs="Suspend After N seconds : "

:: Ver 1
@REM ping -n  %wait_secs% 127.0.0.1 > NUL 2>&1 && rundll32.exe powrprof.dll,SetSuspendState 0,1,0

:: Ver 2
for /l %%s in (%wait_secs%, -1 ,0) do (
   echo You can Interrupt via Ctrl - C until %%s seconds.
   timeout /t 1 /nobreak > NUL
)
rundll32.exe powrprof.dll,SetSuspendState 0,1,0


@REM https://stackoverflow.com/questions/4097041/echoing-in-the-same-line

