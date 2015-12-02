# Custom Email DSC Resource
Custom PowerShell v5 DSC Resource for sending emails.

- 12/02/2015: Initial version

# Install
1. Download the EmailDSCResource-master.zip file.
2. Unblock the zip file (right click and select unblock).
3. Extract zip contents EmailDSCResource-master.zip file.
4. Rename EmailDSCResource-master folder to EmailDSCResource.
5. Copy renamed EmailDSCResource folder with contents to C:\Users\[username]\Documents\WindowsPowerShell\Modules folder
6. Run import-module EmailDSCResource cmdlet in PowerShell after following below steps.

#Tested
Tested on PowerShell v5.

#Usage
After importing the EmailDSCResource Module run get-dscresource.
```PowerShell
PS C:\Users\stefstr> Get-DscResource -module EmailDSCResource

ImplementedAs   Name                      ModuleName                     Version    Properties
-------------   ----                      ----------                     -------    ----------
PowerShell      EmailMessage              EmailDSCResource               1.2        {Body, Credential, FromEmail, Sm...
```

For more detailed information about the EmailDSCResource run.
```PowerShell
PS C:\Users\stefstr> Get-DscResource -name EmailMessage | Select-Object -ExpandProperty Properties

Name                 PropertyType   IsMandatory Values
----                 ------------   ----------- ------
Body                 [string]              True {}
Credential           [PSCredential]        True {}
FromEmail            [string]              True {}
SmptServer           [string]              True {}
Subject              [string]              True {}
To                   [string]              True {}
DependsOn            [string[]]           False {}
PsDscRunAsCredential [PSCredential]       False {}
```

#Example Configuration
```PowerShell
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

```
![ScreenShot](https://raw.githubusercontent.com/stefanstranger/EmailDSCResource/master/Demo.gif)
