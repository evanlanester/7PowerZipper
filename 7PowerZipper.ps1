function 7PowerZipper {
    <#
    .SYNOPSIS
        Creates a file LZMA zipped file from a file or directory using 7-Zip by Igor Pavlov Licensed under GNU's binaries.
    
    .DESCRIPTION
        7PowerZipper (7-Zip by Igor Pavlov Licensed under GNU) is a function that outputs a zip file from an input Path of either a single file or Directory.
        The default Zip file is formatted with LZMA compression.

    .PARAMETER 7zipLocation
        The 7zipLocation parameter expects a folder with the 7Zip binaries. Defaults to .\bin but will check your system for a 7-Zip installation too.
    
    .PARAMETER Path
        The Path specifies the file or directory to zip. Mandatory.
    
    .PARAMETER DestinationPath
        The DestinationPath specifies the output location of the Zipped file(s). Mandatory.
    
    .EXAMPLE
        7PowerZipper -Path C:\<Some File or Directory> -DestinationPath C:\<Some File.zip>
    
    .EXAMPLE
        7PowerZipper -7ZipLocation E:\7-Zip\7za.exe -Path C:\UserName\Pictures\ -DestinationPath D:\PicturesBackup.zip
    
    .INPUTS
        String
    
    .OUTPUTS
        File
    
    .NOTES
        Author:  Evan Lane
        Website: https://evanlane.me
        GitHub: https://github.com/evanlanester
    #>
Param (
    [Parameter(
    Mandatory = $false,
    HelpMessage = "Location of 7zip Binaries. Defaults to: .\bin or "
    )]
    [string]${7zipLocation[.\bin]},
    [Parameter(
    Mandatory = $true,
    HelpMessage = "Location you'd like zipped. Single File or a Directory are both acceptable."
    )]
    [string]$Path,
    [Parameter(
    Mandatory = $true,
    HelpMessage = 'C:\Backups\FullBackup.$($today).zip'
    )]
    [string]$DestinationPath
)

# Checking for existing binaries to use.
if (Test-Path "$7ZipLocation\7za.exe") {
    $Zipper = "$7zipLocation\7za.exe"
} elseif (Test-Path "$ENV:ProgramFiles\7-Zip\") {
    $Zipper = "$ENV:ProgramFiles\7-Zip\7z.exe"
} else {
    Write-Error "Missing 7-zip Binaries! Please either install 7-Zip or acquire the 7-Zip binaries."
    Write-Warning "Visit: https://www.7-zip.org/"
    pause
    return
}

$Scrape = Invoke-WebRequest -Uri https://www.7-zip.org/download.html | Select-Object -ExpandProperty Links 
$Versions = $Scrape | Where-Object {$_.outerHTML -like "*Download*"}
$LatestVersion = $Versions.href[0].Substring(4,4)

$ZipInfo = (& $zipper)[1]
$ZipVersion = $ZipInfo.Substring(10,5) -replace '[.]',''

###     ! AUTOMATED DOWNLOADING !     ###
### Checks your 7Zip Binaries Version ###
If (($ZipVersion -eq $LatestVersion) -and ($Zipper -eq "$7zipLocation\7za.exe")){
    Write-Verbose "Running Current Version. Continuing..."
} Elseif (($ZipVersion -ne $LatestVersion) -and ($Zipper -eq "$7zipLocation\7za.exe")) {
    Write-Host "Would you like to update your 7-Zip Binaries? They are out of date."
    $title    = 'Would you like to update your 7-Zip Binaries? They are out of date.'
    $question = 'Do you want to update?'
    $choices  = '&Yes', '&No'
    $Update = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    switch ($Update) {
        0 { 
            Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z$LatestVersion-extra.7z" -UseBasicParsing -OutFile "$Env:Temp\7z$LatestVersion-extra.7z"
            & $Zipper x -aoa "$Env:Temp\7z$LatestVersion-extra.7z" "$7zipLocation\"
        }
        1 { 
            Write-Warning "Continuing with current version."
        }
    }
} Elseif (($ZipVersion -ne $LatestVersion) -and ($Zipper -eq "$7zipLocation\7z.exe")) {
    Write-Warning "Your 7-Zip Software is out of date. Please consider updating."
    Write-Warning "Current: $ZipVersion | Latest: $LatestVersion [y/n]"
    Write-Warning "Continuing with current version..."
}

Write-Verbose "PowerZipping!"
& $Zipper a -m0=LZMA -mmt -aoa $DestinationPath $Path
}