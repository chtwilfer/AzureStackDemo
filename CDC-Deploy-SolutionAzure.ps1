﻿Add-AzureRmAccount -Verbose
# Get Azure subscription
Get-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise with MSDN"  | Select-AzureRmSubscription

$rg = New-AzureRmResourceGroup -Name CDC-Demo -Location "westeurope"
$Deploysettings = @{
    Name = 'CDCVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = '.\azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings