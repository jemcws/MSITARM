param(
 [string] $resourceGroupName='3924-CWS-Dev',
 [string] $StorageAccountName='cwsdmolrssa',
 [string] $resourceGroupLocation="West US 2",
 [string] $subscriptionId="472e0eab-03f7-40c9-a6c3-d1d493b9ee5d",
 [string] $deploymentName="CwsDev",
 [String] $SPName="557f002d-2ed0-4a87-a1fe-d9778e651149",
 [String] $SPPwd=""
)
$user= $SPName
$pass = ConvertTo-SecureString $SPPwd -AsPlainText –Force
$cred = New-Object -TypeName pscredential –ArgumentList $user, $pass
Login-AzureRmAccount -Credential $cred -ServicePrincipal –TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47
    
# select subscription
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name "$resourceGroupName" -ErrorAction SilentlyContinue
if(!$resourceGroup)
{

    if(!$resourceGroupLocation) 
    {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    New-AzureRmResourceGroup -Name "$resourceGroupName" -Location $resourceGroupLocation
}
        
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -ErrorAction SilentlyContinue
if (!$storageAcc.StorageAccountName)
{  
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -AccountName $StorageAccountName -Location $resourceGroupLocation -Type 'Standard_LRS'
}
