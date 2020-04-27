 # Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:
# 1.1.  Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)

Get-WmiObject -Class win32_NetworkAdapterConfiguration -Filter IPEnabled=True | select  ipaddress, description

# 1.2.    Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,HelpMessage="enter host address", Position=1 )]
[string]$comp,
    [Parameter(Mandatory=$true,HelpMessage="enter user", Position=2 )]  
$cred
)
Get-WmiObject -Class win32_NetworkAdapterConfiguration -ComputerName $comp -Credential $cred | where {$_.macaddress -match ":"} |select macaddress, description 

#  1.3.	На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.

$comp
Get-WmiObject win32_NetworkAdapterConfiguration -ComputerName $comp -Credential Administrator | Invoke-WmiMethod -Name EnableDHCP

# 1.4.	Расшарить папку на компьютере
 
([wmiclass]'win32_share').Create("C:\M2T2_Melnik", "testshare",0, 100, "ilyashare")

# 1.5.	Удалить шару из п.1.4

$folder=Get-WMIObject Win32_Share | Where {$_.Name -eq "testshare"} 
$folder
Foreach ($i in $folder) {
   $folder.Delete()
}

<# 1.6.	Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в 
одной ли подсети эти адреса. #>

[CmdletBinding()]
param (
    <# PowerShell предусматривает простой способ работы с IP-адресами: мы можем использовать акселератор типов [IPAddress].
Можно указывать в скобках полное имя класса, [System.Net.IPAddress], или [IPAddress].Применяя акселератор типов, мы получаем 
возможность указывать IPv4-адрес в формате четырехбайтного адреса. #>
    [Parameter(Mandatory=$true)]
    [ipaddress]$ipaddress1,
    [Parameter(Mandatory=$true)]
    [ipaddress]$ipaddress2,
    [Parameter(Mandatory=$true)]
    [ipaddress]$netmask
)
    if (($ipaddress1.address -band $netmask.address) -eq ($ipaddress2.address -band $netmask.address)) { <# Метод .address представляеm
        ipv4 адресс в качестве d*2^24+c*2^16+b*2^8+a, a.b.c.d - октеты ip адреса, band - логический оператор сравнения biwwise and #>
        Write-Host "this hosts in same subnet"
    }
    else {
        Write-Host "this hosts in different subnets"
    }

# 2.	Работа с Hyper-V
# 2.1.	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)

Get-Command -CommandType cmdlet | where {$_.source -eq "Hyper-V"} | Select CommandType, Name, Source

# 2.2.	Получить список виртуальных машин 

Get-VM 

# 2.3.	Получить состояние имеющихся виртуальных машин

Get-VM | select Name, State

# 2.4.	Выключить виртуальную машину

Stop-VM vm1_melnik

# 2.5.	Создать новую виртуальную машину

New-VM -Name vm4_melnik -MemoryStartupBytes 2gb -Generation 1

# 2.6.	Создать динамический жесткий диск

New-VHD  D:\vm\vm4_melnik\virtualharddisk.vhdx -Dynamic -SizeBytes 50gb 
Add-VMHardDiskDrive -VMName vm4_melnik -Path D:\vm\vm4_melnik\virtualharddisk.vhdx

# 2.7.	Удалить созданную виртуальную машину

Remove-VM vm4_melnik