:: This script will suspend system at specific time via creat a schedule.
:: Before run this script. You need use `powercfg -hibernate off` in cmd via administrator user.

@ECHO OFF
echo Suspend System at your Specific Time via create a once schedule force.
set /p specific_time="Enter your time like hh:mm: "
echo %specific_time%
set tnName=Suspend_Your_Computer_At_Specific_Time
:: Create a schtasks to suspend
schtasks /create /tn %tnName% /F /tr %userprofile%\.dotfile\windows_script\suspend_now.bat /sc once /st %specific_time%

echo.
echo You can cancle before %specific_time%
echo.

echo Do you want to cancle this schedule?
echo.

set /p reply="Enter your result (type y or yes to cancle): "
:switch-case-result
  goto :switch-cancle-result-%reply% 2>nul || (
      echo No cancle the schedule
      echo.
      pause
  )
  :switch-cancle-result-y
    schtasks /delete /F /tn %tnName%
    echo.
    goto :switch-case-to-end
  
  :switch-cancle-result-yes
    schtasks /delete /F /tn %tnName%
    echo.
    goto :switch-case-to-end


:switch-case-to-end
    echo Cancle the suspend schedule.
    echo.
    pause


@REM https://stackoverflow.com/questions/4097041/echoing-in-the-same-line

