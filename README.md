# [Some Azure PowerShell]()
While learning some Azure and bicep, I figured I should also brush up on some PowerShell. Its been a while since I had to write any PowerShell (last time I believe, was for some vmware PowerCLI eons ago), so I figured this would be a good opportunity.  Though for most work, I tend to favor an *ix shell, I have to admit that I really liked Powershell for imperative work on Azure (with the exception of AKS).  In fact, re-learning PowerShell was actually enjoyable this time around.  Not sure about others, but it always took me a bit of time, getting back up to speed with jq, which seems almost a necessity when working with cloud cli running over bash.  With Powershell, you really don't have to concern yourself with jq.

### Why not Azure Resource Graph
Please note, that for most of these functions, its probably better to use something like, Azure Resource Graph Explorer.
You can access this via Azure Portal, or use your choice of posion via Search-AzGraph or az graph.  
Azure Resource Graph is probably the best tool to use when performing queries against Azure Resource Manager.
Personally, I think the best route is to (1) create queries from Azure Resource Graph, and then save the queries later for use with your shell of choice.
Using Azure Resource Graph is faster, and often easier to query Azure resources via KQL.
With Search-AzGraph, you can still implement PowerShell's error handling, paging, etc., as well as stored KQL queries for repeatable execution.

### Azure PowerShell Scripts
Most PowerShell scripts that I have been commonly using are under the project's [bin directory](https://github.com/namugajichaebol/azure-ABC/blob/main/bin/).  Some of the PS scripts were from lab material.  However, I wrote the following scripts for giggles.
| Script Name                         | Description          
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| deploy-AzPrivateEndpoint4WebApp.ps1 | A quick PowerShell script which allows one to create a Dynamic Private Endpoint for an existing WebApp. |
| deploy-AzQuickVM.ps1                | A quick PowerShell script which allows one to easily create an Azure Virtual Machine. |
| invoke-VHDSnapshot.ps1              | Invokes a Snapshot for an Azure VHD.  If `-VMName` is specified, but `-Name` is not, source will default to the osDisk of the VM.  If `-Quiesce` is used with `-VMName`, the script will attempt to stop the VM before the snapshot, and restart the VM after the snapshot. Use the `-Incremental` switch to specify an incremental snapshot. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/invoke-VHDSnapshot.png)  |

### Azure PowerShell Profile
For the most part, I wrote up basic functions which can be sourced as a PS profile script.  See [Microsoft.Azure_profile.ps1](https://github.com/namugajichaebol/azure-ABC/blob/main/Microsoft.Azure_profile.ps1).  This can be sourced many different ways.  You could either append the contents of this file to your default PS profile (in this way, you would have them handy anytime launching a new trminal.  Of you could just simply source it like so...

...from Windows
```Powershell
PS> . .\Microsoft.Azure_profile.ps1
```

<br/><br/>
### [Microsoft.Azure_profile.ps1 Functions](#)  
I documented a few of the functions below.

| Function Name                     | Description                                                                                                  
|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Grab-AzActLog                     | Retrieve Activity Log for the last day. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzActLog.png) |
| Grab-AzRoleAssignments            | List Azure RBAC role assignments which are viewable by the current account context.  Use the `-type` switch to specify which ObjectType for the Role Assignment.  By default, function will attempt to see all Role Assignments for the SignedIn User.<br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzRoleAssignments.png) |
| Grab-AzVM-Disks                   | Grab Virtual Disk Details for an Azure Virtual Machine. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzVM-Disks.png)  |
| Grab-AzVM-OsDetails               | Grab OS Status Details for an Azure Virtual Machine |
| Grab-AzVM-Statuses                | Grab Status Details for an Azure Virtual Machine |
| Grab-AzVM-Table                   | Display a table of all Azure Virtual Machines for a ResourceGroup  <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzVM-Table.png)  |
| Grab-AzVM-IpAddresses             | Display all IP configuration details for an Azure Virtual Machine. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzVM-IpAddresses.png)  |
| Grab-AzVMSS-IpAddresses           | Display IP configuration details for an Azure Virtual Machine Scale Set. | 
| Grab-AzWebApp-Table               | Display a summary of Azure Web Applications. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzWebApp-Table.png)  |
| Grab-AKS-Summary                  | Grab Summary details for an Azure Kubernetes Services Cluster. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AKS-Summary.png)  | 
| Grab-AzVnet-Connected             | Display network resources connected to an Azure Virtual Network. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzVnet-Connected.png)  |
| Grab-AzVnet-Peerings              | Display Virtual Network Peerings for an Azure Virtual Network. |
| Grab-AzVnet-Subnets               | Display Subnets for an Azure Virtual Network.  |
| Grab-AzRouteTable                 | Grab Routing Tables <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AzRouteTable.png) |
| Grab-DNS-Records                  | Grab DNS Records.  Use the `-type` switch to specify, Private (default) or Public DNS Zones.  |
| Grab-PrivateDNS-Links             | Grab Virtual Network Links associated for an Azure Private DNS Zone |
| Grab-NSG-Members                  | Display Subnets and Network Interfaces that are members for an Azure NSG. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-NSG-Members.png)  |
| Grab-NSG-Table                    | Display Inbound and Outbound Rules Configuration for a Network Security Group.  <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-NSG-Table.png)  |
| Grab-Storage-Summary              | List and display all Uri information for access methods for an Azure Storage Account. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-Storage-Table.png) |
| Grab-ALB-FEIps                    | Display Front-end Network Information for an Azure Load Balancer. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-ALB-FEIPs.png)  |
| Grab-ALB-BEIps                    | Display Back-end Network Details for an Azure Load Balancer. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-ALB-BEIPs.png)  |
| Grab-AAG-FEIps                    | Display Front-end Network Information for an Azure Application Gateway. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AAG-FEIps.png)  |
| Grab-AAG-BEStatus                 | Display Back-end Network Details for an Azure Application Gateway. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-AAG-BEStatus.png)  |
| Grab-ATM-Endpoints                | Grab Endpoint Status and Details for an Azure Traffic Manager Profile <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-ATM-Endpoints.png)  |
| Grab-CDNProfile-Origins           | Grab Origin details for an Azure FrontDoor CDN Origin Group. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-CDNProfile-Origins.png)  |
| Grab-PcapFile                     | Download an existing NetworkWatcher Packet Capture Trace to local computer. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-PcapFile.png) |
| Grab-KQL-OperationalInsights      | Perform KQL Queries against tables from an Insights Worskpace. <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-KQL-OperationalInsights1.png) <br/> Here is another example of running a query to see which Resource has not responded to a heartbeat in the last 5 minutes <br/><br/>![](https://github.com/namugajichaebol/azure-ABC/blob/main/docs/images/Grab-KQL-OperationalInsights2.png)  |
| Invoke-RGDeployment               | Runs an Azure Resource Deployment for an Azure Resource Group.  Function is a wrapper to run this process taking account the way I typically like to run it. |
