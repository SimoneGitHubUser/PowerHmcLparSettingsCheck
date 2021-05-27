REM Version 1.0.0

@echo off
rem setLocal EnableDelayedExpansion

set localdir=%cd%
rem set plinkdir="C:\_Appoggio\Putty"
set tempfolder=tmp

FOR /F "tokens=1" %%A IN (%localdir%\vars\hmc_ip.txt) DO set hmc_ip=%%A
FOR /F "tokens=1" %%B IN (%localdir%\vars\hmc_user.txt) DO set hmc_user=%%B
FOR /F "tokens=1" %%C IN (%localdir%\vars\hmc_password.txt) DO set hmc_password=%%C
rem FOR /F "tokens=1" %%D IN (%localdir%\vars\lpar_id.txt) DO set lpar_id=%%D
rem FOR /F "tokens=1" %%E IN (%localdir%\vars\lpar_profile.txt) DO set lpar_profile=%%E
rem FOR /F "tokens=1" %%F IN (%localdir%\vars\managed_server_name.txt) DO set managed_server_name=%%F
rem FOR /F "delims="  %%G IN (%localdir%\vars\lpar_off_state.txt) DO set lpar_off_state=%%G
rem FOR /F "tokens=1" %%H IN (%localdir%\vars\lpar_on_state.txt) DO set lpar_on_state=%%H
rem FOR /F "tokens=1" %%I IN (%localdir%\vars\seconds_wait_01.txt) DO set seconds_wait_01=%%I
rem FOR /F "tokens=1" %%L IN (%localdir%\vars\lpar_parameter.txt) DO set lpar_parameter=%%L
rem FOR /F "tokens=1" %%M IN (%localdir%\vars\lpar_parameter_set_value.txt) DO set lpar_parameter_set_value=%%M

FOR /F "delims=1" %%N IN (%localdir%\vars\plink_dir.txt) DO set plink_dir=%%N
FOR /F "tokens=1" %%O IN (%localdir%\vars\os_type.txt) DO set os_type=%%O

rem echo pause a
rem pause


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


title PowerHmcLparSettingsCheck_%hmc_ip%


pause

mkdir %localdir%\%tempfolder%

echo ..           												>  %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_ip.....................%hmc_ip%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_user...................%hmc_user%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo hmc_password...............%hmc_password%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_id....................%lpar_id%						>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_profile...............%lpar_profile%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo managed_server_name........%managed_server_name%			>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_on_state..............%lpar_on_state%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_off_state.............%lpar_off_state%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo seconds_wait_01............%seconds_wait_01%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_parameter.............%lpar_parameter%				>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo lpar_parameter_set_value...%lpar_parameter_set_value%		>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo date time..................%Date% %time%					>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo plink_dir..................%plink_dir%					    >> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
echo os_type....................%os_type%					    >> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log

echo ..           												>> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log

cls


echo ..           											
echo hmc_ip.....................%hmc_ip%					
echo hmc_user...................%hmc_user%					
echo hmc_password...............%hmc_password%				
rem echo lpar_id....................%lpar_id%					
rem echo lpar_profile...............%lpar_profile%				
rem echo managed_server_name........%managed_server_name%		
rem echo lpar_on_state..............%lpar_on_state%				
rem echo lpar_off_state.............%lpar_off_state%			
rem echo seconds_wait_01............%seconds_wait_01%			
rem echo lpar_parameter.............%lpar_parameter%			
rem echo lpar_parameter_set_value...%lpar_parameter_set_value%	
rem echo date time..................%Date% %time%
echo plink_dir..................%plink_dir%
echo os_type....................%os_type%	
echo ..


:CheckIfAllReady


	:PingTheHmc
	
	echo Let's try to ping Hmc %hmc_ip%
	echo %date%_%time% ### PingTheHmc	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	echo Let's try to ping Hmc %hmc_ip% >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
	ping %hmc_ip% | find "Reply from %hmc_ip%" > nul
	if not errorlevel 1 (
		echo Hmc %hmc_ip% is online - ping success.
		echo .
		echo Hmc %hmc_ip% is online - ping success. >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	) else (
		echo Hmc %hmc_ip% has been taken down, waiting for few seconds to check again
		echo Check also hmc_ip value 	
		echo Hmc %hmc_ip% has been taken down, waiting for few seconds to check again >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
				
		ping localhost -n 1 -w 3000 >NUL
        rem pause
		goto :PingTheHmc
	) 
	:EndPingTheHmc

	:HmcPromptCheck
	echo %date%_%time% ### HmcPromptCheck	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
	echo ********************************************************
	echo * If "access denied" is promted below .................*
	echo * 1) Close this window with Ctrl+C.....................*
	echo * 2) Check user and password values....................*
	echo * 3) In case, do not use blanks, or special characters.*
	echo *                                                      *
	echo ********************************************************
	
	echo whoami > %localdir%\%tempfolder%\PlinkCommand.txt

    %plink_dir%\plink.exe -batch %hmc_user%@%hmc_ip% -pw %hmc_password% -m %localdir%\%tempfolder%\PlinkCommand.txt >%localdir%\%tempfolder%\Hmc_%hmc_ip%_PromptCheck.txt
	rem pause
	rem %plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% whoami >%localdir%\%tempfolder%\Hmc_%hmc_ip%_PromptCheck.txt
	FOR /F "delims=" %%T IN (%localdir%\%tempfolder%\Hmc_%hmc_ip%_PromptCheck.txt) DO set _HmcPromptCheck=%%T
	
	echo .
	if %_HmcPromptCheck%==%hmc_user% echo Hmc %hmc_ip% is online and responds to login - user=%_HmcPromptCheck%
    if %_HmcPromptCheck%==%hmc_user% echo Proceed with Servers Scan
    echo .
    if %_HmcPromptCheck%==%hmc_user% echo Hmc %hmc_ip% is online and responds to login - user=%_HmcPromptCheck% >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	:EndHmcPromptCheck


:EndCheckIfAllReady


:ManagedServerList
	echo %date%_%time% ### ManagedServerList	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
    echo lssyscfg -r sys -F name > %localdir%\%tempfolder%\PlinkCommand.txt
    rem pause
    %plink_dir%\plink.exe -batch %hmc_user%@%hmc_ip% -pw %hmc_password% -m %localdir%\%tempfolder%\PlinkCommand.txt >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	%plink_dir%\plink.exe -batch %hmc_user%@%hmc_ip% -pw %hmc_password% -m %localdir%\%tempfolder%\PlinkCommand.txt >%localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt
	
    rem %plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r sys -F name >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	rem %plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r sys -F name >%localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt																
	
    echo ..
    echo ..
	echo Server managed by HMC %hmc_ip% are:
	type %localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt
	rem pause
:EndManagedServerList

:LparList
	
	echo %date%_%time% ### LparList	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	
		for /f "delims=" %%a in (%localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt) do set managed_server_name=%%a&call :process
		goto :GenerateReport
	
			:process
			rem echo managed_server_name=%managed_server_name%
			echo managed_server_name=%managed_server_name% >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log

            echo lssyscfg -r lpar -m %managed_server_name% -F lpar_id,name,lpar_env,os400_restricted_io_mode,redundant_err_path_reporting > %localdir%\%tempfolder%\PlinkCommand.txt
            rem pause
            %plink_dir%\plink.exe -batch %hmc_user%@%hmc_ip% -pw %hmc_password% -m %localdir%\%tempfolder%\PlinkCommand.txt >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
	        %plink_dir%\plink.exe -batch %hmc_user%@%hmc_ip% -pw %hmc_password% -m %localdir%\%tempfolder%\PlinkCommand.txt >%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.txt

			rem if %var%==%lpar_id% goto :ExitLparListOk
			rem %plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% -F lpar_id,name,lpar_env,os400_restricted_io_mode,redundant_err_path_reporting >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
            rem %plink_dir%\plink.exe -l  %hmc_user% -pw %hmc_password% %hmc_ip% lssyscfg -r lpar -m %managed_server_name% -F lpar_id,name,lpar_env,os400_restricted_io_mode,redundant_err_path_reporting  >%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.txt

                    REM Remove blank spaces from lpar names file
                    @If Exist "%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.txt" (For /F Delims^=^ EOL^= %%W In ('More /T1 "%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.txt"')Do @Set "$=%%W"&Call Echo(%%$: =%%)>"%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.out"
                    )
                
		        rem FOR /F "tokens=1-3 delims=," %%I IN (%localdir%\Vars\SmcB.txt) DO ( set SmcBIP=%%I 
				rem															set SmcBUser=%%J
				rem 														set SmcBPassword=%%K
				rem															)	

                echo. 2>%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out
                for /f "tokens=1-5 delims=, " %%d in (%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparList.out) do (
                rem if %%f==%os_type% echo %%a, %%d, %%e, %%f, %%g, %%h
                if %%f==%os_type% echo %%a,%%d,%%e,%%f,%%g,%%h >> %localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out        
                set /a N+=1
                 )

                rem echo pause 001
                rem pause 

                 :exit

            goto :eof
			
:EndLparList




:GenerateReport
echo %date%_%time% ### GenerateReport	 >>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo .. Check Var Values	>>%localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
rem echo .. Check Var Values
rem echo ..
rem echo .. Report:
rem echo .. Hmc %hmc_ip% manages the following Power Server, and IBMi Lpars
rem type %localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt

		for /f "delims=" %%a in (%localdir%\%tempfolder%\Hmc_%hmc_ip%_ManagedServerList.txt) do set managed_server_name=%%a&call :process2
		goto :quit
	
			:process2
			
                rem echo. 2>%localdir%\Hmc_%hmc_ip%_%managed_server_name%_Report.csv
                echo Managed Server,Lpar ID,Lpar Name,os_version,os400_restricted_io_mode,redundant_err_path_reporting >%localdir%\Hmc_%hmc_ip%_%managed_server_name%_Report.csv
                for /f "tokens=1-6 delims=, " %%d in (%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out) do (
                rem echo d %%d, e %%e, f %%f, g %%g, h %%h, i %%i
                rem echo %%h
                rem echo %%i    
                rem if %%h==1  echo %%d, %%e, %%f, %%g ...... Lpars Settings are ready for LPM
                rem if %%h==0  echo %%d, %%e, %%f, %%g ........ Not ready LPM
                echo %%d,%%e,%%f,%%g,%%h,%%i >> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
                echo %%d,%%e,%%f,%%g,%%h,%%i >> %localdir%\Hmc_%hmc_ip%_%managed_server_name%_Report.csv        
                set /a N+=1
                 )

                rem for /f "tokens=1-5 delims=, " %%d in (%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_Report.out) do (
                rem if %%f==%os_type% echo %%a, %%d, %%e, %%f, %%g, %%h
                rem if %%f==%os_type% echo %%a,%%d,%%e,%%f,%%g,%%h >> %localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out        
                rem set /a N+=1
                rem  )
                rem (for /f usebackq^ eol^= %%k in ("%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out") do break) && echo has data || echo %managed_server_name% has no IBMi Lpars
                
                call :CheckEmpty "%localdir%\%tempfolder%\Hmc_%hmc_ip%_%managed_server_name%_LparListOs400.out"
                goto :eof

                :CheckEmpty
                if %~z1 == 0 echo ....
                if %~z1 == 0 echo %managed_server_name% has no IBMi Lpars >> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
                if %~z1 == 0 echo %managed_server_name% has no IBMi Lpars
                if %~z1 == 0 echo Nothing to Check
                if %~z1 == 0 echo ....
                rem echo %managed_server_name% has lots of IBMi Lpars
                if NOT %~z1 == 0 echo ....
                if NOT %~z1 == 0 echo %managed_server_name% has some IBMi lpars defintions >> %localdir%\PowerHmcLparSettingsCheck_%hmc_ip%.log
                if NOT %~z1 == 0 echo %managed_server_name% has some IBMi lpars defintions 
                if NOT %~z1 == 0 echo check %hmc_ip% %managed_server_name% Report cvs files for details
                if NOT %~z1 == 0 echo ....
                goto :eof

                
                echo pause 001
                pause 

                 :exit

            goto :eof
echo pause xx
pause
exit
:EndGenerateReport
echo pause yy
pause


:Quit
rem echo pause 005
echo Finished
pause
exit