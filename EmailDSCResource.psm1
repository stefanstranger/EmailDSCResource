[DscResource()]
class EmailMessage{
    [DscProperty(Mandatory)]
    [string]$To

    [DscProperty(Key)]
    [string]$FromEmail

    [DscProperty(Mandatory)]
    [string]$Subject

    [DscProperty(Mandatory)]
    [pscredential]$Credential

    [DscProperty(Mandatory)]
    [string]$Body

    [DscProperty(Mandatory)]
    [string]$SmptServer

    [void] Set() {
        send-mailmessage -to "$($this.To)" -from "$($this.FromEmail)" -subject "$($this.Subject)" `
                         -body "$($this.Body)" -credential $this.Credential `
                         -smtpserver "$($this.SmptServer)" -Port 587 -UseSsl

    }

    [bool] Test() { return $false }
    [EmailMessage] Get() { return $this }

}