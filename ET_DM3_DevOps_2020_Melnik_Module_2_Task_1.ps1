# 1.	Получите справку о командлете справки
Get-Help Help
# 2.	Пункт 1, но детальную справку, затем только примеры
Get-Help Help -Detailed
Get-Help Help -Examples
# 3.	Получите справку о новых возможностях в PowerShell 4.0 (или выше)
Get-Help about_powershell.exe
# 4.	Получите все командлеты установки значений
Get-Command -Name set* -CommandType Cmdlet
# 5.	Получить список команд работы с файлами
Get-Command -name *item*
# 6.	Получить список команд работы с объектами
Get-Command -name *object*
# 7.	Получите список всех псевдонимов
Get-Alias
# 8.	Создайте свой псевдоним для любого командлета
Set-Alias hist Get-History
# 9.	Просмотреть список методов и свойств объекта типа процесс
Get-Process | Get-Member
# 10.	Просмотреть список методов и свойств объекта типа строка
Out-String | Get-Member
# 11.	Получить список запущенных процессов, данные об определённом процессе
Get-Process
Get-Process -name MicrosoftEdge
# 12.	Получить список всех сервисов, данные об определённом сервисе
Get-Service
Get-service -name dnscache
# 13.	Получить список обновлений системы
Get-Hotfix
# 14.	Узнайте, какой язык установлен для UI Windows
Get-UICulture
# 15.	Получите текущее время и дату
Get-Date
# 16.	Сгенерируйте случайное число (любым способом)
Get-Random -max 100
# 17.	Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели.
(Get-Process -Name explorer).starttime
(Get-Process -Name explorer).starttime.dayofweek
# 18.	Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell
$Word = New-Object -ComObject Word.Application
$Word.Visible = $true
$Word.Quit()
# 19.	Подсчитать значение выражения S=∑_("i=" 1)^n 3*i. N – изменяемый параметр. Каждый шаг выводить в виде строки. (Пример: На шаге 2 сумма S равна 9)
Write-Host "Please, enter N"
$n=Read-Host
while ($i -le $n) {
    $i++
    $sum+=3 * $i
    Write-Host "On step $i S is equal to $sum"
}
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
# 20.	Напишите функцию для предыдущего задания. Запустите её на выполнение.
function summar(){
Write-Host "Please, enter N"
$n=Read-Host
while ($i -le $n) {
    $i++
    $sum+=3 * $i
    Write-Host "On step $i S is equal to $sum"
}
Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
}
summar
