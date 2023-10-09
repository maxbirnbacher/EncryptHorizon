```
███████╗███╗   ██╗ ██████╗██████╗ ██╗   ██╗██████╗ ████████╗██╗  ██╗ ██████╗ ██████╗ ██╗███████╗ ██████╗ ███╗   ██╗    ██╗   ██╗ ██╗   ██╗
██╔════╝████╗  ██║██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██║  ██║██╔═══██╗██╔══██╗██║╚══███╔╝██╔═══██╗████╗  ██║    ██║   ██║███║  ███║
█████╗  ██╔██╗ ██║██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ███████║██║   ██║██████╔╝██║  ███╔╝ ██║   ██║██╔██╗ ██║    ██║   ██║╚██║  ╚██║
██╔══╝  ██║╚██╗██║██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██╔══██║██║   ██║██╔══██╗██║ ███╔╝  ██║   ██║██║╚██╗██║    ╚██╗ ██╔╝ ██║   ██║
███████╗██║ ╚████║╚██████╗██║  ██║   ██║   ██║        ██║   ██║  ██║╚██████╔╝██║  ██║██║███████╗╚██████╔╝██║ ╚████║     ╚████╔╝  ██║██╗██║
╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝      ╚═══╝   ╚═╝╚═╝╚═╝
```

-------------------------------------------------------------------------------------

A simple but effective script to encrypt a file or a whole directory in Windows.

The Windows Defender is totally unable to detect the ongoing encryption as a threat. It is also unable to detect the encrypted files as a threat. So you can encrypt/decrypt your files without any problems.

Works with:
- Files
- Directories
- Subdirectories
- Remote shares mapped as drives
- UNC paths

## Roadmap
- [x] Encrypt files
- [x] Encrypt directories
- [x] Decrypt files
- [x] Decrypt directories
- [X] User-friendly decryption screen
- [ ] Disable important keys (e.g. F1-12, CTRL, ALT, SUPER, etc.)
- [ ] Disable important key combinations (e.g. CTRL+ALT+DEL, ALT+F4, etc.)

## How it works

The script uses the [Invoke-AESEncryption](https://www.powershellgallery.com/packages/DRTools/4.0.2.3/Content/Functions%5CInvoke-AESEncryption.ps1) function from the [DRTools package](https://www.powershellgallery.com/packages/DRTools/4.0.3.4) to encrypt/decrypt files and directories.

**IMPORTANT: The key used to encrypt/decrypt the files is static in the current script.** So if you want to use a different, you have to change the key in the script. You can also (which I highly recommend) implement a remote key retrieval mechanism to get the key from a remote server. This way, you can change the key at any time and the script will always use the current key.

**IMPORTANT: There is a static "red flag" defined called `_stop.txt`** This file will be skipped and is there as a placeholder if you need to skip a certain file or directory for some reason.

## How to use

Load the file `EncryptHorizon.ps1` in a PowerShell session and use the function with the following syntax:

```powershell
EncryptHorizon -action <Encrypt|Decrypt> [-path <path>]
```

Both the `-action` and the `-path` parameter are mandatory. The `-path` parameter can be a file or a directory. If it is a directory, the script will encrypt/decrypt all files in the directory and all subdirectories.

## Examples
### Encryption

File

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/4fe64785-bb55-48ec-a88d-4282affd6d2d)

Directory

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/54ad21d0-3ea5-43d7-9bdc-fe0b43395869)

Result

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/013a97e5-5f7d-47f6-acd1-7cbd254824c5)

### Decryption

File

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/bc32ef52-5f00-41d5-862c-b42cce831ca3)

Directory

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/28d4e529-2f88-44aa-91dc-61881019ade7)

Result

![image](https://github.com/maxbirnbacher/EncryptHorizon/assets/66524685/85767562-be0a-464a-babc-b8a18a6e4e3c)


