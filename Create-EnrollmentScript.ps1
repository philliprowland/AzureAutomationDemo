Import-Module Az
Connect-AzAccount

# Change these variables for your environment
$ResourceGroup = "NetworkWatcherRG"
$AutomationAccount = "DSC-Demo"
$OutputFolderString = "$env:UserProfile\Desktop\"

$Params = @{
    ResourceGroupName = $ResourceGroup;
    AutomationAccountName = $AutomationAccount;
    ComputerName = @('localhost');
    OutputFolder = $OutputFolderString;
}
Get-AzAutomationDscOnboardingMetaconfig @Params

$ByteArray = [System.IO.File]::ReadAllBytes("$OutputFolderString\DscMetaConfigs\localhost.meta.mof")
[System.Convert]::ToBase64String($ByteArray) | Out-File "$OutputFolderString\localhost.meta.mof.base64"
