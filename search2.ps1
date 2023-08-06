$SaveSearchHistory=$true #$true or $false
$file="SearchHistory.txt" #file name
$debug=$false

[console]::WindowWidth=100; 
[console]::WindowHeight=40;
[console]::BufferWidth=[console]::WindowWidth

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';
$option = 'b'

function chceckLastSearch()
{
    param ($option)
    if($option -eq "init")
    {
        $returnArray = @()
        if([System.IO.File]::Exists($file))
        {
            $returnArray += (Get-Content -Path $file -Tail 1).substring(17) 
            $returnArray += (Get-Content -Path $file -Tail 2 | Select -First 1).substring(17) 
            return ,$returnArray
        }
        else
        {
            $loginAD = [Environment]::UserName
            $returnArray += $loginAD
            $returnArray += "empty search"
            return ,$returnArray
        }
    }
    else
    {
        if([System.IO.File]::Exists($file))
        {
            $lastSearch = (Get-Content -Path $file -Tail 2 | Select -First 1).substring(17) 
            return $lastSearch
        }
        else
        {
            $lastSearch="empty search"
            return $lastSearch
        }
    }
}
