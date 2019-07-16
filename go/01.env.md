
## ubuntu

## install go

+ https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz

```shell
sudo apt-get update
sudo apt-get -y upgrade
wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
sudo tar -xvf go1.12.6.linux-amd64.tar.gz
sudo mv go /usr/local/src


```

### Setup Go Environment

+ __GOROOT__ is the location where Go package is installed on your system.
+ __GOPATH__ is the location of your work directory.
+ __PATH__ for access go binary system wide


```shell
export GOROOT=/usr/local/src/go
export GOPATH=$HOME/work/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

### Verify Installation

```shell
$ go version
go version go1.12.6 linux/amd64

$ go env
GOARCH="amd64"
GOBIN=""
GOCACHE="/home/vicky/.cache/go-build"
GOEXE=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/home/vicky/work/Projects/Proj1"
GOPROXY=""
GORACE=""
GOROOT="/usr/local/src/go"
GOTMPDIR=""
GOTOOLDIR="/usr/local/src/go/pkg/tool/linux_amd64"
GCCGO="gccgo"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD=""
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build584580789=/tmp/go-build -gno-record-gcc-switches"


go get golang.org/x/tour
```

>+ `$GOROOT` 表示 Go 在你的电脑上的安装位置，它的值一般都是 `$HOME/go`，当然，你也可以安装在别的地方。
+ `$GOARCH` 表示目标机器的处理器架构，它的值可以是 386、amd64 或 arm。
+ `$GOOS` 表示目标机器的操作系统，它的值可以是 darwin、freebsd、linux 或 windows。
+ `$GOBIN` 表示编译器和链接器的安装位置，默认是 `$GOROOT/bin`，如果你使用的是 Go1.0.3 及以后的版本，一般情况下你可以将它的值设置为空，Go 将会使用前面提到的默认值。


Go 编译器支持交叉编译，也就是说你可以在一台机器上构建运行在具有不同操作系统和处理器架构上运行的应用程序，也就是说编写源代码的机器可以和目标机器有完全不同的特性（操作系统与处理器架构）。

为了区分本地机器和目标机器，你可以使用 `$GOHOSTOS` 和 `$GOHOSTARCH` 设置本地机器的操作系统名称和编译体系结构，这两个变量只有在进行交叉编译的时候才会用到，如果你不进行显示设置，他们的值会和本地机器（`$GOOS` 和 `$GOARCH`）一样。


+ `$GOPATH` 默认采用和 `$GOROOT` 一样的值，但从 Go1.1 版本开始，你必须修改为其它路径。它可以包含多个包含 Go 语言源码文件、包文件和可执行文件的路径，而这些路径下又必须分别包含三个规定的目录：`src`、`pkg` 和 `bin`，这三个目录分别用于存放源码文件、包文件和可执行文件。
+ `$GOARM` 专门针对基于 `arm` 架构的处理器，它的值可以是 5 或 6，默认为 6。
+ `$GOMAXPROCS` 用于设置应用程序可使用的处理器个数与核数。

## 安装目录清单

你的 Go 安装目录（`$GOROOT`）的文件夹结构应该如下所示：

README.md, AUTHORS, CONTRIBUTORS, LICENSE

+ `/bin`：包含可执行文件，如：编译器，Go 工具
+ `/doc`：包含示例程序，代码工具，本地文档等
+ `/lib`：包含文档模版
+ `/misc`：包含与支持 Go 编辑器有关的配置文件以及 cgo 的示例
+ `/os_arch`：包含标准库的包的对象文件（`.a`）
+ `/src`：包含源代码构建脚本和标准库的包的完整源代码（Go 是一门开源语言）
+ `/src/cmd`：包含 Go 和 C 的编译器和命令行脚本

## 安装 C 工具

## vscode

```shell
go get -v github.com/ramya-rao-a/go-outline

go get -v github.com/mdempsky/gocode

go get -v github.com/uudashr/gopkgs/cmd/gopkgs
go get -v github.com/sqs/goreturns
go get -v github.com/rogpeppe/godef
```

+ [生成代码文档](https://github.com/oldnicke/Go-Getting-Started-Guide/blob/master/eBook/03.6.md)

## 关键字

```shell
break	default	func	interface	select
case	defer	go	map	struct
chan	else	goto	package	switch
const	fallthrough	if	range	type
continue	for	import	return	var
```

36 个预定义标识符

```shell
append	bool	byte	cap	close	complex	complex64	complex128	uint16
copy	false	float32	float64	imag	int	int8	int16	uint32
int32	int64	iota	len	make	new	nil	panic	uint64
print	println	real	recover	string	true	uint	uint8	uintptr

```


## 相关资料

+ https://github.com/oldnicke/Go-Getting-Started-Guide/blob/master/eBook/01.1.md