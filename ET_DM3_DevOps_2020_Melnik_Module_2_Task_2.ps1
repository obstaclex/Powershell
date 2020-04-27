# 1.	Просмотреть содержимое ветви реeстра HKCU.

Get-ChildItem HKCU:

# 2.	Создать, переименовать, удалить каталог на локальном диске.

New-Item -ItemType Directory -path "d:\testcatalog"
Rename-Item D:\testcatalog -NewName test1catalog
Remove-Item D:\test1catalog

<# 3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой.
C:\M2T2_ФАМИЛИЯ.#>

New-Item -ItemType Directory -Path "c:\M2T2_Melnik"
New-PSDrive -Name M2T2_Melnik -PSProvider FileSystem -Root 'C:\M2T2_Melnik'

<# 4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб.
Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.#>

Get-Service | Where-Object {$_.Status -eq "Running"} > M2T2_Melnik:\services.txt
Get-ChildItem
Get-Content .\services.txt

# 5.	Просуммировать все числовые значения переменных текущего сеанса.

((Get-ChildItem env:*).value.foreach{[int]$_} | Measure-Object -sum).sum

# 6.	Вывести список из 6 процессов занимающих дольше всего процессор.

Get-Process | Sort-Object CPU -Descending | Select-Object -First 6

<# 7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса,
разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.#>

Get-Process |Select-Object Name, @{Name="PM"; expression={($_.pm/1024kb)}} | ForEach-Object { if($_.PM -gt 100){ Write-Host -f red $_.Name $_.PM -Separator " - "} else {Write-Host -f green $_.Name $_.pm -Separator " - "}}

# 8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp

(Get-ChildItem 'C:\Windows\' -Recurse -Exclude "*.tmp" -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).sum

# 9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.

Get-ChildItem HKLM:\SOFTWARE\Microsoft | Export-Csv -Path D:\test1.csv

# 10.	Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.

Get-History | Export-Clixml -Path D:\testxml.XML

<# 11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 
5 любых (выбранных Вами) свойств.#>

$a = Import-Clixml D:\testxml.XML
$a
$a.id 
$a.commandline
$a.executionstatus
$a.startexecutiontime
$a.endexecutiontime

# 12.	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ

Remove-PSDrive M2T2_Melnik

<# 13. You are given a list of countries, each on a new line. Your task is to read them into an array
 and then filter out (remove) all the names containing the letter 'a' or 'A'. #>

$country = @()
[int]$n=Read-Host "Введите количество стран"
for ($j = 0; $j -lt $n; $j++){
    $country += Read-Host "Введите название страны"
}
for ($j = 0; $j -lt $n; $j++){
    if ($country[$j] -notmatch  "a") {Write-Host $country[$j]}
}
    
<# 14. You are given a list of countries, each on a new line. Your task is to read them into an array and then transform
 them in the following way: The first capital letter (if present) in each element of the array should be replaced with a dot ('.'). 
 Then, display the entire array with a space between each country's names. #>

 $country = @()
 [int]$n=Read-Host "Enter number of country"
 for ($j = 0; $j -lt $n; $j++){
     $country += Read-Host "Enter counry"
 }
 $newstr = @()
 for ($j = 0; $j -lt $n; $j++){
     $newstr+=" ." + $country[$j].remove(0,1)
 }
 $final= -join $newstr
 $final