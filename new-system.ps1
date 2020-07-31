# This script will set up a new computer on the local network once it has completed OOBE and installed the Windows Package Manager
# This requires Winget as a prerequisite
# Programs can be skipped by commenting them out using a hashtag
# Every function here is redundant in the answers it's looking for when the user is provided with a "yes/no" question. The acceptable syntax for these questions will always either be "yes," "no," "y," or "n." This is a commented note at the top of the script because the user is constantly presented with the option to use either/or during every function that supports a yes or no answer.
# Copyright Joshua Lovejoy, 2020. All rights reserved.

Function networked_storage { # this maps a networked drive to the letter the user sets when prompted in the PowerShell console. This section directly and heavily relies on user input through the Read-Host command. Inputs in Read-Host are then stored in different variables to be accessed by cmdlets to map the drive, as well as informing them that drives mounted as administrator need to be remounted in user-space.
	$readhost = Read-Host "Type your UNC path to your networked storage here"
	$uncpath = $readhost
	$readhostdl = Read-Host 'What drive letter would you like to map the drive to?'
	$credentialsrequired = Read-Host "Does the network drive or share you're connecting to require a different set of user credentials to log in?"
	Switch ($credentialsrequired) {
		Y {$readhostcr = Read-Host 'Please enter your username to the network drive in standard Windows credential format: "system\user"'
		$cred = Get-Credential -Credential $readhostcr
		pause
		new-psdrive -name $readhostdl -psprovider FileSystem -root $uncpath -scope "Global" -credential $cred -persist # this section of the switch allows for the user to connect to a password protected share
		pause}
		N {new-psdrive -name $readhostdl -psprovider FileSystem -root $uncpath -scope "Global" -persist #this section of the switch allows for users to bypass credential verification where it's not needed
		pause}
		Yes {$readhostcr = Read-Host 'Please enter your username to the network drive in standard Windows credential format: "system\user"'
		$cred = Get-Credential -Credential $readhostcr
		new-psdrive -name $readhostdl -psprovider FileSystem -root $uncpath -scope "Global" -credential $cred -persist # redundancy for if a user types "yes" when prompted and not "y"
		pause}
		No {new-psdrive -name $readhostdl -psprovider FileSystem -root $uncpath -scope "Global" -persist # redundancy for if a user types "no" when prompted and not "n"
		pause}
	}
	write-host "If this script is run in an elevated command prompt this drive will not be visible until you map it in user space. Please rerun the script with PowerShell running in user space." # user notice
	pause
	$readhostredo = Read-Host "Would you like to map another drive to your system? Please respond with y or n." 
		Switch ($readhostredo) {
			Y {networked_storage} # this repeats the function so that the end user can map more than one share to their system.
			
			N {write-host "The script is complete and your PC should now be set up with your desired programs. You are also now connected to your networked storage. Enjoy your new PC!"
			pause
			exit} # script completion
			# ends script on end user input
			
			Yes {networked_storage} # redundancy for yes and no vs y and n
			
			No {write-host "The script is complete and your PC should now be set up with your desired programs. You are also now connected to your networked storage. Enjoy your new PC!"
			pause
			exit} # redundancy for yes and no vs y and n
		}
}
Function networked_storage_prompt {
	write-host "Would you like to connect to local networked storage?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
	
	Switch ($readhost) {
	
		Y {networked_storage}
		
		Yes {networked_storage}
		
		N {write-host "The script is complete and your PC should now be set up with your desired programs. Enjoy your new PC!"; 
		pause
		exit}
		# ends script on end user input
		
		No {write-host "The script is complete and your PC should now be set up with your desired programs. Enjoy your new PC!"; 
		pause
		exit}
		# ends script on end user input
	}
}
Function user_applications { # this function is where users who download this script can insert their own applications to install through winget
	write-host "Did you add any applications to this script before running it? This section will install all applications you put in the proper command for in winget. If you type yes without having any programs added, the script will ignore this section."
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
	
	# note: by default the script will skip this section and go to the next function. You ***must*** put programs in the Yes and/or Y arguments to the programs you want to install.
	
	Switch ($readhost) {
		Y {networked_storage_prompt}
		Yes {networked_storage_prompt}
		N {networked_storage_prompt}
		No {networked_storage_prompt}
	}
}
Function game_launchers { # this function will prompt the user to install common game launchers
	write-host "Will this PC be used for gaming?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
	
	Switch ($readhost) {
		
		Y {write-host "Installing Steam"
		winget install --exact Valve.Steam | Out-Null
		
		write-host "Installing Origin"
		winget install --exact ElectronicArts.Origin | Out-Null
		
		write-host "Installing Uplay"
		winget install --exact Ubisoft.Uplay | Out-Null
		
		write-host "Installing GOG Galaxy 2"
		winget install --exact GOG.Galaxy | Out-Null
		
		write-host "Installing the Epic Games Launcher"
		winget install --exact EpicGames.EpicGamesLauncher | Out-Null
		
		write-host "Installing Discord"
		winget install --exact Discord.Discord | Out-Null
		
		write-host "Installing OBS Studio"
		winget install --exact OBSProject.OBSStudio | Out-Null
		
		user_applications}
				
		Yes {write-host "Installing Steam"
		winget install --exact Valve.Steam | Out-Null
		
		write-host "Installing Origin"
		winget install --exact ElectronicArts.Origin | Out-Null
		
		write-host "Installing Uplay"
		winget install --exact Ubisoft.Uplay | Out-Null
		
		write-host "Installing GOG Galaxy 2"
		winget install --exact GOG.Galaxy | Out-Null
		
		write-host "Installing the Epic Games Launcher"
		winget install --exact EpicGames.EpicGamesLauncher | Out-Null
		
		write-host "Installing Discord"
		winget install --exact Discord.Discord | Out-Null
		
		write-host "Installing OBS Studio"
		winget install --exact OBSProject.OBSStudio | Out-Null
		
		user_applications}
		
		N {write-host "Skipping installation of gaming launchers..."
		
		user_applications}
		
		No {write-host "Skipping installation of gaming launchers..."
		
		user_applications}
	}
}
Function audio_programs { # this function will prompt the end user to install 3rd party audio tools
	write-host "Will this machine be used in audio production or will this machine be used for media consumption?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
	
	Switch ($readhost) {
		
		Y {write-host "Installing Audacity"
		winget install --exact Audacity.Audacity | Out-Null
		
		write-host "Installing Dopamine"
		winget install --exact Digimezzo.Dopamine | Out-Null
		
		write-host "Installing EarTrumpet"	
		winget install EarTrumpet | Out-Null
		
		write-host "Installing VLC Media Player"
		winget install --exact VideoLAN.VLC | Out-Null
		
		game_launchers}
		
		Yes {write-host "Installing Audacity"
		winget install --exact Audacity.Audacity | Out-Null
		
		write-host "Installing Dopamine"
		winget install --exact Digimezzo.Dopamine | Out-Null
		
		write-host "Installing EarTrumpet"	
		winget install EarTrumpet | Out-Null
		
		write-host "Installing VLC Media Player"
		winget install --exact VideoLAN.VLC | Out-Null
		
		game_launchers}
		
		N {write-host "Skipping installation of media applications..."
		
		game_launchers}
		
		No {write-host "Skipping installation of media applications..."
		
		game_launchers}
	}
}
Function power_user { # this function will prompt users to install programs that are used to boost productivity and make the most out of their hardware.
	write-host "Does the primary user of this computer consider themselves a 'power user?' or is the computer meant to be used for productivity?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
	
	Switch ($readhost) {
		
		Y {write-host "Installing QuickLook"
		winget install --exact QL-Win.QuickLook | Out-Null

		write-host "Installing 7zip"
		winget install --exact 7zip.7zip | Out-Null
		
		write-host "Installing FileZilla Client"
		winget install --exact TimKosse.FilezillaClient | Out-Null
		
		write-host "Installing Microsoft PowerToys"
		winget install --exact Microsoft.PowerToys | Out-Null
		
		audio_programs}
		
		Yes {write-host "Installing QuickLook"
		winget install --exact QL-Win.QuickLook | Out-Null

		write-host "Installing 7zip"
		winget install --exact 7zip.7zip | Out-Null
		
		write-host "Installing FileZilla Client"
		winget install --exact TimKosse.FilezillaClient | Out-Null
		
		write-host "Installing Microsoft PowerToys"
		winget install --exact Microsoft.PowerToys | Out-Null
		
		audio_programs}
		
		N {write-host "Skipping installation of productivity related applications..."
		
		audio_programs}
		
		No {write-host "Skipping installation of productivity related applications..."
		
		audio_programs}
		
	}
}
Function general_user { # this function will prompt the user to install programs used in common scenarios such as web browsing or using 2FA.
	write-host "Is this computer intended for general use?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."
		
	Switch ($readhost) {
		Y {write-host "Now installing Authy Desktop"
		winget install --exact Twillio.Authy | Out-Null

		write-host "Updating Microsoft Edge to newest version"
		winget install --exact Microsoft.Edge | Out-Null
		
		power_user}
		
		Yes {write-host "Now installing Authy Desktop"
		winget install --exact Twillio.Authy | Out-Null

		write-host "Updating Microsoft Edge to newest version"
		winget install --exact Microsoft.Edge | Out-Null
		
		power_user}
		
		N {write-host "Skipping installation of general use applications..."
		
		power_user}
		
		No {write-host "Skipping installation of general use applications..."
		
		power_user}
	}
}
Function developer { # this function will prompt the end user to install programs commonly used in development deployments
	write-host "Will this machine be used for application development?"
	$readhost = Read-Host "Please enter yes or no or use the shorthands y or n."

	Switch ($readhost) {
		Y {write-host "Now installing Windows Terminal Preview"
		winget install --exact Microsoft.WindowsTerminalPreview | Out-Null
		
		write-host "Installing Ubuntu 20.04 LTS for Windows Subsystem for Linux"
		winget install --exact Canonical.Ubuntu | Out-Null
		
		write-host "Installing Notepad++"
		winget install notepad++ | Out-Null
		
		write-host "Run the included batch file 'notepadreplace.bat' to replace Notepad with Notepad++"
		pause
		
		write-host "Installing Python3"
		winget install --exact Python.Python | Out-Null
		
		write-host "Installing PowerShell 7"
		winget install --exact Microsoft.PowerShell | Out-Null
		
		write-host "Installing Git for Windows"
		winget install --exact Git.Git | Out-Null
		
		general_user}
		
		Yes {write-host "Now installing Windows Terminal Preview"
		winget install --exact Microsoft.WindowsTerminalPreview | Out-Null
		
		write-host "Installing Ubuntu 20.04 LTS for Windows Subsystem for Linux"
		winget install --exact Canonical.Ubuntu | Out-Null
		
		write-host "Installing Notepad++"
		winget install notepad++ | Out-Null
		
		write-host "Run the included batch file 'notepadreplace.bat' to replace Notepad with Notepad++"
		pause
		
		write-host "Installing Python3"
		winget install --exact Python.Python | Out-Null
		
		write-host "Installing PowerShell 7"
		winget install --exact Microsoft.PowerShell | Out-Null
		
		write-host "Installing Git for Windows"
		winget install --exact Git.Git | Out-Null
		
		general_user}
		
		N {write-host "Skipping installation of development tools..."
		
		general_user}
		
		No {write-host "Skipping installation of development tools..."
		
		general_user}
		
	}
}
Function winget_check {
	winget | Out-Null # if the Package Manager is installed the user will never be notified that this command was executed, however, the success or error of the command will be stored in $?. This allows an if statement to be called to verify that the script has all necessary prereqs and is able to run. If the Package Manager is not installed, PowerShell will throw an exception error and the script will fail.
	if ($? -ne "False") { # this is the compatibility check to verify the Windows Package Manager is installed on the user's system. The user will be given a link to the GitHub Releases page for it if they don't have the Package Manager installed so they can rerun the script.
		write-host "The Windows Package Manager 'Winget' is not installed on this system. Verify that you have downloaded it from https://github.com/microsoft/winget-cli/releases and installed it before running this script again. Note that this will not work on systems running LTSB or LTSC."
	}
	else { # if the compatibility check succeeds, the user is given a brief overview how the application works. The user is also informed of normal behabior that might seem odd or suspicious while the script is running. The script will then start running. The script is designed in such a way that all functions are declared backwards so that each function can call the next one at the end of their switch statements. The only function ever called directly during run time is the check function to start the script.
		write-host "Installing programs chosen in the configured .PS1 file. Any application added will be installed if the correct syntax was used and applications commented out in the script will be skipped. During installation UAC prompts may appear if your command line is not elevated and MSI installer packages will show on screen. This is standard behavior."
		
		developer
		
	}
}

# these console lines are copy pasted from the comments at the top of the file so that people who didn't look at the comments must still view them. The pause command is to require manual user intervention to get the script to progress. The two bottom lines are where to request permission to reupload if the user downloaded this script from my GitHub link as well as troubleshooting steps if the script doesn't work.
write-host "This script will set up a new computer on the local network once it has completed OOBE and installed the Windows Package Manager"
pause
write-host "This requires the Windows Package Manager as a prerequisite"
pause
write-host "Programs can be skipped by commenting them out using a hashtag in your text editor of choice"
pause
write-host "This script should not in any way damage your computer, however **if** it does: I am not liable for any and all damages caused by this script and all risks are assumed by the user of the system upon runtime. All rights are reserved and you may not share this script publically without the permission of Joshua Lovejoy. I can be reached at ctrl@customsforge.com."
pause
write-host "If the script is not running properly make sure you are running PowerShell 7 or PowerShell 7 Preview."
winget_check