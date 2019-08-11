## 目标

+ 熟悉Nmap 主要参数
+ 学习 OSI 模型相关知识， 理解扫描的真正含义和原理
 
## 安装

### CentOS

```shell
wget https://nmap.org/dist/nmap-7.70-1.x86_64.rpm
```

### Debian Linux and Derivatives such as Ubuntu

```shell
sudo apt-get install alien -y

sudo alien nmap-7.70-1.x86_64.rpm 
sudo dpkg --install nmap_7.70-2_amd64.deb 
```

Steps for converting Nmap RPM files to Debian/Ubuntu deb format for installation on Debian/Ubuntu

1. If you don't have the alien command, install it with a command such as `sudo apt-get install alien`
2. Download the Nmap RPMs for your platform (x86 or x86-64) from https://nmap.org/download.html. This description will use nmap-5.21-1.x86_64.rpm
3. Verify the download integrity as described in the section called “Verifying the Integrity of Nmap Downloads”.
4. Generate a Debian package with a command such as `sudo alien nmap-5.21-1.x86_64.rpm`
5. Install the Debian package with a command such as `sudo dpkg --install nmap_5.21-2_amd64.deb`
6. Steps 2–5 can be repeated for the other `Nmap` RPMs such as `Zenmap`, `Ncat`, and `Nping`.


## 网络扫描

通过主动发送相关数据包进行网络探测，识别、分析 返回的信息，用以确认网络目标的相关特征。

### 为什么做网络扫描

安全测试中信息收集的一部分，主动探测收集目标信息，为后续的漏洞分析和利用做准备。

### Nmap 扫描常见作用

+ 查看存活主机
+ 扫描目标主机开放端口
+ 鉴别安全过滤机制
+ 识别目标主机的操作系统
+ 查看目标主机的服务的版本信息
+ 利用脚本扫描漏洞

## 功能参数分类

1. 目标说明
2. 主机发现
3. 端口扫描
4. 端口说明和扫描顺序
5. 服务与版本探测
6. 脚本扫描
7. 操作系统探测
8. 时间和性能
9. 防火墙/IDS规避和欺骗
10. 输出选项

### target specification 目标说明

```shell
TARGET SPECIFICATION:
  Can pass hostnames, IP addresses, networks, etc.
  Ex: scanme.nmap.org, microsoft.com/24, 192.168.0.1; 10.0.0-255.1-254
  -iL <inputfilename>: Input from list of hosts/networks
  -iR <num hosts>: Choose random targets
  --exclude <host1[,host2][,host3],...>: Exclude hosts/networks
  --excludefile <exclude_file>: Exclude list from file

```

+ -iL： 从主机地址列表文件中导入扫描地址
+ -iR： num hosts 表示数目，0 则无休止扫描
+ --exclude ： 排除主机
+ --excludefile： 排除列表文件中主机

### Host Discovery  主机发现

```shell
HOST DISCOVERY:
  -sL: List Scan - simply list targets to scan
  -sn: Ping Scan - disable port scan
  -Pn: Treat all hosts as online -- skip host discovery
  -PS/PA/PU/PY[portlist]: TCP SYN/ACK, UDP or SCTP discovery to given ports
  -PE/PP/PM: ICMP echo, timestamp, and netmask request discovery probes
  -PO[protocol list]: IP Protocol Ping
  -n/-R: Never do DNS resolution/Always resolve [default: sometimes]
  --dns-servers <serv1[,serv2],...>: Specify custom DNS servers
  --system-dns: Use OS's DNS resolver
  --traceroute: Trace hop path to each host

```

+ -sL ：列表扫描，不进行主机发现
+ -sn ：和 -sP 一样，只利用ping扫描进行主机发现，不扫描目标主机端口
+ -Pn ： 将所有主机视为开启状态，跳过主机发现
+ -PS ： TCP SYN ping，发送一个设置了SYN 标志位的空TCP报文，默认端口80，可指定端口
+ -PA ： TCP ACK ping， 发送一个设置了ACK 标志位的TCP报文，默认端口80，可指定端口
+ -PU ： UDP ping，发送一个空的UDP报文到指定端口，可穿透只过滤TCP的防火墙
+ -P0 ： 使用 IP 协议 ping
+ -PR ： 使用ARP ping
+ -n/-R ： -n 不用域名解析，加速扫描， -R 为目标IP 做反向域名解析，扫描较慢
+ -dns-servers： 自定义域名解析服务器地址
+ -traceroute ： 目标主机路由追踪

```shell
sudo nmap -traceroute baidu.com
Starting Nmap 7.70 ( https://nmap.org ) at 2018-10-06 22:57 PDT
Nmap scan report for baidu.com (123.125.115.110)
Host is up (0.040s latency).
Other addresses for baidu.com (not scanned): 220.181.57.216
Not shown: 998 filtered ports
PORT    STATE SERVICE
80/tcp  open  http
443/tcp open  https

TRACEROUTE (using port 443/tcp)
HOP RTT     ADDRESS
1   0.73 ms OpenWrt.lan (192.168.2.1)
2   ... 30

Nmap done: 1 IP address (1 host up) scanned in 13.70 seconds

```

### scan techniques 端口扫描

```shell
SCAN TECHNIQUES:
  -sS/sT/sA/sW/sM: TCP SYN/Connect()/ACK/Window/Maimon scans
  -sU: UDP Scan
  -sN/sF/sX: TCP Null, FIN, and Xmas scans
  --scanflags <flags>: Customize TCP scan flags
  -sI <zombie host[:probeport]>: Idle scan
  -sY/sZ: SCTP INIT/COOKIE-ECHO scans
  -sO: IP protocol scan
  -b <FTP relay host>: FTP bounce scan

```

Nmap 将目标端口分为 6 种状态

1. open 开放的
2. closed
3. filtered 被过滤的
4. unfiltered 未被过滤的，可访问但不确定开放情况
5. `.open|filtered` 开放或被过滤，无法确定端口是开放的还是被过滤的
6. `.closed|filtered` 关闭或被过滤的，无法确定端口是关闭还是被过滤的

Nmap 产生结果是基于目标机器的响应报文，而这些主机可能是不可信任的，会产生迷惑或者误导Nmap的报文。

>+ `-sS` TCP SYN 扫描，半开放扫描，速度快，隐蔽性好(不完成TCP连接)，能够明确区分端口状态
+ `-sT` TCP 连接扫描，容易产生记录，效率低
+ `-sA` TCP ACK 扫描，只设置 ACK 标志位，区别被过滤与未被过滤的
+ `-sU` UDP 服务扫描，例如 DNS/DHCP等，效率低

### port specification and scan order 端口说明和扫描顺序

```shell
PORT SPECIFICATION AND SCAN ORDER:
  -p <port ranges>: Only scan specified ports
    Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9
  --exclude-ports <port ranges>: Exclude the specified ports from scanning
  -F: Fast mode - Scan fewer ports than the default scan
  -r: Scan ports consecutively - don't randomize
  --top-ports <number>: Scan <number> most common ports
  --port-ratio <ratio>: Scan ports more common than <ratio>
```

>+ `-p` 指定扫描端口，可以是单个端口，也可以是端口范围。可以指定 TCP 或 UDP 扫描特定端口
+ `-p name` 指定扫描协议， 如 `-p http`， 可扫描 http 协议的端口状态
+ `--exclude-ports` 排除指定端口不扫描
+ `-F` 快速模式，仅扫描 100 个常用端口


### service version detection 服务与版本探测

```shell
SERVICE/VERSION DETECTION:
  -sV: Probe open ports to determine service/version info
  --version-intensity <level>: Set from 0 (light) to 9 (try all probes)
  --version-light: Limit to most likely probes (intensity 2)
  --version-all: Try every single probe (intensity 9)
  --version-trace: Show detailed version scan activity (for debugging)
```

Nmap-services 包含大量服务的数据库， Nmap通过查询该数据库可以报告那些端口可能对应于什么服务，但不一定正确

+ `-sV` 进行服务版本探测
+ `--version-intensity <level>` 设置版本扫描强度，范围 0-9，默认 7，强度越高，时间越长，服务越可能被正确识别

>+ [How to bypass tcpwrapped with nmap scan](https://security.stackexchange.com/questions/23407/how-to-bypass-tcpwrapped-with-nmap-scan)


### script scan 脚本扫描

允许用户自己编写脚本来执行自动化的操作 或扩展nmap的功能， 使用lua 脚本语言

```shell
SCRIPT SCAN:
  -sC: equivalent to --script=default
  --script=<Lua scripts>: <Lua scripts> is a comma separated list of
           directories, script-files or script-categories
  --script-args=<n1=v1,[n2=v2,...]>: provide arguments to scripts
  --script-args-file=filename: provide NSE script args in a file
  --script-trace: Show all data sent and received
  --script-updatedb: Update the script database.
  --script-help=<Lua scripts>: Show help about scripts.
           <Lua scripts> is a comma-separated list of script-files or
           script-categories.
```

+ `-sC` 使用默认类别的脚本进行扫描
+ `--script=<lua script>` 


### os detection 操作系统探测

```shell
OS DETECTION:
  -O: Enable OS detection
  --osscan-limit: Limit OS detection to promising targets
  --osscan-guess: Guess OS more aggressively
TIMING AND PERFORMANCE:
  Options which take <time> are in seconds, or append 'ms' (milliseconds),
  's' (seconds), 'm' (minutes), or 'h' (hours) to the value (e.g. 30m).
  -T<0-5>: Set timing template (higher is faster)
  --min-hostgroup/max-hostgroup <size>: Parallel host scan group sizes
  --min-parallelism/max-parallelism <numprobes>: Probe parallelization
  --min-rtt-timeout/max-rtt-timeout/initial-rtt-timeout <time>: Specifies
      probe round trip time.
  --max-retries <tries>: Caps number of port scan probe retransmissions.
  --host-timeout <time>: Give up on target after this long
  --scan-delay/--max-scan-delay <time>: Adjust delay between probes
  --min-rate <number>: Send packets no slower than <number> per second
  --max-rate <number>: Send packets no faster than <number> per second

```

>+ -O 启用操作系统探测
+ -A 同时启用操作系统探测和服务版本探测
+ `--osscan-limit` 针对指定目标进行操作系统检测
+ `--osscan-guess` 当nmap无法确定所检测操作系统时，尽可能提供最相近匹配


### timing and performance 时间和性能

nmap 开发的最高优先级是性能，但实际应用中很多因素会增加扫描时间，比如特定的扫描选项，防火墙配置，以及版本扫描等。

- `-T<0-5>` 设置时间模版级数，在0-5之间
    + T0， T1 用于 IDS规避
    + T2降低了扫描速度，以使用更少的带宽和资源
    + T3 默认。未做任何优化。
    + T4 假设具有合适以及可靠的网络从而加速扫描。
    + T5 假设具有特别快的网络或者愿意为速度牺牲准确性
- `-host-timeout <time>` 放弃低速目标主机，时间单位 为 毫秒

### firewall IDS evasion and spoofing 防火墙 IDS 规避和欺骗

```shell
FIREWALL/IDS EVASION AND SPOOFING:
  -f; --mtu <val>: fragment packets (optionally w/given MTU)
  -D <decoy1,decoy2[,ME],...>: Cloak a scan with decoys
  -S <IP_Address>: Spoof source address
  -e <iface>: Use specified interface
  -g/--source-port <portnum>: Use given port number
  --proxies <url1,[url2],...>: Relay connections through HTTP/SOCKS4 proxies
  --data <hex string>: Append a custom payload to sent packets
  --data-string <string>: Append a custom ASCII string to sent packets
  --data-length <num>: Append random data to sent packets
  --ip-options <options>: Send packets with specified ip options
  --ttl <val>: Set IP time-to-live field
  --spoof-mac <mac address/prefix/vendor name>: Spoof your MAC address
  --badsum: Send packets with a bogus TCP/UDP/SCTP checksum
```

>+ `-f` 报文分段
+ `--mtu` 使用指定的 MTU将TCP头分段在几个报中，使得包过滤器、IDS以及其他工具的检测更加困难

+ `-D <decoy1 [,decoy2] [,ME]...>` 隐蔽扫描；使用逗号分隔每个诱饵主机，用自己真实IP作为诱饵使用 ME 选项。
    - 如在6号或更后位置使用 ME选项，一些检测器就不报告真实IP 
    - 如不使用ME， 真实 IP将随机放置
+ `-S <ip address>` 伪造数据包的源地址
+ `-source-port <portnumber>/-g <portnumber>` 伪造源端口


### output 输出选项

```shell

OUTPUT:
  -oN/-oX/-oS/-oG <file>: Output scan in normal, XML, s|<rIpt kIddi3,
     and Grepable format, respectively, to the given filename.
  -oA <basename>: Output in the three major formats at once
  -v: Increase verbosity level (use -vv or more for greater effect)
  -d: Increase debugging level (use -dd or more for greater effect)
  --reason: Display the reason a port is in a particular state
  --open: Only show open (or possibly open) ports
  --packet-trace: Show all packets sent and received
  --iflist: Print host interfaces and routes (for debugging)
  --append-output: Append to rather than clobber specified output files
  --resume <filename>: Resume an aborted scan
  --stylesheet <path/URL>: XSL stylesheet to transform XML output to HTML
  --webxml: Reference stylesheet from Nmap.Org for more portable XML
  --no-stylesheet: Prevent associating of XSL stylesheet w/XML output
MISC:
  -6: Enable IPv6 scanning
  -A: Enable OS detection, version detection, script scanning, and traceroute
  --datadir <dirname>: Specify custom Nmap data file location
  --send-eth/--send-ip: Send using raw ethernet frames or IP packets
  --privileged: Assume that the user is fully privileged
  --unprivileged: Assume the user lacks raw socket privileges
  -V: Print version number
  -h: Print this help summary page.
EXAMPLES:
  nmap -v -A scanme.nmap.org
  nmap -v -sn 192.168.0.0/16 10.0.0.0/8
  nmap -v -iR 10000 -Pn -p 80

```

>+ `-oN` 标准输出
+ `-oX` XML输出写入指定的文件
+ `-oS` 脚本输出，类似于交互工具输出
+ `-oG` Grep输出
+ `-oA` 输出至所有格式
+ `-v` 提高输出信息的详细度
+ `-resume <filename>` 继续中断的扫描


## nmap 常用扫描技巧

### 扫描单一目标主机

    nmap 192.168.2.1
    nmap baidu.com
    
默认发送一个ARP 的ping包，扫描 1-10000范围内开放端口

### 扫描整个子网

    nmap 192.168.2.1/24
    nmap -sP 192.168.2.1/24

### 扫描多个目标

    nmap 192.168.2.1 baidu.com

### 扫描一个范围内的目标

    nmap 192.168.2.1-200

### 导入ip列表进行扫描

    nmap -iL ip.txt
    
要求在nmap目录

### 列举目标地址，但不扫描

    nmap -sL 192.168.2.1/24
    
### 排除特定 ip

    nmap 192.168.2.1/24 --exclude 192.168.2.1
    nmap 192.168.2.1/24 --exclude file ip.txt

### 扫描特定主机特定端口

    nmap -p80,21,8080,135 192.168.2.66
    nmap -p50-900 192.168.2.1

### 简单扫描，详细输出返回结果

    nmap -vv 192.168.0.1

### 简单扫描，并进行路由追踪

root 权限

    nmap -traceroute baidu.com

### ping 扫描，不扫描端口

root 权限

    nmap -sP 192.168.2.1
    nmap -sn 192.168.2.1

### 操作系统类型

    nmap -O 192.168.2.1

### nmap 万能开关 -A参数

    nmap -A 192.168.2.1

+ -A 包含
    + 1-10000端口ping扫描
    + 操作系统扫描
    + 脚本扫描
    + 路由跟踪
    + 服务探测

### 混合命令扫描

    nmap -vv -p1-1000 -O 192.168.2.1/24 -exclude 192.168.2.1
    
### 半开放TCP SYN 端口扫描

    nmap -sS 192.168.2.1

### 扫描 UDP 服务端口

    nmap -sU 192.168.2.1

### TCP 连接扫描端口

    nmap -sT 192.168.2.1

### -sF

由于 `IDS/IPS`系统的存在，防火墙可能会阻止掉 SYN 数据包，可发送设置了 FIN 标志的数据包，不需要完成 TCP 握手，不会在目标产生日志

    nmap -sF maintime.com

### 服务版本探测

    nmap -sV 192.168.2.1

### 图形界面版本

## nmap 脚本扫描

脚本默认目录 /usr/share/nmap/scripts

+ `-sC` 参数等价于 `-sC=default` 使用默认类别的脚本进行扫描，可更换其他脚本类别。
+ `--script-args=<n1=v1, [n2=v2,...]>`
+ `--script-args-file=filename` 使用文件为脚本提供参数
+ `--script-updated` 更新脚本数据库
+ `--script-trace` 显示脚本执行过程中所有数据的发送和接收
+ `--script-help=<scripts>` 显示脚本的帮助信息


Nmap 的脚本功能主要分为以下几类，扫描过程可以使用 `-script=类别名称`进行扫描

+ auth: 处理鉴权（绕开鉴权）的脚本
+ broadcast: 局域网内探查更多服务开启状况，如 dhcp/dns/sqlserver 等服务
+ brute: 提供暴力破解方式，针对常见应用如 http/snmp等
+ default: 使用`-sC`或`-A`选项时默认的脚本，提供基本脚本扫描能力
+ discovery: 对网络进行更多的信息，如SMB枚举，SNMP 查询等
+ dos：用于进行拒绝服务攻击
+ exploit: 利用已知漏洞入侵系统
+ external: 利用第三方的数据库或资源，类如进行whois 解析
+ fuzzer: 模糊测试的脚本， 发送异常的包到目标机，探测出潜在漏洞
+ intrusive: 入侵性的脚本，此类脚本可能引发对方的IDS/IPS的记录或屏蔽
+ malware: 探测目标机是否感染了病毒、开启了后门等信息
+ safe: 此类与 intrusive 相反，属于安全性脚本
+ version: 负责增强服务与版本扫描(Version Detection) 功能的脚本
+ vuln：负责检查目标机是否有常见的漏洞(Vulnerability),如是否有MS08_067

#### 实例

auth 类脚本，处理鉴权证书方便脚本，也可以作为部分弱口令检测

    nmap --script=auth target_ip
    
默认脚本扫描

    nmap -sC target_ip

扫描是否存在常见漏洞

    nmap --script=vuln target_ip
    
在局域网内扫描更多的端口开启情况

    nmap -n -p135 --script=broadcase target_ip





## info

+ [网络安全 Nmap专题](https://www.youtube.com/playlist?list=PLGmd9-PCMLhbKWaZoZ83Lq6xa0TK_XslC)
+ [官网](https://nmap.org/)