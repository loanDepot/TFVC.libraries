# TFVC.libraries

Libraries for working with TFVC source control.

# Building

Run the build script in the root of the project to install dependent modules and start the build

    .\build.ps1

To just run the build, execute Invoke-Build

    Invoke-Build

    # or do a clean build
    Invoke-Build Clean,Default


Install dev version of the module on the local system after building it.

    Invoke-Build Install

# Update libraries

To update the libraries in this project, you run `Invoke-Build` with the `UpdateLibraries` task. This is not part of the CI/CD at this time.

    Invoke-Build UpdateLibraries

This will downloan multiple packgaes to the output folder and then pluck out the needed dlls to place in the module `lib` folder.
