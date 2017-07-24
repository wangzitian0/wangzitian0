title: Golang 笔记
author: 田_田
tags:
  - Language
categories: []
date: 2016-09-04 20:50:00
---
## 基本语句
golang 的一些杂七杂八的笔记

<!-- more -->
### if
```
// 可以执行一句话之后根据结果作条件判断
if num := 9; num < 0 {
	fmt.Println(num, "is negative")
} else if num < 10 {
	fmt.Println(num, "has 1 digit")
} else {
	fmt.Println(num, "has multiple digits")
}
```

## 优美的常量
### 基本用法
```
const (
    CategoryBooks    = 0
    CategoryHealth   = 1
    CategoryClothing = 2
)

//自增长
const (
    CategoryBooks = iota // 0
    CategoryHealth       // 1
    CategoryClothing     // 2
)

```

### hint
```
const (
    _           = iota 
    // ignore first value by assigning to blank identifier
    KB ByteSize = 1 << (10 * iota) // 1 << (10*1)
    MB                                   // 1 << (10*2)
    GB                                   // 1 << (10*3)
    TB                                   // 1 << (10*4)
    PB                                   // 1 << (10*5)
    EB                                   // 1 << (10*6)
    ZB                                   // 1 << (10*7)
    YB                                   // 1 << (10*8)
)

//每一行的 iota 值是相等的
const (
    Apple, Banana = iota + 1, iota + 2
    Cherimoya, Durian
    Elderberry, Fig
)
//另外，如果一个函数以 int 作为它的参数而不是 Datatype，如果你给它传递一个 Datatype，它将在编译器期出现问题
//cannot use i (type int) as type Datatype in argument to balabala
```

## 反射
### 基本用法
```
func Info(o interface{}) {
    t := reflect.TypeOf(o)         //获取接口的类型
    fmt.Println("Type:", t.Name()) //t.Name() 获取接口的名称

    if t.Kind() != refelct.Struct { //通过Kind()来判断反射出的类型是否为需要的类型
        fmt.Println("err: type invalid!")        
        return
    }        

    v := reflect.ValueOf(o) //获取接口的值类型
    fmt.Println("Fields:")

    for i := 0; i < t.NumField(); i++ { //NumField取出这个接口所有的字段数量
    f := t.Field(i)                                   //取得结构体的第i个字段
    val := v.Field(i).Interface()                     //取得字段的值
    fmt.Printf("%6s: %v = %v\n", f.Name, f.Type, val) //第i个字段的名称,类型,值
    }

    for i := 0; i < t.NumMethod(); i++{
        m := t.Method(i)
        fmt.Printf("%6s: %v\n", m.Name,m.Type) //获取方法的名称和类型       
    }
}

```
### 通过反射改对象
```
func SetInfo(o interface{}) {
        v := reflect.ValueOf(o)

        if v.Kind() == reflect.Ptr && !v.Elem().CanSet() { //判断是否为指针类型 元素是否可以修改
            fmt.Println("cannot set")
                return
        } else {
            v = v.Elem() //实际取得的对象
        }

        //判断字段是否存在
        f := v.FieldByName("Name")
        if !f.IsValid() {
            fmt.Println("wuxiao")
                return
        }

        //设置字段
        if f := v.FieldByName("Name"); f.Kind() == reflect.String {
            f.SetString("BY")
        }
}
```
### 反射动态调用
```
//u 是一个 interface{}
v := reflect.ValueOf(u)
...
make sure v is a reflect.Struct 
mv := v.MethodByName("Hello") //获取对应的方法
...
make sure mv is exsit
res := mv.Call(args)
```

### json

#### json to struct
```
// 如果在我们不知道他的结构的情况下，我们把他解析到interface{}里面

b := []byte(`{"Name":"Wednesday","Age":6,"Parents":["Gomez","Morticia"]}`)
var f interface{}
err := json.Unmarshal(b, &f)

//结果如下
f = map[string]interface{}{
	"Name": "Wednesday",
	"Age":  6,
	"Parents": []interface{}{
		"Gomez",
		"Morticia",
	},
}

// 遍历
m := f.(map[string]interface{})

for k, v := range m {
	switch vv := v.(type) {
        // balabala
	}
}
```

#### struct to json
```
	var s Serverslice
	s.Servers = append(s.Servers, Server{ServerName: "Shanghai_VPN", ServerIP: "127.0.0.1"})
	s.Servers = append(s.Servers, Server{ServerName: "Beijing_VPN", ServerIP: "127.0.0.2"})
	b, err := json.Marshal(s)
    //  assert(balabala)
	fmt.Println(string(b))
```

#### auto marshal & unmarshal
```
type Server struct {
	// ID 不会导出到JSON中
	ID int `json:"-"`

	// ServerName2 的值会进行二次JSON编码
	ServerName  string `json:"serverName"`
	ServerName2 string `json:"serverName2,string"`

	// 如果 ServerIP 为空，则不输出到JSON串中
	ServerIP   string `json:"serverIP,omitempty"`
}

s := Server {
	ID:         3,
	ServerName:  `Go "1.0" `,
	ServerName2: `Go "1.0" `,
	ServerIP:   ``,
}
b, _ := json.Marshal(s)
os.Stdout.Write(b)
```

### rune
s:="Go编程" fmt.Println(len(s)) 输出结果应该是8因为中文字符是用3个字节存的。

len(string(rune('编')))的结果是3

如果想要获得我们想要的情况的话，需要先转换为rune切片再使用内置的len函数

fmt.Println(len([]rune(s)))


所以用string存储unicode的话，如果有中文，按下标是访问不到的，因为你只能得到一个byte。 要想访问中文的话，还是要用rune切片，这样就能按下表访问。