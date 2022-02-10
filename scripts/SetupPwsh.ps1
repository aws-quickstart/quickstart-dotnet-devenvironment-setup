Write-Verbose "Installing AWS.Tools.Installer"
Install-Module AWS.Tools.Installer -Force
Add-Content $profile "Import-Module AWS.Tools.Installer"
Write-Verbose "Installing AWS.Tools.Common"
Install-AWSToolsModule AWS.Tools.Common -Force
Add-Content $profile "Import-Module AWS.Tools.Common"
Write-Verbose "Installing AWSLambdaPSCore"
Install-Module AWSLambdaPSCore -Force
Add-Content $profile "Import-Module AWSLambdaPSCore"
