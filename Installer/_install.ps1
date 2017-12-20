# Test installation script
# Will go thnough the needed setup for oblivion mods and other things.

# Changelog
# 0.1 12/19/17
# - Support for unzipping oblivion online.
# - Implement a variable to name the segment of script we're at so that Function Unzip can tell us where something failed.

# 0.2 12/19/17
# - Change for cleanup to Source and Extract Folders
# - Implement support for unzipping several other sources.

# To-Do
# Implement elevation checks if needed
# Fix folders getting nammed .zip. Not really an issue, but will get confusing later.


##### Begin Script! #####

#Define Global Variables
$ScriptLocation = (Get-Item -Path ".\" -Verbose).FullName
$SourceLocation = (Get-Item -Path ".\Source\" -Verbose).FullName
$ExtractLocation = (Get-Item -Path ".\Extract\" -Verbose).FullName

#Set .net to the current working script directory
[Environment]::CurrentDirectory = $ScriptLocation

Function Unzip
{
# Add the .net assembly to manipulate zip files.
Add-Type -assembly "system.io.compression.filesystem"
# Check if the target unzip folder is present, and create it if not.
New-Item -ItemType Directory -Force -Path $UnzipLocation | out-null
# Fail if the script cannot find the file to unzip.
if ($ZipFile -eq $false){
	Write-Host "The script cannot find a needed file." -ForegroundColor Red
	Write-Host "This is most likey a script error. Please report the following info:"`n -ForegroundColor Red
	Write-Host "$UnzipStep" `n -ForegroundColor Yellow
	break;
	}
# Fail if the script did not populate the needed variables.
if ($ZipFile -eq $false -OR $UnzipLocation -eq $false){
	Write-Host "There was a scripting error, and a file we need to unzip was NOT specified." -ForegroundColor Red
	Write-Host "This is most likey a script error. Please report the following info:"`n -ForegroundColor Red
	Write-Host "$UnzipStep"`n -ForegroundColor Yellow
	break;
	}
else {
	try 
	{
	# Run the uncompress command, surpress errors.
	[io.compression.zipfile]::ExtractToDirectory($ZipFile, $UnzipLocation) | out-null
	# Set UnzipStep to $LastSuccessfulUnzipStep
	$LastSuccessfulUnzipStep = $UnzipStep
	}
	catch
		{
		#There was an error extracting.
		Write-Host "An error occured. Please report the following information:" -ForegroundColor Red
		Write-Host "$LastSuccessfulUnzipStep" -ForegroundColor Yellow
		break;
		}
	}

}

# For each for every zip in the Source Location, set variables and run the unzip function.
Get-ChildItem $SourceLocation -Filter *.zip | Foreach-Object {
	$UnzipStep = $_
	$ZipFile = "$SourceLocation$_"
	$UnzipLocation = "$ExtractLocation$_"
	Unzip
	}
	
