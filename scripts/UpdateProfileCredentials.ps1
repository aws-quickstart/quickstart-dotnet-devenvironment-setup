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