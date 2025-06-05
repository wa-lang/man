## B. 标准库

包含 apple、builtin、errors、regexp、runtime、syscall 等包的简要说明。

### B.1 apple - 苹果派

apple 包用于展示最简单的包和测试的构造。

#### B.1.1 函数

```wa
func Apple => string
```

- Apple 返回苹果的字符串

### B.2 builtin - 内置包

凹语言中 `bool`、`int`、`string` 和 `println` 等都不是关键字，而是编译器内置的包定义。`builtin` 包中定义的名字都是小写字母开头，不需要 `import` 就可以使用。

#### B.2.1 类型

- bool：布尔类似
- u8：8比特无符号整数
- u16：16比特无符号整数
- u32：32比特无符号整数
- u64：64比特无符号整数
- i32：32比特有符号整数
- i64：64比特有符号整数
- int：有符号整数
- uint；无符号整数
- f32：IEEE754 单精度浮点数
- f64：IEEE754 双精度浮点数
- string：UTF8 编码的字符串
- rune：字符，底层为 i32
- byte：字节，底层为 u8
- error：错误接口

#### B.2.2 常量

- nil：空引用，可以用于切片、接口的比较。

#### B.2.3 函数

```wa
func print(args: ...Type)
func println(args: ...Type)

func new(Type) => *Type
func make(t: Type, size: ...IntegerType) => Type

func len(v: Type) => int
func cap(v: Type) => int

func append(slice: []Type, elems: ...Type) => []Type
func copy(dst, src: []Type) => int

func panic(msg: string)
```

- print：打印基础类型
- println：打印基础类型并换行
- new：创新一个 Type 的实体并返回引用
- make：创建切片，并返回引用
- len：获取数组、切片、字符串等类型值的元素长度
- cap：获取数组、切片的容量
- append：向切片添加元素
- copy：赋值切片
- panic：泡出异常

### B.3 errors - 错误包

errors 包用于创新一个可以表示字符串信息的错误对象。

#### B.3.1 函数

```wa
func New(text: string) => error
```

- New 创建一个错误对象

### B.4 regexp - 正则包

正则包是 Rob Pike 最小正则实现：[https://www.cs.princeton.edu/courses/archive/spr09/cos333/beautiful.html](https://www.cs.princeton.edu/courses/archive/spr09/cos333/beautiful.html)

#### B.4.1 函数

```wa
func Match(regexp, text: string) => bool
```

### B.5 runtime - 运行时包

凹语言运行时类型和函数的实现。

#### B.5.1 常量

```wa
const WAOS = "..."
```

- WAOS：凹语言目标OS名字，目前有 wasi、mvp 等


### B.6 syscall - 系统调用包

凹语言不同目标平台提供的系统调用。通常是 runtime 或其他包封装 syscall 包的函数。

