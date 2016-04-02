#-----------------------
# ConfigureSSH.ps1
#-----------------------

$ErrorActionPreference='Stop'

try {

    echo "$(date) ConfigureSSH.ps1 starting" >> $env:SystemDrive\packer\PostSysprep.log
    Start-Process -wait taskkill -ArgumentList "/F /IM sshd.exe" -ErrorAction SilentlyContinue
    Start-Process -wait -WorkingDirectory c:\packer -NoNewWindow c:\cygwin\bin\bash -ArgumentList "--login /cygdrive/c/packer/ConfigureSSH.sh >> /cygdrive/c/packer/PostSysprep.log 2>&1"
}
Catch [Exception] {
    echo "$(date) ConfigureSSH.ps1 complete with Error '$_'" >> $env:SystemDrive\packer\PostSysprep.log
    exit 1
}
Finally {
    $ErrorActionPreference='SilentlyContinue'
    echo "$(date) ConfigureSSH.ps1 turning off auto admin logon" >> $env:SystemDrive\packer\PostSysprep.log
    REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon" /v AutoAdminLogon /f | Out-Null
    REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon" /v DefaultUserName  /f | Out-Null
    REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon" /v DefaultPassword  /f | Out-Null
    echo "$(date) ConfigureSSH.ps1 complete successfully at $(date)" >> $env:SystemDrive\packer\PostSysprep.log
    
    # Tidy up
    Remove-Item "C:\Users\jenkins\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ConfigureSSH.lnk" -Force -ErrorAction SilentlyContinue
    Remove-Item c:\packer\password.txt -Force -ErrorAction SilentlyContinue
    Remove-Item c:\packer\ConfigureSSH.log -Force -ErrorAction SilentlyContinue
    shutdown /t 0 /r /f /c "ConfigureSSH.ps1"
} 