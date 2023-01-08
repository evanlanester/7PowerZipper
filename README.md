# 7PowerZipper

I created this script as I use it in my HomeLab's Automated Backups that many not be exactly best practice.

Powershell Script to Automate 7Zip LZMA Zipping of Files
-----

### Please be aware this Script has automated downloading/updating of the 7Zip Binaries required.
The lines with automated downloading are clearly laid out and can be removed if that isn't your kind of (raspberry) jam.

Here is an example usage:

```powershell
Powershell +3.0
PS C:\ 7PowerZipper -Path C:\<Some File or Directory> -DestinationPath C:\<Some File.zip>
```

Defaults I use:
```Powershell
$today = Get-Date -Format "yyyy-MM-dd"                  # Format your backups with a nice sortable date.
$7zipLocation = "C:\Scripts\7PowerZipper"               # This is the location for your 7zip Files.
$FileToBeZipped = "C:\Data\"                            # This can be a Directory or a Single File
$ZipDestination = "D:\Backups\FullBackup.$($today).zip" # This is the Output File I date my Backups.
```

# Credits:
* Myself (@EvanLanester)
* Igor Pavlov - https://www.7-zip.org/ - Licensed under GNU3.0
