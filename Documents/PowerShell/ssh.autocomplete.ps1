using namespace System.Management.Automation

# From https://gist.github.com/backerman/2c91d31d7a805460f93fe10bdfa0ffb0?permalink_comment_id=4371578#gistcomment-4371578

Register-ArgumentCompleter -CommandName ssh,scp,sftp -Native -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    function Get-SSHHostList($sshConfigPath) {
        Get-Content -Path $sshConfigPath `
        | Select-String -Pattern '^Host ' `
        | ForEach-Object { $_ -replace 'Host ', '' } `
        | ForEach-Object { $_ -split ' ' } `
        | Sort-Object -Unique `
        | Select-String -Pattern '^.*[*!?].*$' -NotMatch
    }

    function Get-SSHConfigFileList ($sshConfigFilePath) {
        $sshConfigDir = Split-Path -Path $sshConfigFilePath -Resolve -Parent

        $sshConfigFilePaths = @()
        $sshConfigFilePaths += $sshConfigFilePath

        $pathsPatterns = @()
        Get-Content -Path $sshConfigFilePath `
        | Select-String -Pattern '^Include ' `
        | ForEach-Object { $_ -replace 'Include ', '' }  `
        | ForEach-Object { $_ -replace '~', $Env:USERPROFILE } `
        | ForEach-Object { $_ -replace '\$Env:USERPROFILE', $Env:USERPROFILE } `
        | ForEach-Object { $_ -replace '\$Env:HOMEPATH', $Env:USERPROFILE } `
        | ForEach-Object { 
        $sshConfigFilePaths += $(Get-ChildItem -Path $sshConfigDir\$_ -File -ErrorAction SilentlyContinue -Force).FullName `
        | ForEach-Object { Get-SSHConfigFileList $_ } 
        }

        if (($sshConfigFilePaths.Length -eq 1) -and ($sshConfigFilePaths.item(0) -eq $sshConfigFilePath) ) {
            return $sshConfigFilePath
        }

        return $sshConfigFilePaths | Sort-Object -Unique
    }

    $sshPath = "$Env:USERPROFILE\.ssh"
    $hosts = Get-SSHConfigFileList "$sshPath\config" `
    | ForEach-Object { Get-SSHHostList $_ } `

    # For now just assume it's a hostname.
    $textToComplete = $wordToComplete
    $generateCompletionText = {
        param($x)
        $x
    }
    if ($wordToComplete -match "^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$") {
        $textToComplete = $Matches["host"]
        $generateCompletionText = {
            param($hostname)
            $Matches["user"] + "@" + $hostname
        }
    }

    $hosts `
    | Where-Object { $_ -like "${textToComplete}*" } `
    | ForEach-Object { [CompletionResult]::new((&$generateCompletionText($_)), $_, [CompletionResultType]::ParameterValue, $_) }
}
