Set-Location "$env:USERPROFILE\Documents\GitHub\AzureStackDemo"
Add-AzureRmAccount -Verbose
# Get Azure subscription
Get-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise with MSDN"  | Select-AzureRmSubscription

$rg = New-AzureRmResourceGroup -Name HybridCloud -Location "westeurope" -Force
$Deploysettings = @{
    Name = 'AZUREVMDeploy1'
    ResourceGroupName= $rg.ResourceGroupName 
    TemplateFile = 'https://raw.githubusercontent.com/markscholman/AzureStackDemo/master/azuredeploy.json' 
    #TemplateFile = '.\azuredeploy.json' 
    TemplateParameterFile = '.\azuredeploy.parameters.json'
    Verbose = $true
}
New-AzureRmResourceGroupDeployment @Deploysettings

### Post deployment - Connect VPN:
$presharedkey = "MySuperSecretKey10"
$gw = Get-AzureRmVirtualNetworkGateway -Name Gateway -ResourceGroupName $rg.ResourceGroupName
$ls = Get-AzureRmLocalNetworkGateway -Name LocalGateway -ResourceGroupName $rg.ResourceGroupName
New-AzureRMVirtualNetworkGatewayConnection -Name Azure-AzureStack -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -VirtualNetworkGateway1 $gw -LocalNetworkGateway2 $ls -ConnectionType IPsec -RoutingWeight 10 -SharedKey $presharedkey