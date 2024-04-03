<#
.SYNOPSIS
    CryptoGen installer
.DESCRIPTION
    Clean Folders Source + Destination
.PARAMETER ParameterName
    na
.EXAMPLE
    .\install-CryptoGen.ps1
.INPUTS
    na
.OUTPUTS
    $env:LOCALAPPDATA\CryptoGen\
.NOTES
    Additional notes or comments about the script, its purpose, or its usage.
    Author: Stephane CHAUVEAU
    Date: 01/04/2024 (not an easter egg)
    Version: 1.0
    PowerShell Version: 2.0
.LINK
    GitHub
#>
param (
    [bool]$agentKIF
)
# Check if the current user is an administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Output the result
if ($isAdmin) {
    Write-Host "[CG] Current user is an administrator."
} else {
    Write-Host "[CG] Current user is not an administrator."
}

# Check the current execution policy
$executionPolicy = Get-ExecutionPolicy

# Output the current execution policy
Write-Host "[CG] Current execution policy: $executionPolicy"

# Set the execution policy to RemoteSigned if it's not already
if ($executionPolicy -ne "RemoteSigned") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "[CG] Execution policy set to RemoteSigned."
} else {
    Write-Host "[CG] Execution policy is already minimum RemoteSigned."
}
# Create temp Source Destination
$sourcePath = "C:\tmp\CryptoGen\"
$destinationPath = "$env:LOCALAPPDATA\CryptoGen\"
if (-not (Test-Path -Path "C:\tmp\CryptoGen" -PathType Container)) {
    New-Item -ItemType Directory -Path "C:\tmp\CryptoGen" -force
    Write-Host "[CG] Directory 'C:\tmp\CryptoGen' created successfully."
}
if (-not (Test-Path -Path "$env:LOCALAPPDATA\CryptoGen" -PathType Container)) {
    New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\CryptoGen" -force
    Write-Host "[CG] Directory '$env:LOCALAPPDATA\CryptoGen' created successfully."
}

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MEGAcmdShell.exe"
$defaultValue = Get-ItemPropertyValue -Path $regPath -Name "(Default)"
if (Test-Path -Path $regPath) {
    Write-Host "[CG] MEGAcmd exists"
} else {
cd $sourcePath
$downloadUrl = "https://mega.nz/MEGAcmdSetup64.exe"
Invoke-WebRequest -Uri $downloadUrl -OutFile "c:\tmp\MEGAcmdSetup64.exe"
Start-Process -FilePath "MEGAcmdSetup64.exe" -ArgumentList "/S" -Wait
}

# Specify the registry path
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$registryValue = Get-ItemProperty -Path $registryPath -Name "Path"

# Check if the registry value contains the desired path
if ($registryValue -and $registryValue.Path -like "*$env:LOCALAPPDATA\MEGAcmd*") {
    Write-Host "[CG] Path already present in registry"
} else {
    # Add the desired path to the existing PATH value
    $newPath = $env:LOCALAPPDATA + "\MEGAcmd"
    if ($registryValue -eq $null) {
        # If the PATH value doesn't exist, create a new one
        New-ItemProperty -Path $registryPath -Name "Path" -Value $newPath -PropertyType "ExpandString" -Force
    } else {
        # If the PATH value exists, append the new path to it
        $newValue = $registryValue.Path + ";" + $newPath
        Set-ItemProperty -Path $registryPath -Name "Path" -Value $newValue
    }
    Write-Host "[CG] CryptoGen path added to Path variable"
    # Reload the PATH variable
    [System.Environment]::SetEnvironmentVariable("Path", $newValue, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "[CG] PATH variable reloaded."
}

if ($agentKIF = $true){
# Remove all files from the source path
Remove-Item $sourcePath\publish\AgentKif*.* -Force -Recurse
# Getting CryptoGen
mega-get "https://mega.nz/folder/NZcgwbxK#UoFf5dW7umhk7eUEsqgOZw" "C:\tmp\CryptoGen"

# Loop through each file in the source path
foreach ($file in Get-ChildItem -Path $sourcePath\publish -File) {
    # Check if the file already exists in the destination path
    $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
    if (Test-Path $destinationFile -PathType Leaf) {
        # If the file exists in the destination, copy it again
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
    } else {
        # If the file doesn't exist in the destination, simply copy it
        Copy-Item -Path $file.FullName -Destination $destinationPath
    }
    Write-Host "[CG] Setup done."
}
# Remove all files from the source path
Remove-Item $sourcePath\publish\AgentKif*.* -Force -Recurse
}
