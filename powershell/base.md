>[refer](https://github.com/chucklu)

## 查看PowerShell的版本

```ps
$PSVersionTable.PSVersion

$PSVersionTable

get-host

Name             : ConsoleHost
Version          : 4.0
InstanceId       : 875b4d86-f187-4eff-bd18-433f0666b39e
UI               : System.Management.Automation.Internal.Host.InternalHostUserI
                   nterface
CurrentCulture   : zh-CN
CurrentUICulture : zh-CN
PrivateData      : Microsoft.PowerShell.ConsoleHost+ConsoleColorProxy
IsRunspacePushed : False
Runspace         : System.Management.Automation.Runspaces.LocalRunspace

```

## 查看操作系统

```ps
wmic os get caption

Caption
Microsoft Windows 7 企业版
```

## 查看架构

```powershell
wmic os get osarchitecture

OSArchitecture
64-bit
```

## 查找Service

```ps
get-service | format-table

Status   Name               DisplayName
------   ----               -----------
...
Stopped  AdobeARMservice    Adobe Acrobat Update Service
Running  AdobeUpdateService AdobeUpdateService
Stopped  AeLookupSvc        Application Experience
Running  AGMService         Adobe Genuine Monitor Service
Running  AGSService         Adobe Genuine Software Integrity Se...
Stopped  ALG                Application Layer Gateway Service
Stopped  AppIDSvc           Application Identity
Stopped  Appinfo            Application Information
Stopped  AppMgmt            Application Management
Stopped  aspnet_state       ASP.NET 状态服务
...
```

>`format-table`可以确保 `Name` 被完整显示

```ps
get-service | format-table servicename,displayname -autosize

ServiceName                        DisplayName
-----------                        -----------
....
AdobeARMservice                    Adobe Acrobat Update Service
AdobeUpdateService                 AdobeUpdateService
AeLookupSvc                        Application Experience
AGMService                         Adobe Genuine Monitor Service
AGSService                         Adobe Genuine Software Integrity Service
ALG                                Application Layer Gateway Service
AppIDSvc                           Application Identity
Appinfo                            Application Information
AppMgmt                            Application Management
aspnet_state                       ASP.NET 状态服务
AudioEndpointBuilder               Windows Audio Endpoint Builder
AudioSrv                           Windows Audio
AxInstSV                           ActiveX Installer (AxInstSV)
...
```


```ps
Get-Service | Where-Object {$_.displayName.Contains("File")} | Select name,DisplayName

Name                                    DisplayName
----                                    -----------
CscService                              Offline Files
EFS                                     Encrypting File System (EFS)

```

## 查看环境变量

```ps
[environment]::ExpandEnvironmentVariables("%HomeDrive%%HomePath%")

C:\Users\QS-ZY2-GXJ

[environment]::ExpandEnvironmentVariables("%Home%")

%Home%
```

## 查看文件内容并进行筛选

```ps
get-content updatelist.txt | findstr "29849"
http://support.microsoft.com/?kbid=2984972 WASYGSHA01-1050 Security Update KB2984972 WASYGSHA01-1050\adm-bchen 5/9/2017
```

## 查找字符串

```ps
findstr
```

或者可以给此命令起一个别名grep来使用

```ps
new-alias grep findstr
C:\WINDOWS> ls | grep -I -N exe
```

## 电脑关机和重启

```ps
Stop-Computer

Restart-Computer
```

## 时间相关的操作

```ps
Set-Date -Date (Get-Date).AddDays(3)
```

## 在后台打开进程

```ps
Start-Process .\HeroesSwitcher_x64.exe -WindowStyle Hidden
```

## 查看文件hash  (sha 256)

```ps
Get-FileHash -Path .\flashplayer28_xa_install.exe | Format-List

Get-FileHash -Path .\flashplayer28_xa_install.exe -Algorithm SHA1 | Format-List
```

related cmd

```cmd
certutil -hashfile filename MD5/SHA1/SHA256
```

## 获取电脑信息

### 查看computer name

```PS
Get-ComputerInfo -Property "CsName" | Format-List
```

## location

### Push-Location

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/push-location?view=powershell-6

### Pop-Location

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/pop-location?view=powershell-6

### get the key of parameters of a specified command

```ps
((Get-Command -Name Start-Resgen).Parameters).Keys
```

### New-Item

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item?view=powershell-6

在当前目录下创建一个文件

```ps
New-Item post-build.bat
```

### Get the absolute path of current location

```ps
(Get-Item .).FullName
```

https://github.com/chucklu/Scripts/blob/master/Powershell/chuck.psm1

### 获取cpu信息

```ps
Get-WMIObject win32_Processor

Caption           : Intel64 Family 6 Model 158 Stepping 9
DeviceID          : CPU0
Manufacturer      : GenuineIntel
MaxClockSpeed     : 3401
Name              : Intel(R) Core(TM) i5-7500 CPU @ 3.40GHz
SocketDesignation : U3E1

```

--

```ps
Get-WmiObject –class Win32_processor | ft systemname,Name,DeviceID,NumberOfCores,NumberOfLogicalProcessors, Addresswidth

systemname    Name          DeviceID     NumberOfCore NumberOfLogi Addresswidth
                                                    s calProcessor
                                                                 s
----------    ----          --------     ------------ ------------ ------------
ZX-OFFICE-W3  Intel(R) C... CPU0                    4            4           64

```

### 获取显卡信息

```ps
Get-WmiObject Win32_VideoController



__GENUS                      : 2
__CLASS                      : Win32_VideoController
__SUPERCLASS                 : CIM_PCVideoController
__DYNASTY                    : CIM_ManagedSystemElement
__RELPATH                    : Win32_VideoController.DeviceID="VideoController1
                               "
__PROPERTY_COUNT             : 59
__DERIVATION                 : {CIM_PCVideoController, CIM_VideoController, CIM
                               _Controller, CIM_LogicalDevice...}
__SERVER                     : ZX-OFFICE-W3
__NAMESPACE                  : root\cimv2
__PATH                       : \\ZX-OFFICE-W3\root\cimv2:Win32_VideoController.
                               DeviceID="VideoController1"
AcceleratorCapabilities      :
AdapterCompatibility         : Famatech
AdapterDACType               :
AdapterRAM                   :
Availability                 : 3
CapabilityDescriptions       :
Caption                      : Radmin Mirror Driver V3
ColorTableEntries            :
ConfigManagerErrorCode       : 0
ConfigManagerUserConfig      : False
CreationClassName            : Win32_VideoController
CurrentBitsPerPixel          : 32
CurrentHorizontalResolution  : 1280
CurrentNumberOfColors        : 4294967296
CurrentNumberOfColumns       : 0
CurrentNumberOfRows          : 0
CurrentRefreshRate           : 60
CurrentScanMode              : 4
CurrentVerticalResolution    : 1024
Description                  : Radmin Mirror Driver V3
DeviceID                     : VideoController1
DeviceSpecificPens           :
DitherType                   : 0
DriverDate                   : 20070808000000.000000-000
DriverVersion                : 3.1.0.0
ErrorCleared                 :
ErrorDescription             :
ICMIntent                    :
ICMMethod                    :
InfFilename                  : oem19.inf
InfSection                   : mirrorv3
InstallDate                  :
InstalledDisplayDrivers      :
LastErrorCode                :
MaxMemorySupported           :
MaxNumberControlled          :
MaxRefreshRate               : 75
MinRefreshRate               : 59
Monochrome                   : False
Name                         : Radmin Mirror Driver V3
NumberOfColorPlanes          :
NumberOfVideoPages           :
PNPDeviceID                  : ROOT\DISPLAY\0000
PowerManagementCapabilities  :
PowerManagementSupported     :
ProtocolSupported            :
ReservedSystemPaletteEntries :
SpecificationVersion         :
Status                       : OK
StatusInfo                   :
SystemCreationClassName      : Win32_ComputerSystem
SystemName                   : ZX-OFFICE-W3
SystemPaletteEntries         :
TimeOfLastReset              :
VideoArchitecture            : 5
VideoMemoryType              : 2
VideoMode                    :
VideoModeDescription         : 1280 x 1024 x 4294967296 colors
VideoProcessor               :
PSComputerName               : ZX-OFFICE-W3

__GENUS                      : 2
__CLASS                      : Win32_VideoController
__SUPERCLASS                 : CIM_PCVideoController
__DYNASTY                    : CIM_ManagedSystemElement
__RELPATH                    : Win32_VideoController.DeviceID="VideoController2
                               "
__PROPERTY_COUNT             : 59
__DERIVATION                 : {CIM_PCVideoController, CIM_VideoController, CIM
                               _Controller, CIM_LogicalDevice...}
__SERVER                     : ZX-OFFICE-W3
__NAMESPACE                  : root\cimv2
__PATH                       : \\ZX-OFFICE-W3\root\cimv2:Win32_VideoController.
                               DeviceID="VideoController2"
AcceleratorCapabilities      :
AdapterCompatibility         : Intel Corporation
AdapterDACType               : Internal
AdapterRAM                   : 1073741824
Availability                 : 8
CapabilityDescriptions       :
Caption                      : Intel(R) HD Graphics 630
ColorTableEntries            :
ConfigManagerErrorCode       : 0
ConfigManagerUserConfig      : False
CreationClassName            : Win32_VideoController
CurrentBitsPerPixel          :
CurrentHorizontalResolution  :
CurrentNumberOfColors        :
CurrentNumberOfColumns       :
CurrentNumberOfRows          :
CurrentRefreshRate           :
CurrentScanMode              :
CurrentVerticalResolution    :
Description                  : Intel(R) HD Graphics 630
DeviceID                     : VideoController2
DeviceSpecificPens           :
DitherType                   :
DriverDate                   : 20160630000000.000000-000
DriverVersion                : 21.20.16.4481
ErrorCleared                 :
ErrorDescription             :
ICMIntent                    :
ICMMethod                    :
InfFilename                  : oem18.inf
InfSection                   : iKBLD_w7
InstallDate                  :
InstalledDisplayDrivers      : igdumdim64.dll,igd10iumd64.dll,igd10iumd64.dll,i
                               gdumdim32,igd10iumd32,igd10iumd32
LastErrorCode                :
MaxMemorySupported           :
MaxNumberControlled          :
MaxRefreshRate               :
MinRefreshRate               :
Monochrome                   : False
Name                         : Intel(R) HD Graphics 630
NumberOfColorPlanes          :
NumberOfVideoPages           :
PNPDeviceID                  : PCI\VEN_8086&DEV_5912&SUBSYS_07A21028&REV_04\3&1
                               1583659&0&10
PowerManagementCapabilities  :
PowerManagementSupported     :
ProtocolSupported            :
ReservedSystemPaletteEntries :
SpecificationVersion         :
Status                       : OK
StatusInfo                   :
SystemCreationClassName      : Win32_ComputerSystem
SystemName                   : ZX-OFFICE-W3
SystemPaletteEntries         :
TimeOfLastReset              :
VideoArchitecture            : 5
VideoMemoryType              : 2
VideoMode                    :
VideoModeDescription         :
VideoProcessor               : Intel(R) HD Graphics Family
PSComputerName               : ZX-OFFICE-W3

```
