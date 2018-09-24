task UpdateLibraries {
    $packagePath = Join-Path $ouptut, "downloads\packages"
    New-Item -ItemType Directory -Path $packagePath -Force -ErrorAction Ignore
    Write-Verbose 'Download all packages'

    $package = 'Microsoft.TeamFoundationServer.ExtendedClient'
    Install-Package -Name $package -Destination $packagePath -ProviderName NuGet -Source 'https://www.nuget.org/api/v2' -ExcludeVersion  -Force -verbose

    $clientFiles = Get-ChildItem -Path $packagePath -Recurse -File -Filter "*.dll"
    $libraries = $clientFiles | Where FullName -notmatch 'portable|resources' |
        Where FullName -Match 'net45|native|Microsoft\.ServiceBus'

    $libraries | Copy-Item -Destination $Source\lib
}
