Param($t = 600)
try
{
	$wshell = New-Object -ComObject wscript.shell
}
catch
{
	Write-Output "An error occurred while creating a new SO shell instance"
    Write-Output $_
}
Write-Output "active!"
For ($i = 0; $i -lt $t; $i++)
{
	$wshell.SendKeys('{F15}')
	#Write-Output "active!"
	Start-Sleep -Seconds 600
}
