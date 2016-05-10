Add-AzureRmAccount -Environment $env -Verbose
# Get Azure Stack Environment subscription
Get-AzureRmSubscription -SubscriptionName "POC Subscription"  | Select-AzureRmSubscription

$rg = New-AzureRmResourceGroup -Name CDC-Demo -Location "local"
$Deploysettings = @{
    Name = 'CDCVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/CDC-Germany/master/azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings