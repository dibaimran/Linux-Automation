$Hosts = @(
    "rkc107-01","rkc107-02","rkc107-03","rkc107-04","rkc107-05",
    "rkc107-06","rkc107-07","rkc107-08","rkc107-09","rkc107-10",
    "rkc107-11","rkc107-12","rkc107-13","rkc107-14","rkc107-15",
    "rkc107-16","rkc107-17","rkc107-18"
)

$User = "sysadmin"
$Credential = Get-Credential -UserName $User -Message "Enter SSH password"
$pw = $Credential.GetNetworkCredential().Password

<#Write-Host "Caching host keys..." -ForegroundColor Yellow
foreach ($h in $Hosts) {
    Write-Host "Trusting $h..." -ForegroundColor Cyan
    echo "y" | & "C:\Program Files\PuTTY\plink.exe" -ssh "$User@$h" -pw $pw "exit"
}#>


Write-Host "`nRunning commands on all machines..." -ForegroundColor Yellow

$comm = read-host "Enter a command"
$Cmd = "printf '$pw\n' | sudo -S -p '' $comm; exit"


$results = $Hosts | ForEach-Object -Parallel {
    $h = $_
    $result = & "C:\Program Files\PuTTY\plink.exe" -t -ssh "$using:User@$h" -pw $using:pw -batch $using:Cmd
    [PSCustomObject]@{Host=$h; Output=$result}
} -ThrottleLimit 18

$results | ForEach-Object {
    Write-Host "`n=== $($_.Host) ===" -ForegroundColor Cyan
    $_.Output
}

Write-Host "`nDone!" -ForegroundColor Yellow