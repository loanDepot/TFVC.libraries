task UpdateLibraries {
    $packagePath = Join-Path $Output "downloads\packages"
    New-Item -ItemType Directory -Path $packagePath -Force -ErrorAction Ignore
    Write-Verbose 'Download all packages'

    $package = 'Microsoft.TeamFoundationServer.ExtendedClient'

    Install-Package -Name $package -Destination $packagePath -ProviderName NuGet -Source 'https://www.nuget.org/api/v2' -ExcludeVersion  -Force -verbose

    $clientFiles = Get-ChildItem -Path $packagePath -Recurse -File -Filter "*.dll"
    $libraries = $clientFiles | Where FullName -notmatch 'portable|resources' |
        Where FullName -Match 'net45|native|Microsoft\.ServiceBus'

    $libraries | Copy-Item -Destination $Source\lib

    $licenses = Get-ChildItem $packagePath -Recurse -File |
        where Extension -Match 'me|txt|md|rtf'

    $licenseFolder = "$Source\lib\license"

    foreach ( $file in $licenses )
    {
        $path = $file.FullName -replace ([regex]::Escape($packagePath)), $licenseFolder
        $folder = Split-Path $path
        New-Item -ItemType Directory -Path $folder -Force -ErrorAction Ignore
        $file | Copy-Item -Destination $folder
    }
}
