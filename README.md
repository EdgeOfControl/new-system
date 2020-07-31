# new-system
A PowerShell based setup wizard for setting up a new Windows installation. Requires the Windows Package Manager.

How it works:
	- Application Installations
		
		- Hit enter to go through the opening messages. Stop and take the time to read them, they contain import information about the script's execution.
		
		- Type any of the following identifiers when presented with a question during the application installation process.
			- yes
			- no
			- y
			- n
		
		- Any applications listed in the script functions will then install through Windows Package Manager
	
	- Network Drive Mapping
		
		- Once yes or y is entered for mapping a network drive, the following will occur
			
			- You will be asked to enter your network share as a UNC path "\\server\share"
			
			- You will then be asked if you have to connect with different credentials
				 
				 - If you enter yes, you will be asked to provide credentials to PowerShell to connect with.
          			 
				 - If you enter no, your drive will be mounted.
         
	 - ***THIS FEATURE REQUIRES POWERSHELL TO BE RUNNING IN USER-SPACE AND NOT AS ADMIN FOR IT TO WORK CORRECTLY***
				
If there are any applications you would like to add that are not listed in the PS1 file, add them in the user_applications function. By default this function will load the next function in the script.

There is an accompanying bat file related to Notepad++. It is only applicable if Notepad++ is installed. The file name in the repository is notepadreplace.exe


Copyright Joshua Lovejoy, 2020.
All inquiries about this repository are to be sent to ctrl@customsforge.com
