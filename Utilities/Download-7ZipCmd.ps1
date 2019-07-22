#v1.0###########################################
### Get-7ZipBinaries (7Zip by Igor Paslow Licensed under GNU)
### Date: 2019-07-22
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
   [string] $7zipLocation,
)

$Scrape = Invoke-WebRequest -Uri https://www.7-zip.org/download.html | Select-Object -ExpandProperty Links 
$Versions = $Scrape | Where-Object {$_.innerHTML -eq "Download"}
$LatestVersion = $Versions.href[0].Substring(4,4)

Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z$LatestVersion-extra.7z" -UseBasicParsing -OutFile "$Env:Temp\7z$LatestVersion-extra.7z"
Expand-Archive -Path "$Env:Temp\7z$LatestVersion-extra.7z"-DestinationPath "$7zipLocation\"
