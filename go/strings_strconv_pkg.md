
## strings 和 strconv 包

作为一种基本数据结构，每种语言都有一些对于字符串的预定义处理函数。Go 中使用 strings 包来完成对字符串的主要操作。

### 前缀和后缀

`HasPrefix` 判断字符串 s 是否以 `prefix` 开头：

    strings.HasPrefix(s, prefix string) bool

`HasSuffix` 判断字符串 s 是否以 `suffix` 结尾：

    strings.HasSuffix(s, suffix string) bool

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	var str string = "This is an example of a string"
	fmt.Printf("T/F? Does the string \"%s\" have prefix %s? ", str, "Th")
	fmt.Printf("%t\n", strings.HasPrefix(str, "Th"))
}
```

输出：

    T/F? Does the string "This is an example of a string" have prefix Th? true


### 字符串包含关系

`Contains` 判断字符串 s 是否包含 `substr：`

    strings.Contains(s, substr string) bool

### 判断子字符串或字符在父字符串中出现的位置（索引）

`Index` 返回字符串 str 在字符串 s 中的索引（str 的第一个字符的索引），`-1` 表示字符串 s 不包含字符串 str：

    strings.Index(s, str string) int

`LastIndex` 返回字符串 str 在字符串 s 中最后出现位置的索引（str 的第一个字符的索引），`-1` 表示字符串 s 不包含字符串 str：

    strings.LastIndex(s, str string) int

如果需要查询非 ASCII 编码的字符在父字符串中的位置，建议使用以下函数来对字符进行定位：

    strings.IndexRune(s string, r rune) int


### 字符串替换

`Replace` 用于将字符串 str 中的前 n 个字符串 old 替换为字符串 new，并返回一个新的字符串，如果 `n = -1` 则替换所有字符串 old 为字符串 new：

    strings.Replace(str, old, new, n) string

### 统计字符串出现次数

`Count` 用于计算字符串 str 在字符串 s 中出现的非重叠次数：

    strings.Count(s, str string) int

### 重复字符串

`Repeat` 用于重复 count 次字符串 s 并返回一个新的字符串：

    strings.Repeat(s, count int) string

### 修改字符串大小写

`ToLower` 将字符串中的 Unicode 字符全部转换为相应的小写字符：

    strings.ToLower(s) string

`ToUpper` 将字符串中的 Unicode 字符全部转换为相应的大写字符：

    strings.ToUpper(s) string

### 修剪字符串
你可以使用 `strings.TrimSpace(s)` 来剔除字符串开头和结尾的空白符号；如果你想要剔除指定字符，则可以使用 `strings.Trim(s, "cut")` 来将开头和结尾的 cut 去除掉。该函数的第二个参数可以包含任何字符，如果你只想剔除开头或者结尾的字符串，则可以使用 `TrimLeft` 或者 `TrimRight` 来实现。

### 分割字符串

`strings.Fields(s)` 将会利用 1 个或多个空白符号来作为动态长度的分隔符将字符串分割成若干小块，并返回一个 slice，如果字符串只包含空白符号，则返回一个长度为 0 的 slice。

`strings.Split(s, sep)` 用于自定义分割符号来对指定字符串进行分割，同样返回 slice。

因为这 2 个函数都会返回 slice，所以习惯使用 `for-range` 循环来对其进行处理。

### 拼接 slice 到字符串

`Join` 用于将元素类型为 string 的 slice 使用分割符号来拼接组成一个字符串：

    strings.Join(sl []string, sep string) string

```go
package main

import (
	"fmt"
	"strings"
)

func main() {
	str := "The quick brown fox jumps over the lazy dog"
	sl := strings.Fields(str)
	fmt.Printf("Splitted in slice: %v\n", sl)
	for _, val := range sl {
		fmt.Printf("%s - ", val)
	}
	fmt.Println()
	str2 := "GO1|The ABC of Go|25"
	sl2 := strings.Split(str2, "|")
	fmt.Printf("Splitted in slice: %v\n", sl2)
	for _, val := range sl2 {
		fmt.Printf("%s - ", val)
	}
	fmt.Println()
	str3 := strings.Join(sl2,";")
	fmt.Printf("sl2 joined by ;: %s\n", str3)
}
```

输出：

```
Splitted in slice: [The quick brown fox jumps over the lazy dog]
The - quick - brown - fox - jumps - over - the - lazy - dog -
Splitted in slice: [GO1 The ABC of Go 25]
GO1 - The ABC of Go - 25 -
sl2 joined by ;: GO1;The ABC of Go;25
```


