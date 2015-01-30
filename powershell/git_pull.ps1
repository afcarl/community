
# "Git Pull" - Windows Desktop Shortcut:
#   Target: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File "C:\si\svp\git_pull.ps1"
#   powershell.exe, start in: C:\Windows\System32\WindowsPowerShell\v1.0
#   Chris Joakim, 2015/01/30

echo "Git Pull ..."

cd  C:\si\svp
git reset --hard
git pull 

Write-Host "Press any key to exit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

echo "done"
