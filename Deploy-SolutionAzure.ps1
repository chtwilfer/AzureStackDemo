Set-Location "$env:USERPROFILE\Documents\GitHub\AzureStackDemo"
Add-AzureRmAccount -Verbose
# Get Azure subscription
Get-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise with MSDN"  | Select-AzureRmSubscription

$rg = New-AzureRmResourceGroup -Name MAS-Demo -Location "westeurope"
$Deploysettings = @{
    Name = 'MASVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/AzureStackDemo/master/azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings