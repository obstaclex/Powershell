# 1.	Вывести список всех классов WMI на локальном компьютере.

Get-WmiObject -List

# 2.	Получить список всех пространств имён классов WMI. 

Get-WmiObject -Namespace root -class "__namespace" | Format-Table name

# 3.	Получить список классов работы с принтером.

Get-WmiObject -List | where {$_.name -match "printer"}

# 4.	Вывести информацию об операционной системе, не менее 10 полей.

$a=Get-WmiObject -Class Win32_operatingsystem
$a | Get-Member
$a | Format-List Buildtype, version, buildnumber, bootdevice, currenttimezone, name, status, serialnumber,`
 windowsdirectory, installdate, freephysicalmemory

# 5.	Получить информацию о BIOS.

Get-WmiObject win32_Bios

# 6.	Вывести свободное место на локальных дисках. На каждом и сумму.

$b=Get-WmiObject win32_logicaldisk
$b | Select-Object -Property name, @{Label='freespace(gb)'; expression={$_.freespace/1gb}}
($b | Select-Object -Property name, freespace | foreach {$_.freespace/1gb} | Measure-Object  -Sum).Sum

# 7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,HelpMessage="Enter adress")]
    [string]
    $adr
)
Get-WmiObject win32_Pingstatus -Filter "Address='$adr'" | Select-Object -Property ResponseTime

#8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.

[CmdletBinding()]
param ()
Get-WmiObject win32_product | Select-Object -Property Name, Version

#9.	Выводить сообщение при каждом запуске приложения MS Word.
 
Register-WmiEvent -Query "select * from __instancecreationevent within`
 5 where targetinstance isa 'win32_process'" -Action { Write-Host "you open word?"}