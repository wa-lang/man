## A. 语法规范

这里是简化的凹语言语法规范，主要是作为理解参考。

### A.1 文件结构

凹语言是一个精心设计的语言，语法非常利于理解和解析。一个凹语言文件中，顶级的语法元素只有5种：import、type、const、var以及fn。每个文件的语法规范定义如下：

```
SourceFile    = { ImportDecl ";" } { TopLevelDecl ";" } .

TopLevelDecl  = Declaration | FuncDecl | MethodDecl .
Declaration   = ConstDecl | TypeDecl | VarDecl .
```

SourceFile表示一个凹源文件，由以下两个部分组成：ImportDec（导入声明）和TopLevelDecl（顶级声明）。其中TopLevelDecl由通用声明、函数声明和方法声明组成，通用声明再分为常量、类型和变量声明。

导入语法如下：

```
ImportDecl  = "import" ( ImportSpec | "(" { ImportSpec ";" } ")" ) .
ImportSpec  = ImportPath [ "=>" PackageName ] .
ImportPath  = string_lit .

PackageName = identifier .
```

imort 关键字用于导入包，导入的包还可以被重新命名（对应PackageName）。

以下代码是一个凹源文件的对应例子：

```
// 凹语言例子

import ("a", "b")

type SomeType int
const PI = 3.14
global Length = 1 // 全局变量

func main {
	sum: int // 局部变量
	println(sum)
}
```

只要通过每行开头的不同关键字就可以明确属于那种声明类型。

### A.2 函数和方法

函数是所有编程语言中的核心，因为只有函数的语句才有了计算的功能。凹语言的函数也是一种值数据，可以定义包级别的函数，也可以为自定义的类型定义方法，同时还可以在局部作用域内定义闭包函数。在顶级声明中包含函数和方法的声明，从语法角度看函数是没有接收者参数的方法特例。

函数的语法规则如下：

```
FuncDecl     = "func" MethodName [ Signature ] [ FnBody ] .
MethodDecl = "func" Receiver "." MethodName [ Signature ] [ FnBody ] .

MethodName     = identifier .
Receiver       = identifier .
Signature      = Parameters [ "=>" Result ] .
Result         = Parameters | ":" Type .
Parameters     = "(" [ ParameterList [ "," ] ] ")" .
ParameterList  = ParameterDecl { "," ParameterDecl } .
ParameterDecl  = [ IdentifierList ] ":" [ "..." ] Type .
```

其中FnDecl表示函数，而MethodDecl表示方法。MethodDecl表示的方法规范比函数多了Receiver语法结构，Receiver表示方法的接收者参数。然后是MethodName表示的函数或方法名，Signature表示函数的签名（或者叫类型），最后是函数的主体。需要注意的是函数的签名只有输入参数和返回值部分，因此函数或方法的名字、以及方法的接收者类型都不是函数签名的组成部分。从以上定义还可以发现，Receiver、Parameters和Result都是ParameterList定义，因此有着相同的语法结构（在语法树中也是有着相同的结构）。

下面是函数和方法的常见形式：

```
# 函数声明
func()
func(x :int) => int
func(a, _ :int, z :f32) => bool
func(a, b :int, z :f32) => (bool)
func(prefix :string, values :...int)
func(a, b :int, z :f64, opt :...any) => (success bool)
func(int, int, f64) => (f64, *[]int)
func(n :int) => func(p :*T)

# 方法定义
func Person.GetName() => string { return this.name }
```

### A.3 关键字和运算符

关键字是语法的组成元素，不能用于标识符。凹语言目前有19个关键字：

```
break     defer  import     struct
case      else   interface  switch
const     for    map        type
continue  func   range      global
default   if     return
```

以下是凹语言的运算符和与标点：

```
+    &     +=    &=     &&    ==    !=    (    )
-    |     -=    |=     ||    <     <=    [    ]
*    ^     *=    ^=     <-    >     >=    {    }
/    <<    /=    <<=    ++    =     :=    ,    ;
%    >>    %=    >>=    --    !     ...   .    :
     &^          &^=                      =>
```

运算符用于组成表达式，标点用于组成或分隔语句。

### A.4 数据类型

除了布尔类型、字符、整数、浮点数、字符串等基础类型，凹语言还提供了指针、数组、切片、结构体、map、函数和接口等复合类型。复合类型的语法定义如下：

```
TypeDecl  = "type" ( TypeSpec | "(" { TypeSpec ";" } ")" ) .
TypeSpec  = AliasDecl | TypeDef .

AliasDecl = identifier "=" Type .
TypeDef   = identifier ":" Type .

Type      = TypeName | TypeLit | "(" Type ")" .
TypeName  = identifier | PackageName "." identifier .
TypeLit   = PointerType | ArrayType | SliceType
          | StructType | MapType | FnType | InterfaceType
          .
```

其中TypeDecl定义了类型声明的语法规范，可以是每个类型独立定义或通过小括弧包含按组定义。其中AliasDecl是定义类型的别名（名字和类型中间有个赋值符号），而TypeDef则是定义一个新的类型。而基础的Type就是由标识符或者是小括弧包含的其它类型表示。TypeName不仅仅可以从当前空间的标识符定义新类型，还支持从其它包导入的标识符定义类型。而TypeLit表示类型面值，比如基于已有类型的指针，或者是匿名的结构体都属于类型的面值。

下面以结构体为例展示复合类型的语法：

```
StructType     = "struct" "{" { FieldDecl ";" } "}" .
FieldDecl      = (IdentifierList ":" Type | EmbeddedField) [ Tag ] .
EmbeddedField  = [ "*" ] TypeName .
Tag            = string_lit .

IdentifierList = identifier { "," identifier } .
TypeName       = identifier | PackageName "." identifier .
```

结构体通过struct关键字开始定义，然后在大括弧中包含成员的定义。每一个FieldDecl表示一组有着相同类型和Tag字符串的标识符名字，或者是嵌入的匿名类型或类型指针。

以下是结构体的例子：

```
type MyStruct struct {
    a, b : int "int value"
    string
}
```

其中a和b成员不仅仅有着相同的int类型，同时还有着相同的Tag字符串，最后的成员是嵌入一个匿名的字符串。

### A.5 语句块和语句

语句近似看作是函数体内可独立执行的代码，语句块是由大括弧定义的语句容器，语句块和语句只能在函数体内部定义。语句块和语句是在函数体部分定义，函数体就是一个语句块。语句块的语法规范如下：

```
FnBody  = Block .

Block         = "{" StatementList "}" .
StatementList = { Statement ";" } .

Statement     = Declaration | ExpressionStmt
              | IfStmt | Block | ReturnStmt
              | ForStmt | BreakStmt | ContinueStmt
              .
```

FnBody函数体对应一个Block语句块。每个Block语句块内部由多个语句列表StatementList组成，每个语句之间通过分号分隔。语句又可分为声明语句、标签语句、普通表达式语句和其它诸多控制流语句。需要注意的是，Block语句块也是一种合法的语句，因此函数体实际上是又Block组成的多叉树结构表示，每个Block结点又可以递归保存其他的可嵌套Block的控制流等语句。

其中声明语句和表达式语句语法如下（声明语句的细节可参考语言文档，这里不做展开）：

```
Declaration  = ConstDecl | TypeDecl | VarDecl .
TopLevelDecl = Declaration | FuncDecl | MethodDecl .

ExpressionStmt = Expression .
```

下面是声明语句和表达式语句的例子：

```
const Pi = 3.14
type MyInt int32
global x = 123 // 全局变量

x = x + 1
```

if 和 return 语句的语法定义如下：

```
IfStmt         = "if" [ SimpleStmt ";" ] Expression Block [ "else" ( IfStmt | Block ) ] .
ReturnStmt     = "return" [ ExpressionList ] .
ExpressionList = Expression { "," Expression } .
```

if 和 return 语句的例子如下：

```
func main {
	if 1+1 == 2 { return }
}
```

for 循环语句的语法定义如下：

```
ForStmt     = "for" [ Condition | ForClause | RangeClause ] Block .

Condition   = Expression .

ForClause   = [ InitStmt ] ";" [ Condition ] ";" [ PostStmt ] .
InitStmt    = SimpleStmt .
PostStmt    = SimpleStmt .

RangeClause = [ ExpressionList "=" | IdentifierList ":=" ] "range" Expression .
```

循环的例子如下：

```
for {}          # 死循环
for true {}     # 死循环
for ; true ; {} # 死循环

# C 语言风格循环
for i := 0; i < 10; i++ {}

# 循环迭代列表的元素
list := make([]int, 10)
for i, v := range list {}
```

基于声明、定义、分支、循环这些基本的语句，就可以构造出任意复杂的程序。

