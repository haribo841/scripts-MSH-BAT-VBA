$folderPath = "C:\path\to\folder"  # Replace with the path to your folder

# Get all files in the folder
$files = Get-ChildItem -File -Path $folderPath

# Iterate through each file
foreach ($file in $files) 
{
    $newFileName = '0{0}{1}' -f $file.BaseName, $file.Extension
    $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName

    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilePath
}