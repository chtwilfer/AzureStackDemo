Set-Location "$env:USERPROFILE\Documents\GitHub\AzureStackDemo"
#Add-AzureRmAccount -Environment $env -Verbose
# Get Azure Stack Environment subscription
Get-AzureRmSubscription -SubscriptionName "Mark POC"  | Select-AzureRmSubscription
Get-AzureRmSubscription
Get-AzureRmResourceGroup

$rg = New-AzureRmResourceGroup -Name MAS-Demo -Location "local" -Force
$Deploysettings = @{
    Name = 'MASVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/AzureStackDemo/master/azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings

Get-AzureRmResourceGroup