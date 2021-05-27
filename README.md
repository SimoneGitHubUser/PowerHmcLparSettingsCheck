# PowerHmcLparSettingsCheck
PowerHmcLparSettingsCheck is a simple tool, used to check with "a single double click", if IBMi Lpars, hosted by an IBM Power System, are ready to be moved with Live Partition Mobility.
It is a batch programming tool, that runs on windows operating system (extended testing on Win10, but it should work also on other Win releases).
It Is very useful in case of HMC manages al lot of Power servers, with a lot of Lpars (IBM i, Linux, AIX)
After a simple set-up, you can generate a report (few seconds required), with all informations you need for IBMi Lpar LPM Settings. Using the HMC Gui, the LPM Settings check, may require hours, depending on your environment complessity. 

## Settings check for IBMi LPM
Based on "Requirements for IBM i LPM" 
https://www.ibm.com/support/pages/requirements-ibm-i-lpm

IBMi lpars, need 2 specific advanced settings, to be checked, before try to use LPM. 

* The property “restricted I/O” must be set on the IBM i partition.
* The IBM i partition must not be an alternative error logging partition.

PowerHmcLparSettingsCheck create a specific report, to check this 2 IBMi Settings.

## What do you need?
* Ip address, user and passowrd of HMC
* plink.exe

This is all you need. 

### Initial Settings
1)  PowerHmcLparSettingsCheck uses Plink, to connect to HMC. You can download Plink from 
 https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

Plink.exe file must be placed in the following folder
../PowerHmcLparSettingsCheck/exe

2) ssh connection and remote commands execution, must be enabled on HMC
https://www.ibm.com/support/pages/hmc-enhanced-view-enabling-sshremote-command-execution

## How it works?
1) Complete Initial Settings
2) Double click on PowerHmcLparSettingsCheck.cmd, and the tool will execute the following tasks:
    * Verify that HMC is reachable
    * Verify that User and Password provided are correct
    * Check and list all Power Servers, managed by Hmc
    * For each Power Server, check all defined Lpars
    * If IBMi lpars are found, checks for os400_restricted_io_mode and redundant_err_path_reporting settings
    * For each server, creates a .csv file report
3) You can execute the tool, as many time as you want, with a simple double click.  

## Final Checks
Once the report is generated, you can open .csv file and verify LPM settings readiness for each IBM i Lpar
    
    If 
    os400_restricted_io_mode is enabled (value=1) 
    and 
    redundant_err_path_reporting is disabled (value=0)
    you can proceed with normal Validate LPM process.

NB: redundant_err_path_reporting=0 is a prerequisite of os400_restricted_io_mode=1. So, if you have os400_restricted_io_mode=1, you have also redundant_err_path_reporting=0 "ready" for LPM.

## Whats next?
I'm working on a new tool, PowerHmcLparSettingsChange, very usefull to change os400_restricted_io_mode and redundant_err_path_reporting, in unattend mode.
A beta version of the tool is already available, and works fine. But it requires some program optimizations.

If you are interested, you can find at

https://github.com/SimoneGitHubUser/PowerHmcLparSettingsChange

Let me know if you are interested.



