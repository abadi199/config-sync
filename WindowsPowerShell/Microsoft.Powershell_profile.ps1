function subl { &"${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args }
#Import-VisualStudioVars 140 amd64
Invoke-BatchFile $env:VS140COMNTOOLS\VsMsBuildCmd.bat
$env:Platform = "Any CPU"
Remove-Item alias:ls
Remove-Item alias:rm
Set-Location C:\Projects 
# Load posh-git example profile
#. 'C:\Users\akurniawan\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'
#. 'C:\Code\posh-monokai\posh-monokai.ps1'
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
# Load posh-git example profile
. 'C:\tools\poshgit\dahlbyk-posh-git-1941da2\profile.example.ps1'
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}
# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    Write-Host ""
    Write-Host $pwd.ProviderPath -NoNewline -BackgroundColor Blue -ForegroundColor White    
    Write-VcsStatus
    $global:LASTEXITCODE = $realLASTEXITCODE
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "`nSU>" -NoNewline -BackgroundColor DarkRed -ForegroundColor Black
    } else {
        Write-Host "`n>" -NoNewline -ForegroundColor DarkGreen
    }
    return ' '
}

Import-Module PSReadline
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete