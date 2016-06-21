Set-Location "$env:USERPROFILE\Desktop\MAS-Demo"
Add-AzureRmAccount -Environment $env -Verbose
# Get Azure Stack Environment subscription
Get-AzureRmSubscription -SubscriptionName "POC Subscription"  | Select-AzureRmSubscription

$rg = New-AzureRmResourceGroup -Name MAS-Demo -Location "local"
$Deploysettings = @{
    Name = 'MASVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/AzureStackDemo/master/azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings