get-command -Name *archive*
get-help Expand-Archive
$path= "E:\exittask"
Expand-Archive -Path E:\ArchiveTast6.zip -DestinationPath $path 
ls -Path $path -Recurse -Filter *.txt | foreach { Rename-Item -Path $_.FullName -NewName `
    "$($_.DirectoryName.ToString())$($_.LastWriteTime.ToString('ddmmyyyy - hhmmss'))_$($_.basename)$($_.extension)"}

    ls -Path $path -Recurse -Filter *.txt | gm

    Get-Content 'E:\exittask\Folder01\File01.txt' | gm

    (ls 'E:\exittask\Folder01\12462019 - 124638_File01.txt').DirectoryName.ToString() | gm
