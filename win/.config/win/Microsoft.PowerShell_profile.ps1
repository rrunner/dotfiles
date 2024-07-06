# $profile in powershell returns the path to the profile, for example C:\Users\...\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# Install starship: scoop install starship
# Install psreadline: scoop install psreadline
Invoke-Expression (&starship init powershell)
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key "Ctrl+i" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+m" -Function AcceptLine
