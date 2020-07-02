Configuration DemoDSC
{
     Import-DscResource –ModuleName PSDscResources
     Import-DscResource -ModuleName ComputerManagementDsc

	Node localhost
	{

          #This is the prefered way to manage PS Exec mode since it does not require PS to enforce.
          Registry 'Registry(POL): HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.Powershell'
          {
               Ensure = 'Present'
               ValueName = 'ExecutionPolicy'
               ValueType = 'String'
               Key = 'HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.Powershell'
               ValueData = 'RemoteSigned'
               Force = $true
          }

          # This is an external module, it breaks if PS is disabled. Chicken & Egg...
          PowerShellExecutionPolicy ExecutionPolicy {        
               ExecutionPolicy = 'RemoteSigned'
               ExecutionPolicyScope = 'LocalMachine'
          }

          Service XblAuthManager
          {
               Name = 'XblAuthManager'
               State = 'Stopped'
               StartupType = 'Disabled'
          }

          Registry 'Registry(POL): HKLM:\Software\Microsoft\wcmsvc\wifinetworkmanager\config\AutoConnectAllowedOEM'
          {
               Ensure = 'Present'
               ValueName = 'AutoConnectAllowedOEM'
               ValueType = 'Dword'
               Key = 'HKLM:\Software\Microsoft\wcmsvc\wifinetworkmanager\config'
               ValueData = 0
               Force = $true
          }

          Script DisableNetbios
          {
               SetScript = {
                    $NetbiosRegistryKey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
                    Get-ChildItem $NetbiosRegistryKey | Get-ItemProperty | Where-Object { $_.NetbiosOptions -ne 2 } | Set-ItemProperty -Name "NetbiosOptions" -Value 2
               }
               TestScript = {
                    # Get interfaces out of spec and return them. An empty set will pass.
                    $NetbiosRegistryKey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
                    (Get-ChildItem $NetbiosRegistryKey | Get-ItemProperty | Where-Object { $_.NetbiosOptions -ne 2 } | Measure-Object).count -eq 0
               }
               GetScript = {
                    $NetbiosRegistryKey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
                    @{ Result = (Get-ChildItem $NetbiosRegistryKey | Get-ItemProperty | Where-Object { $_.NetbiosOptions -ne 2 })}
               }
          }
     }
}
DemoDSC -OutputPath 'C:\Output'
