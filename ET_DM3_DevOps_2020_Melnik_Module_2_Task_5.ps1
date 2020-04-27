# В задании используются виртуальные машины созданные в предыдущих модулях.
# 1.	При помощи WMI перезагрузить все виртуальные машины.

$vm=@("192.168.10.1", "10.0.0.10")
$cred=Get-Credential Administrator
Get-WmiObject win32_operatingsystem -ComputerName $vm -Credential $cred | Invoke-WmiMethod -Name reboot

# 2.	При помощи WMI просмотреть список запущенных служб на удаленном компьютере.
$cred=Get-Credential Administrator
$vm1="192.168.10.1"
Get-WmiObject win32_service -ComputerName $vm1 -Credential $cred | where {$_.state -match "running"} | select name, state

# 3.	Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.

Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
Get-Item WSMan:\localhost\Client\TrustedHosts

# 4.	Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.

Set-Item WSMan:\localhost\Listener\Listener*\Port -Value 42658 #ЭТУ КОММАНДУ НЕОБХОДИМО ПРИМЕНИТЬ НА ВИРТУАЛЬНОЙ МАШИНЕ
$cred=Get-Credential Administrator
Enter-PSSession -ComputerName "192.168.10.1" -Credential $cred -Port 42658
Get-Service
Exit-PSSession

# 5.	Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.

New-PSSessionConfigurationFile -Path c:\session.pssc -VisibleCmdlets Set-Location, Get-ChildItem, Exit-PSSession, Out-Default -VisibleProviders "FileSystem"
Register-PSSessionConfiguration -Name session2 -Path c:\session.pssc -RunAsCredential $cred # Эти команды нужно прописать на вируталке и создать там сессию.
$cred=Get-Credential Administrator
Enter-PSSession -ComputerName "192.168.10.1" -Credential $cred -Port 42658 -ConfigurationName session2 # заходим на виртуалку используя имя сессии