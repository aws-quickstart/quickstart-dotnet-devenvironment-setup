$profileName = $(Invoke-WebRequest http://169.254.169.254/latest/meta-data/iam/security-credentials).Content
$response = invoke-webrequest "http://169.254.169.254/latest/meta-data/iam/security-credentials/$profileName";
$json = ConvertFrom-Json -InputObject $response.Content;
$expiration = [System.DateTime]::Parse($json.Expiration);

$awsPath = Join-Path $env:USERPROFILE .aws
$credentialsPath = Join-Path $awsPath credentials
if(-not $(test-path $awsPath)) { mkdir $awsPath };
if (-not $(Test-Path $credentialsPath) -or ($(Get-Item $credentialsPath).LastWriteTime -le $expiration)) {
  Out-File -Force -FilePath $credentialsPath -Encoding utf8 -InputObject "[default]`naws_access_key_id=$($json.AccessKeyId)`naws_secret_access_key=$($json.SecretAccessKey)`naws_session_token=$($json.Token)"
}
# If there's not already a scheduled task to update the credentials, create one.
try {
  $refreshTask = Unregister-ScheduledTask -TaskName "Refresh AWS Credentials" -Confirm:$false
} catch {
}
schtasks.exe /create /tn "Refresh AWS Credentials" /sc ONEVENT /ec "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational" /MO "*[System[Provider[@Name='Microsoft-Windows-TerminalServices-LocalSessionManager'] and EventID=25]]" /tr "pwsh -WindowStyle Hidden -file C:\AWS\UpdateProfileCredentials.ps1"
$task = Get-ScheduledTask -TaskPath "\" -TaskName "Refresh AWS Credentials"
$triggers = $($( Get-ScheduledTask -TaskPath "\" -TaskName "Refresh AWS Credentials" ).Triggers + @( $(New-ScheduledTaskTrigger -AtLogOn)))
Set-ScheduledTask -TaskPath "\" -TaskName "Refresh AWS Credentials" -Trigger $triggers
