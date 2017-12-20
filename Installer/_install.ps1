# Test installation script
# Will go thnough the needed setup for oblivion mods and other things.

# Changelog
# 0.1 12/19/17
# - Support for unzipping oblivion online.

# To-Do
# Implement elevation checks if needed


##### Begin Script! #####

#Define Global Variables
$ScriptLocation = (Get-Item -Path ".\" -Verbose).FullName
Write-Host "DEBUG: Path is $ScriptLocation"`n -ForegroundColor Cyan

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
	Write-Host "The script cannot find a needed file. :(" -ForegroundColor Red
	break;
	}
# Fail if the script did not populate the needed variables.
if ($ZipFile -eq $false -OR $UnzipLocation -eq $false){
	Write-Host "There was a scripting error, and a file we need to unzip was NOT specified." -ForegroundColor Red
	break;
	}
else {
# Run the uncompress command, surpress errors.
	[io.compression.zipfile]::ExtractToDirectory($ZipFile, $UnzipLocation) | out-null
	}
}

# Extract Oblivion Online
$ZipFile = "$ScriptLocation\OblivionOnline1.8.zip"
$UnzipLocation = '.\OblivionOnline'
Unzip

#Execute OblivionOnline
Write-Host `n"Executing Oblivion Online Now. Follow the onscreen prompts. This may take a moment to run." -ForegroundColor Yellow
& .\OblivionOnline\OblivionOnline.exe
Write-Host "Press a key to continue..." -ForegroundColor Yellow
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")