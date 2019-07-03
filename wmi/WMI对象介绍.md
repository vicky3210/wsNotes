
```powershell
get-wmiObject -list -namespace "root\CIMV2"

   NameSpace:ROOT\CIMV2

Name                                Methods              Properties
----                                -------              ----------
CIM_Indication                      {}                   {CorrelatedIndications, IndicationFilterName, IndicationIde...
CIM_ClassIndication                 {}                   {ClassDefinition, CorrelatedIndications, IndicationFilterNa...
CIM_ClassDeletion                   {}                   {ClassDefinition, CorrelatedIndications, IndicationFilterNa...
CIM_ClassCreation                   {}                   {ClassDefinition, CorrelatedIndications, IndicationFilterNa...
CIM_ClassModification               {}                   {ClassDefinition, CorrelatedIndications, IndicationFilterNa...
  ...
```

## 查看某个类的成员，使用下面的命令(例如类"win32_process")：

每个有的成员是属性(Property)，而有的则是方法(Method)。

```powershell
get-wmiobject -class win32_process -namespace "root\cimv2" | get-member

   TypeName:System.Management.ManagementObject#root\cimv2\Win32_Process

Name                       MemberType     Definition
----                       ----------     ----------
Handles                    AliasProperty  Handles = Handlecount
ProcessName                AliasProperty  ProcessName = Name
PSComputerName             AliasProperty  PSComputerName = __SERVER
VM                         AliasProperty  VM = VirtualSize
WS                         AliasProperty  WS = WorkingSetSize
AttachDebugger             Method         System.Management.ManagementBaseObject AttachDebugger()
GetOwner                   Method         System.Management.ManagementBaseObject GetOwner()
GetOwnerSid                Method         System.Management.ManagementBaseObject GetOwnerSid()
SetPriority                Method         System.Management.ManagementBaseObject SetPriority(System.Int32 Priority)
Terminate                  Method         System.Management.ManagementBaseObject Terminate(System.UInt32 Reason)
Caption                    Property       string Caption {get;set;}
CommandLine                Property       string CommandLine {get;set;}
CreationClassName          Property       string CreationClassName {get;set;}
...
```

### 为什么要使用-namespace "root\cimv2"？

cimv2是WMI的一个命名空间，每个命名空间下有不同的WMI对象成员。cimv2是其默认设置。可以按照以下步骤进行修改：

```
控制面板 -> 管理工具 -> 计算机管理 -> 服务和应用程序 -> 右键"WMI控件" -> 属性 -> 高级
```

参数"-namespace"并非必须，但是，使用它有两个好处，一是保证我们能准确的查看指定命名空间下的WMI对象，因为有时默认命名空间并非我们所希望查看的；二是如果不指定命名空间，被设置过的计算机可能拒绝我们的访问请求。

### 查看成员的类型有什么用？

如果一个成员是方法，那么，我们可以调用它。如果一个成员是属性，我们则可以查看它的值。但是，需要注意的是，不同的属性成员有不同的数据结构，有的是"System.String"，有的是"System.UInt32"，有的则是"System.String[ ]"，在使用时，应当注意数据格式，否则会报错的。

如果我们需要管理网络中的计算机，则需要指定计算机名称：

```powershell
get-wmiObject -list -namespace “root\CIMV2″ -computername 计算机名 <enter>
```

## 实例

### 查看BIOS信息

```powersehll
get-wmiobject -class win32_bios -namespace "root\cimv2"

SMBIOSBIOSVersion : 1.7.9
Manufacturer      : Dell Inc.
Name              : BIOS Date: 01/30/18 21:10:39 Ver: 1.7.9
SerialNumber      : 7HSPXP2
Version           : DELL   - 1072009

```

### 查看服务信息

```powersehll
// 查看机器信息
get-wmiobject -class win32_service -namespace "root\cimv2" | format-list *

...
PSComputerName          : ZX-OFFICE-W3
Name                    : wudfsvc
Status                  : OK
ExitCode                : 0
DesktopInteract         : False
ErrorControl            : Normal
PathName                : C:\windows\system32\svchost.exe -k LocalSystemNetworkRestricted
ServiceType             : Share Process
StartMode               : Auto
__GENUS                 : 2
__CLASS                 : Win32_Service
__SUPERCLASS            : Win32_BaseService
__DYNASTY               : CIM_ManagedSystemElement
__RELPATH               : Win32_Service.Name="wudfsvc"
__PROPERTY_COUNT        : 25
__DERIVATION            : {Win32_BaseService, CIM_Service, CIM_LogicalElement, CIM_ManagedSystemElement}
__SERVER                : ZX-OFFICE-W3
__NAMESPACE             : root\cimv2
__PATH                  : \\ZX-OFFICE-W3\root\cimv2:Win32_Service.Name="wudfsvc"
AcceptPause             : False
AcceptStop              : False
Caption                 : Windows Driver Foundation - User-mode Driver Framework
CheckPoint              : 0
CreationClassName       : Win32_Service
Description             : 管理用户模式的驱动程序主机进程。
DisplayName             : Windows Driver Foundation - User-mode Driver Framework
InstallDate             :
ProcessId               : 1016
ServiceSpecificExitCode : 0
Started                 : True
StartName               : LocalSystem
State                   : Running
SystemCreationClassName : Win32_ComputerSystem
SystemName              : ZX-OFFICE-W3
TagId                   : 0
WaitHint                : 0
Scope                   : System.Management.ManagementScope
Path                    : \\ZX-OFFICE-W3\root\cimv2:Win32_Service.Name="wudfsvc"
Options                 : System.Management.ObjectGetOptions
ClassPath               : \\ZX-OFFICE-W3\root\cimv2:Win32_Service
Properties              : {AcceptPause, AcceptStop, Caption, CheckPoint...}
SystemProperties        : {__GENUS, __CLASS, __SUPERCLASS, __DYNASTY...}
Qualifiers              : {dynamic, Locale, provider, UUID}
Site                    :
Container               :

...
```

具体信息

```powersehll
get-wmiobject -class win32_computersystem | format-list * <enter>

PSComputerName              : ZX-OFFICE-W3
AdminPasswordStatus         : 3
BootupState                 : Normal boot
ChassisBootupState          : 3
KeyboardPasswordStatus      : 3
PowerOnPasswordStatus       : 3
PowerSupplyState            : 3
PowerState                  : 0
FrontPanelResetStatus       : 3
ThermalState                : 3
Status                      : OK
Name                        : ZX-OFFICE-W3
PowerManagementCapabilities :
PowerManagementSupported    :
__GENUS                     : 2
__CLASS                     : Win32_ComputerSystem
__SUPERCLASS                : CIM_UnitaryComputerSystem
__DYNASTY                   : CIM_ManagedSystemElement
__RELPATH                   : Win32_ComputerSystem.Name="ZX-OFFICE-W3"
__PROPERTY_COUNT            : 58
__DERIVATION                : {CIM_UnitaryComputerSystem, CIM_ComputerSystem, CIM_System, CIM_LogicalElement...}
__SERVER                    : ZX-OFFICE-W3
__NAMESPACE                 : root\cimv2
__PATH                      : \\ZX-OFFICE-W3\root\cimv2:Win32_ComputerSystem.Name="ZX-OFFICE-W3"
AutomaticManagedPagefile    : True
AutomaticResetBootOption    : False
AutomaticResetCapability    : True
BootOptionOnLimit           :
BootOptionOnWatchDog        :
BootROMSupported            : True
Caption                     : ZX-OFFICE-W3
CreationClassName           : Win32_ComputerSystem
CurrentTimeZone             : 480
DaylightInEffect            :
Description                 : AT/AT COMPATIBLE
DNSHostName                 : ZX-office-W3
Domain                      : WORKGROUP
DomainRole                  : 0
EnableDaylightSavingsTime   : True
InfraredSupported           : False
InitialLoadInfo             :
InstallDate                 :
LastLoadInfo                :
Manufacturer                : Dell Inc.
Model                       : OptiPlex 5050
NameFormat                  :
NetworkServerModeEnabled    : True
NumberOfLogicalProcessors   : 4
NumberOfProcessors          : 1
OEMLogoBitmap               :
OEMStringArray              : {Dell System, 1[07A2], 3[1.0], 12[www.dell.com]...}
PartOfDomain                : False
PauseAfterReset             : -1
PCSystemType                : 1
PrimaryOwnerContact         :
PrimaryOwnerName            : AutoBVT
ResetCapability             : 1
ResetCount                  : -1
ResetLimit                  : -1
Roles                       : {LM_Workstation, LM_Server, NT, Potential_Browser...}
SupportContactDescription   :
SystemStartupDelay          :
SystemStartupOptions        :
SystemStartupSetting        :
SystemType                  : x64-based PC
TotalPhysicalMemory         : 4152328192
UserName                    : ZX-OFFICE-W3\QS-ZY2-GXJ
WakeUpType                  : 6
Workgroup                   : WORKGROUP
Scope                       : System.Management.ManagementScope
Path                        : \\ZX-OFFICE-W3\root\cimv2:Win32_ComputerSystem.Name="ZX-OFFICE-W3"
Options                     : System.Management.ObjectGetOptions
ClassPath                   : \\ZX-OFFICE-W3\root\cimv2:Win32_ComputerSystem
Properties                  : {AdminPasswordStatus, AutomaticManagedPagefile, AutomaticResetBootOption, AutomaticResetC
                              apability...}
SystemProperties            : {__GENUS, __CLASS, __SUPERCLASS, __DYNASTY...}
Qualifiers                  : {dynamic, Locale, provider, UUID}
Site                        :
Container                   :

```

### 网络管理环境中查看不同的计算机信息

查询本地计算机的网络信息

```powersehll
$name="."
$items = get-wmiObject -class win32_NetworkAdapterConfiguration  -namespace "root\CIMV2" -ComputerName $name | where{$_.IPEnabled -eq "True"}  
foreach($obj in $items) {  
  Write-Host "DHCP Enabled:" $obj.DHCPEnabled  
  Write-Host "IP Address:" $obj.IPAddress  
  Write-Host "Subnet Mask:" $obj.IPSubnet  
  Write-Host "Gateway:" $obj.DefaultIPGateway  
  Write-Host "MAC Address:" $ojb.MACAddress  
}
```

DHCP

```powersehll
$name="."
$items = get-wmiObject -class win32_NetworkAdapterConfiguration  -namespace "root\CIMV2" -ComputerName $name | where{$_.DHCPEnabled -eq "True"}  
foreach($obj in $items) {  
  Write-Host "DHCP Enabled:" $obj.DHCPEnabled  
  Write-Host "IP Address:" $obj.IPAddress  
  Write-Host "Subnet Mask:" $obj.IPSubnet  
  Write-Host "Gateway:" $obj.DefaultIPGateway  
  Write-Host "MAC Address:" $ojb.MACAddress  
}

```

>Result
```
DHCP Enabled: True
IP Address: 192.168.11.103 fe80::d4d0:a9c0:5729:2c04
Subnet Mask: 255.255.255.0 64
Gateway: 192.168.11.1
MAC Address:
```


```powershell
$name=read-host "Enter Computer Name"
write-host "Computer:"$name
$items = get-wmiObject -class win32_NetworkAdapterConfiguration '
-namespace "root\CIMV2" -ComputerName $name | where{$_.IPEnabled -eq “True”}
foreach($obj in $items) {  
  Write-Host "DHCP Enabled:" $obj.DHCPEnabled  
  Write-Host "IP Address:" $obj.IPAddress  
  Write-Host "Subnet Mask:" $obj.IPSubnet  
  Write-Host "Gateway:" $obj.DefaultIPGateway  
  Write-Host "MAC Address:" $ojb.MACAddress  
}
```

>refer
+ [WMI对象介绍](https://www.jb51.net/article/32468.htm)
