# EncryptHorizon
A simple but effective script to encrypt a file or a whole directory in Windows.

The Windows Defender is totally unable to detect the ongoing encryption as a threat. It is also unable to detect the encrypted files as a threat. So you can encrypt/decrypt your files without any problems.

## How it works

The script uses the [Invoke-AESEncryption](https://www.powershellgallery.com/packages/DRTools/4.0.2.3/Content/Functions%5CInvoke-AESEncryption.ps1) function from the [DRTools package](https://www.powershellgallery.com/packages/DRTools/4.0.3.4) to encrypt/decrypt files and directories.

**IMPORTANT: The key used to encrypt/decrypt the files is static in the current script.** So if you want to use a different, you have to change the key in the script. You can also (which I highly recommend) implement a remote key retrieval mechanism to get the key from a remote server. This way, you can change the key at any time and the script will always use the current key.


## How to use

Load the file `EncryptHorizon.ps1` in a PowerShell session and use the function with the following syntax:

```powershell
EncryptHorizon -action <Encrypt|Decrypt> [-path <path>]
```

Both the `-action` and the `-path` parameter are mandatory. The `-path` parameter can be a file or a directory. If it is a directory, the script will encrypt/decrypt all files in the directory and all subdirectories.