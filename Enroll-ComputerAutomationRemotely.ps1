$Base64 = 'Paste Base64 Here'
$OutputPath = "$env:Temp\DscMetaConfigs"

New-Item -Path $OutputPath -ItemType Directory

$ByteArray = [System.Convert]::FromBase64String($Base64)
Set-Content -Path "$OutputPath\localhost.meta.mof" -Value $ByteArray -Encoding Byte

Start-Service WinRM
Set-DscLocalConfigurationManager -Path $OutputPath
Stop-Service WinRM