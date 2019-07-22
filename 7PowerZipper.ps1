#v2.4a###########################################
### 7PowerZipper (7Zip by Igor Pavlov Licensed under GNU)
### Date: 2019-07-14
### Author: Evan Lane
### Last Updated: 2019-07-22
################################################
### Website: Visit Gitlab.Hardlynerding.com  ###
################################################
### !THIS SCRIPT HAS AUTOMATED DOWNLOADING!  ###
################################################
#Requires -Version 3.0

Param (
   [Parameter(Mandatory = $true)]
   [string] $7zipLocation = $(throw "Location of 7zip Binaries. If you don't have them installed - provide a path you'd like them installed."),
   [Parameter(Mandatory = $true)]
   [string] $FileToBeZipped = $(throw "Location you'd like zipped. Single File or a Directory are both acceptable."),
   [Parameter(Mandatory = $true)]
   [string] $ZipDestination = "C:\Backups\FullBackup.$($today).zip"
)

$today = Get-Date -Format "yyyy-MM-dd"
$Zipper = "$7zipLocation\7za.exe"

$Scrape = Invoke-WebRequest -Uri https://www.7-zip.org/download.html | Select-Object -ExpandProperty Links 
$Versions = $Scrape | Where-Object {$_.innerHTML -eq "Download"}
$LatestVersion = $Versions.href[0].Substring(4,4)

$ZipInfo = (& $zipper)[1]
$ZipVersion = $ZipInfo.Substring(10,5) -replace '[.]',''

###        ! AUTOMATED DOWNLOADING !       ###
### Downloads 7Zip Binaries if not present ###
if (!(Test-Path "$7ZipLocation\7*")) {
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z$LatestVersion-extra.7z" -UseBasicParsing -OutFile "$Env:Temp\7z$LatestVersion-extra.7z"
    Expand-Archive -Path "$Env:Temp\7z$LatestVersion-extra.7z"-DestinationPath "$7zipLocation\"
} 
###     ! AUTOMATED DOWNLOADING !     ###
### Checks your 7Zip Binaries Version ###
if ($ZipVersion -eq $LatestVersion){
    Write-Verbose "Running Current Version"
} Else {
    Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z$LatestVersion-extra.7z" -UseBasicParsing -OutFile "$Env:Temp\7z$LatestVersion-extra.7z"
    & $Zipper x -aoa "$Env:Temp\7z$LatestVersion-extra.7z" "$7zipLocation\"
}

Write-Verbose "Zipper Zips!"
& $Zipper a -m0=LZMA -mmt -aoa $ZipDestination $FileToBeZipped
