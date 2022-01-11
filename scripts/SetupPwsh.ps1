Write-Verbose "Installing AWS.Tools.Common"
Install-Module AWS.Tools.Common -Force
Add-Content $profile "Import-Module AWS.Tools.Common"
Write-Verbose "Installing AWSLambdaPSCore"
Install-Module AWSLambdaPSCore -Force
Add-Content $profile "Import-Module AWSLambdaPSCore"
