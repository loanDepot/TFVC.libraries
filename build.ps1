[CmdletBinding()]

param($Task = 'Default')

$Script:Modules = @(
    'BuildHelpers',
    'InvokeBuild',
    #'LDModuleBuilder',
    'Pester',
    'platyPS',
    'PSScriptAnalyzer'
)

$Script:ModuleInstallScope = 'CurrentUser'

'Starting build...'
'Installing module dependencies...'

Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

foreach ( $module in $Modules )
{
    "  Installing [$module]"
    $install = Find-Module $module | Sort-Object Repository | Select-Object -First 1
    $installed = $install | Install-Module -Force -SkipPublisherCheck -AllowClobber -AcceptLicense -Scope $Script:ModuleInstallScope
    $installed | Import-Module
    "    [{0}] [{1}]" -f $installed.Name,$installed.Version
}

Set-BuildEnvironment
Get-ChildItem Env:BH*
Get-ChildItem Env:APPVEYOR*

$Error.Clear()

'Invoking build'

Invoke-Build $Task -Result 'Result'
if ($Result.Error)
{
    $Error[-1].ScriptStackTrace | Out-String
    exit 1
}

exit 0
