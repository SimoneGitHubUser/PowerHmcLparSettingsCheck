@echo off
rem setLocal EnableDelayedExpansion

set localdir=%cd%
rem set plinkdir="C:\_Appoggio\Putty"
set tempfolder=tmp

FOR /F "tokens=1" %%A IN (%localdir%\vars\hmc_ip.txt) DO set hmc_ip=%%A
FOR /F "tokens=1" %%B IN (%localdir%\vars\hmc_user.txt) DO set hmc_user=%%B
FOR /F "tokens=1" %%C IN (%localdir%\vars\hmc_password.txt) DO set hmc_password=%%C
FOR /F "tokens=1" %%D IN (%localdir%\vars\lpar_id.txt) DO set lpar_id=%%D
FOR /F "tokens=1" %%E IN (%localdir%\vars\lpar_profile.txt) DO set lpar_profile=%%E
FOR /F "tokens=1" %%F IN (%localdir%\vars\managed_server_name.txt) DO set managed_server_name=%%F
FOR /F "delims="  %%G IN (%localdir%\vars\lpar_off_state.txt) DO set lpar_off_state=%%G
FOR /F "tokens=1" %%H IN (%localdir%\vars\lpar_on_state.txt) DO set lpar_on_state=%%H
FOR /F "tokens=1" %%I IN (%localdir%\vars\seconds_wait_01.txt) DO set seconds_wait_01=%%I
FOR /F "tokens=1" %%L IN (%localdir%\vars\lpar_parameter.txt) DO set lpar_parameter=%%L
FOR /F "tokens=1" %%M IN (%localdir%\vars\lpar_parameter_set_value.txt) DO set lpar_parameter_set_value=%%M

FOR /F "delims=1" %%N IN (%localdir%\vars\plink_dir.txt) DO set plink_dir=%%N


	Rem DOSWindowResizing
rem	mode con:cols=80 lines=30
	Rem end DOSWindowResizing
	
	Rem DOSWindowChangeColor
	color 0A
	Rem end DOSWindowChangeColor



REM lpar_state_01=%%z
REM lpar_state_02=%%y
REM %%W
REM %%X
REM %%V
REM %%U


title HMC_%hmc_ip%_%managed_server_name%_Lpar_id_%lpar_id%


pause

mkdir %localdir%\%tempfolder%

echo ..           												>  %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_ip.....................%hmc_ip%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_user...................%hmc_user%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_password...............%hmc_password%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_id....................%lpar_id%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_profile...............%lpar_profile%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo managed_server_name........%managed_server_name%			>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_on_state..............%lpar_on_state%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_off_state.............%lpar_off_state%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo seconds_wait_01............%seconds_wait_01%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_parameter.............%lpar_parameter%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo lpar_parameter_set_value...%lpar_parameter_set_value%		>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo date time..................%Date% %time%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo ..           												>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log

cls


echo ..           											
echo hmc_ip.....................%hmc_ip%					
echo hmc_user...................%hmc_user%					
echo hmc_password...............%hmc_password%				
echo lpar_id....................%lpar_id%					
echo lpar_profile...............%lpar_profile%				
echo managed_server_name........%managed_server_name%		
echo lpar_on_state..............%lpar_on_state%				
echo lpar_off_state.............%lpar_off_state%			
echo seconds_wait_01............%seconds_wait_01%			
echo lpar_parameter.............%lpar_parameter%			
echo lpar_parameter_set_value...%lpar_parameter_set_value%	
echo date time..................%Date% %time%
echo ..


:CheckIfAllReady


	:PingTheHmc
	
	echo Let's try to ping HMC %hmc_ip%
	echo %date%_%time% ### PingTheHmc	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	echo Let's try to ping HMC %hmc_ip% >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
	ping %hmc_ip% | find "Reply from %hmc_ip%" > nul
	if not errorlevel 1 (
		echo HMC %hmc_ip% is online - ping success.
		echo .
		echo HMC %hmc_ip% is online - ping success. >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	) else (
		echo HMC %hmc_ip% has been taken down, waiting for few seconds to check again
		echo Check also hmc_ip value 	
		echo HMC %hmc_ip% has been taken down, waiting for few seconds to check again >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
				
		ping localhost -n 1 -w 3000 >NUL
		goto :PingTheHmc
	) 
	:EndPingTheHmc

	:HmcPromptCheck
	echo %date%_%time% ### HmcPromptCheck	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
	echo ********************************************************
	echo * If "access denied" is prompted below.................*
	echo * 1) Close this window with Ctrl+C.....................*
	echo * 2) Check user and password values....................*
	echo * 3) In case, do not use blanks, or special characters.*
	echo *                                                      *
	echo ********************************************************
	
	
	
	%plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% whoami >%localdir%\%tempfolder%\Hmc_%hmc_ip%_PromptCheck.txt
	FOR /F "delims=" %%T IN (%localdir%\%tempfolder%\Hmc_%hmc_ip%_PromptCheck.txt) DO set _HmcPromptCheck=%%T
	
	echo .
	if %_HmcPromptCheck%==%hmc_user% echo HMC %hmc_ip% is online and respond to login - user=%_HmcPromptCheck%
	if %_HmcPromptCheck%==%hmc_user% echo HMC %hmc_ip% is online and respond to login - user=%_HmcPromptCheck% >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	:EndHmcPromptCheck


:EndCheckIfAllReady

:EndNoActions
echo %date%_%time% ### EndNoActions	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo .. Check Var Values	>>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo .. Check Var Values
pause
exit
:EndEndNoActions
pause