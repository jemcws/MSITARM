param(
 [string] $resourceGroupName='3924-CWS-Dev',
 [string] $StorageAccountName='cwsdmolrssa',
 [string] $resourceGroupLocation="West US 2",
 [string] $subscriptionId="472e0eab-03f7-40c9-a6c3-d1d493b9ee5d",
 [string] $deploymentName="CwsDev",
 [String] $SPName="557f002d-2ed0-4a87-a1fe-d9778e651149",
 [String] $SPPwd=""
)
try{
   
    $user= $SPName
    $pass = ConvertTo-SecureString $SPPwd -AsPlainText –Force
    $cred = New-Object -TypeName pscredential –ArgumentList $user, $pass
    Login-AzureRmAccount -Credential $cred -ServicePrincipal –TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47
    Write-verbose "logged into Azure."
    
    # select subscription
    Write-Host "Selecting subscription '$subscriptionId'";
    Select-AzureRmSubscription -SubscriptionID $subscriptionId;

    #Create or check for existing resource group
    $resourceGroup = Get-AzureRmResourceGroup -Name "$resourceGroupName" -ErrorAction SilentlyContinue
    if(!$resourceGroup)
    {
        Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
        if(!$resourceGroupLocation) {
            $resourceGroupLocation = Read-Host "resourceGroupLocation";
        }
        Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
        New-AzureRmResourceGroup -Name "$resourceGroupName" -Location $resourceGroupLocation
    }
    else{
        Write-Host "Using existing resource group '$resourceGroupName'";
    }

    # Start the deployment -Procuring Storage Account.
    Write-Host "Starting deployment For Storage Account Creation For '$StorageAccountName'";
        
    $storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -ErrorAction SilentlyContinue
    if (!$storageAcc.StorageAccountName)
    {  
       Write-Host "Creating Storage Account... $StorageAccountName"
       New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -AccountName $StorageAccountName -Location $resourceGroupLocation -Type 'Standard_LRS'
     }
     else
     {
        Write-Host "Taking already existing Storage Account: '$StorageAccountName' from  Resource Group: '$resourceGroupName' "
     }
}
catch [System.Exception]
{
	$tryError = $_.Exception
	$message = $tryError.Message
	Write-Host "Unable to configure it on server-$RemoteComputers. Error: $message. "
    break
}
