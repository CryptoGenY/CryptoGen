<#
.SYNOPSIS
    CryptoGen installer
.DESCRIPTION
    Clean Folders Source + Destination
.PARAMETER ParameterName
    agentKIF
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
   https://github.com/CryptoGenY/CryptoGen
#>
param (
    [bool]$agentKIF
)
# Check if the current user is an administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Output the result
if ($isAdmin) {
    Write-Host "[CG] Current user is an administrator."
}
else {
    Write-Host "[CG] Current user is not an administrator." -foregroundcolor red 
    exit
}

# Check the current execution policy
$executionPolicy = Get-ExecutionPolicy

# Output the current execution policy
Write-Host "[CG] Current execution policy: $executionPolicy"

# Set the execution policy to RemoteSigned if it's not already
if ($executionPolicy -ne "RemoteSigned") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Host "[CG] Execution policy set to RemoteSigned."
}
else {
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
if (Test-Path -Path $regPath) {
    Write-Host "[CG] MEGAcmd exists"
}
else {
    set-location $sourcePath
    $downloadUrl = "https://mega.nz/MEGAcmdSetup64.exe"
    Invoke-WebRequest -Uri $downloadUrl -OutFile "c:\tmp\MEGAcmdSetup64.exe"
    Start-Process -FilePath "MEGAcmdSetup64.exe" -ArgumentList "/S" -Wait
}

# Specify the registry path (megacmd)
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$registryValue = (Get-ItemProperty -Path $registryPath).Path
Write-Host "[CG] CryptoGen debug path"
$DebugPath = $registryValue.replace(';;',';')
[System.Environment]::SetEnvironmentVariable("Path",$DebugPath,"Machine")

# Check if the registry value contains the desired path
if ($registryValue -and $registryValue -like "*$env:LOCALAPPDATA\CryptoGen") {
    Write-Host "[CG] Path already present in registry"
}else {
# Add the desired path to the existing PATH value
$targetDir = $env:LOCALAPPDATA + "\CryptoGen"
if(-Not($DebugPath -Contains $targetDir)) {
        write-host "[CG] CryptoGen Adding $targetDir to Machine Path"
        $DebugPath = $registryValue + ";" + $targetDir 
        [System.Environment]::SetEnvironmentVariable("Path",$DebugPath,"Machine")
    }
}

if ($agentKIF -eq $true) {
    # Remove all files from the source path
    if (Test-Path $sourcePath\publish) {
        Remove-Item $sourcePath\publish\*.* -Force -Recurse
    }
    # Getting CryptoGen
    mega-get "https://mega.nz/folder/NZcgwbxK#UoFf5dW7umhk7eUEsqgOZw" "C:\tmp\CryptoGen" 

    # Loop through each file in the source path
    foreach ($file in Get-ChildItem -Path $sourcePath\publish -File) {
        # Check if the file already exists in the destination path
        $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
        if (Test-Path $destinationFile -PathType Leaf) {
            # If the file exists in the destination, copy it again
            Remove-Item -Path $destinationFile -Force
            Copy-Item -Path $file.FullName -Destination $destinationPath -Force
        }
        else {
            # If the file doesn't exist in the destination, simply copy it
            Copy-Item -Path $file.FullName -Destination $destinationPath
        }
        write-host "$file done"
    }
    # Remove all files from the source path
    Remove-Item $sourcePath -Force -Recurse
    Write-Host "[CG] AgentKIFSetup done."
}
