remove-module emaildscresource
ipmo emaildscresource


$configData = @{

    AllNodes = @(

        @{
            NodeName = 'localhost' 
            PSDscAllowPlainTextPassword = $true
         }
)}


configuration EmailNotifcation
{

Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false)]
        $computername = ($env:computername),
        [Parameter(Mandatory=$true)]
        $To,
        [Parameter(Mandatory=$true)]
        $Subject,
        [Parameter(Mandatory=$true)]
        $Body,
        [Parameter(Mandatory=$true)]
        $SmptServer
    )
 

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName EmailDSCResource -ModuleVersion "1.2"

   node $AllNodes.NodeName
   {

            EmailMessage TryEmail 
            {
                To = $To
                FromEmail    = "EmailDSCResource@test.com"
                Subject  = $Subject
                Body     = $body
                SmptServer = $smptserver
                Credential = (Get-Credential)
                
            }
    }
}

#Create MOF file
EmailNotifcation -ConfigurationData $configData -OutputPath C:\Temp\DSC\EmailNotification -Verbose

#Make it so
Start-DscConfiguration -path C:\Temp\DSC\EmailNotification -Wait -Force -Verbose -ErrorAction Continue