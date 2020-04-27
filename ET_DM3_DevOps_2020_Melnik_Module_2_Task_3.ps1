<# 1.	Создайте сценарии *.ps1 дл я задач из labwork 2, проверьте их работоспостобность. Каждый сценарий должен иметь параметры.
1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска.
Вывести содержимое файла в консоль PS. #>

[CmdletBinding()]
param (
    [string]$File="d:\service.txt"
)
Get-Service | Where-Object {$_.Status -eq "Running"} > $File
Get-ChildItem
Get-Content $File

# 1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)

[CmdletBinding()]
param ()
(Get-Variable | Where-Object {$_.Value -is [double] -or $_.Value -is [int]} | Measure-Object Value -sum).sum 

# 1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.

[CmdletBinding()]
param (
    [string]$File="d:\CPUusage.txt"
)
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Out-File $File
Get-Content $File

# 1.3.1 Организовать запуск скрипта каждые 10 минут

$interval=(New-TimeSpan -Minutes 10)
$duration=(New-TimeSpan -Days 1)
$t=New-JobTrigger -Once -At (Get-Date).Date -RepetitionInterval $interval -RepetitionDuration $duration
$cred=Get-Credential obstaclex540@gmail.com
$o=New-ScheduledJobOption -RunElevated
Register-ScheduledJob -Name Scriptcpu -FilePath D:\studiocode\cpuusage.ps1 -Trigger $t -Credential $cred -ScheduledJobOption $o

# 1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="Enter folder path",Position=1)]
    [string]$folder,
    [Parameter(Mandatory=$true, HelpMessage="Exlude file",Position=2)]
    [string]$exclude
)
(Get-ChildItem $folder -Recurse -Exclude $exclude -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).sum

# 1.5.	Создать один скрипт, объединив 3 задачи:
# 1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
# 1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
# 1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами

[CmdletBinding()]
param (
    [Parameter()]
    [string]$securitycsv="d:\security.csv",
    [string]$hklmxml="D:\HKLM.xml",
    [string]$sectxt="D:\security.txt",
    [string]$hklmtxt="D:\hklm.txt",
    $colors = [enum]::GetValues([System.ConsoleColor])
)
Get-HotFix -Description "secur*" | Export-Csv -Path $securitycsv
Get-ChildItem HKLM:\SOFTWARE\Microsoft -ErrorAction SilentlyContinue | Export-Clixml -Path $hklmxml
Import-Csv $securitycsv | Format-List | Out-File $sectxt
Get-Content $sectxt | ForEach-Object {
    Write-Host $_ -ForegroundColor (Get-Random -InputObject $colors) }
Import-Clixml $hklmxml | Format-List | Out-File $hklmtxt
Get-Content $hklmtxt | ForEach-Object {
    Write-Host $_ -ForegroundColor (Get-Random -InputObject $colors) }

# 2.	Работа с профилем
# 2.1.	Создать профиль

New-Item -ItemType File -Path $profile

# 2.2.	В профиле изненить цвета в консоли PowerShell

(Get-Host).UI.RawUI.ForegroundColor = "white"
(Get-Host).UI.RawUI.BackgroundColor = "black"

# 2.3.	Создать несколько собственный алиасов

Set-Alias hist Get-History
Set-Alias wr Write-Host
Set-Alias dlt Remove-Item

# 2.4.	Создать несколько констант

Set-Variable -Name "user" -Value "ilya_melnik" -Option Constant
Set-Variable -Name test -Value 100 -Option Constant

# 2.5.	Изменить текущую папку

Set-Location D:\

# 2.6.	Вывести приветсвие
# 2.7.	Проверить применение профиля
Write-Host "Hello, Ilya"

# 3.	Получить список всех доступных модулей

Get-Module -ListAvailable