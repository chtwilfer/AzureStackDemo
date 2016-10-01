#region TP1
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
#endregion

#region TP2
$Domain = "azurestack.nl"
$password = ConvertTo-SecureString "MySecret" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential "MYACCOUNT@MYDIR.onmicrosoft.com", $password
$Credential = Get-Credential
$Name = "AzureStack"
$ResourceManagerEndpoint = "https://api." + $Domain
$DirectoryTenantId = "32a37567-ae0b-4316-98af-a98bd9e30894"
$endpoints = Invoke-RestMethod -Method Get -Uri "$($ResourceManagerEndpoint.ToString().TrimEnd('/'))/metadata/endpoints?api-version=2015-01-01" -Verbose
Write-Verbose -Message "Endpoints: $(ConvertTo-Json $endpoints)" -Verbose

$AzureKeyVaultDnsSuffix="vault.$($Domain)".ToLowerInvariant()
$AzureKeyVaultServiceEndpointResourceId= $("https://vault.$Domain".ToLowerInvariant())
$StorageEndpointSuffix = ($Domain).ToLowerInvariant()

$azureEnvironmentParams = @{
    Name                                     = $Name
    ActiveDirectoryEndpoint                  = $endpoints.authentication.loginEndpoint.TrimEnd('/') + "/"
    ActiveDirectoryServiceEndpointResourceId = $endpoints.authentication.audiences[0]
    AdTenant                                 = $DirectoryTenantId
    ResourceManagerEndpoint                  = $ResourceManagerEndpoint
    GalleryEndpoint                          = $endpoints.galleryEndpoint
    GraphEndpoint                            = $endpoints.graphEndpoint
    GraphAudience                            = $endpoints.graphEndpoint
    StorageEndpointSuffix                    = $StorageEndpointSuffix
    AzureKeyVaultDnsSuffix                   = $AzureKeyVaultDnsSuffix
    AzureKeyVaultServiceEndpointResourceId   = $AzureKeyVaultServiceEndpointResourceId
}

$azureEnvironment = Add-AzureRmEnvironment @azureEnvironmentParams
$azureEnvironment = Get-AzureRmEnvironment $azureEnvironmentParams.Name

$azureAccount = Add-AzureRmAccount -Environment $azureEnvironment -Credential $Credential -TenantId $DirectoryTenantId -Verbose
Write-Verbose "Using account: $(ConvertTo-Json $azureAccount.Context)" -Verbose
#endregion

