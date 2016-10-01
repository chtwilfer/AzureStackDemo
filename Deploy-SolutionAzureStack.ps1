Set-Location "$env:USERPROFILE\Documents\GitHub\AzureStackDemo"
#Add-AzureRmAccount -Environment $env -Verbose
# Get Azure Stack Environment subscription
Get-AzureRmSubscription -SubscriptionName "Mark POC"  | Select-AzureRmSubscription
Get-AzureRmSubscription
Get-AzureRmResourceGroup

$rg = New-AzureRmResourceGroup -Name HybridCloud -Location "local" -Force
$Deploysettings = @{
    Name = 'MASVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/AzureStackDemo/master/azuredeploy.json' 
    #TemplateFile = '.\azuredeploy.json'
    TemplateParameterFile = '.\azurestackdeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings

### Post deployment - Connect VPN:
$presharedkey = "MySuperSecretKey10"
$gw = Get-AzureRmVirtualNetworkGateway -Name Gateway -ResourceGroupName $rg.ResourceGroupName
$ls = Get-AzureRmLocalNetworkGateway -Name LocalGateway -ResourceGroupName $rg.ResourceGroupName
New-AzureRMVirtualNetworkGatewayConnection -Name AzureStack-Azure -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -VirtualNetworkGateway1 $gw -LocalNetworkGateway2 $ls -ConnectionType IPsec -RoutingWeight 10 -SharedKey $presharedkey
