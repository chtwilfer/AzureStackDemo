#get Azure environments
Get-AzureRmEnvironment | select Name, ManagementPortalUrl, ResourceManagerUrl
# Add specific Azure Stack Environment
$AadTenantId = "azurestacknl.onmicrosoft.com" #GUID Specific to the AAD Tenant
Add-AzureRmEnvironment -Name 'Azure Stack' `
     -ActiveDirectoryEndpoint ("https://login.windows.net/$AadTenantId/") `
     -ActiveDirectoryServiceEndpointResourceId "https://azurestack.local-api/" `
     -ResourceManagerEndpoint ("https://api.azurestack.local/") `
     -GalleryEndpoint ("https://gallery.azurestack.local:30016/") `
     -GraphEndpoint "https://graph.windows.net/"

# Get Azure Stack Environment information
$env = Get-AzureRmEnvironment 'Azure Stack'
Get-AzureRmEnvironment | select Name, ManagementPortalUrl, ResourceManagerUrl
