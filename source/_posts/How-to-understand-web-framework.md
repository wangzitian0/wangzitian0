title: 如何理解Web框架
author: 田_田
tags:
  - HTML
  - Framwork
categories: []
date: 2017-06-19 13:21:00
---
Web 应用框架，或者简单的说是“Web 框架”，是建立 web 应用的一种方式。在此之前希望已经了解这篇文章的内容 [HTTP协议的的最佳实践RESTful](https://wangzitian0.github.io/2017/06/16/HTTP协议的的最佳实践RESTful/)。

<!-- more -->

## 为什么会需要框架
很多人把会一个框架当做 web 工程师的必要条件，但是实际上的理解并不到位。要真的理解框架，需要理解下面的这些东西。
web 技术的发展其实是有这样一个路径的：
```
源码<->最佳实践<->设计模式
协议->SDK->类库->框架->架构
```
## 虚路径

### 最佳实践
```
最佳实践(best practice)，是一个管理学概念，
认为存在某种技术、方法、过程、活动或机制可以使生产或管理实践的结果达到最优，并减少出错的可能性。
```

典型的例子如 [缓存更新的套路](http://coolshell.cn/articles/17416.html)。
大致是说”先删除缓存，然后再更新数据库，而后续的操作会把数据再装载的缓存中。“是逻辑是错误的。

两个并发操作，一个是更新操作，另一个是查询操作。更新操作删除缓存后，查询和操作同时发生，且同时艹库，如果是先更新，后查询的没有问题。但是如果先查询完成后更新完成，查询结果被缓存导致缓存中的数据是脏的，而且还一直这样脏下去了。

最常用最常用的缓存实践，对于绝大多数应用使用这个方案就够了：
```
失效：应用程序先从cache取数据，没有得到，则从数据库中取数据，成功后，放到缓存中。
命中：应用程序从cache中取数据，取到后返回。
更新：先把数据存到数据库中，成功后，再让缓存失效。
```

这种做法还是有可能有脏数据，那就是数据库更新完成之后，缓存失效之前，但是这种数据最多脏这一小会，宏观上可以接受，大部分应用少数几秒的一致性降低不会导致用户体验变差。

缓存更新的实践是非常老古董的，而且历经长时间考验的策略，从mysql数据库到memcache/redis，很多东西是计算机体系结构里的设计。类似的还有CPU的缓存，硬盘文件系统中的缓存，硬盘上的缓存，数据库中的缓存。

进一步要求，有的时候这种设计经常某一瞬间穿透缓存，满足不了需求的时候，可以用一个队列来分开读写，把压力强行挡在数据库外面。

工程学上所谓的Best Practice有些东西需要细想才会发现精巧。


### 设计模式
```
设计模式（Design pattern）代表了最佳的实践，通常被有经验的面向对象的软件开发人员所采用。
设计模式是软件开发人员在软件开发过程中面临的一般问题的解决方案。
这些解决方案是众多软件开发人员经过相当长的一段时间的试验和错误总结出来的。
```
最佳实践进一步抽象就是设计模式，有些东西已经编程语言或者框架已经实现了，所以我们并不需要完完全全了解实现原理，只需看看文档就能使用。只说说我印象深刻的几个：

#### 观察者模式
意图：定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新。

几乎大家都知道或者用过 MVC 模式，本质上就是一个观察者模式和其他模式结合的的高级抽象。实质上还是把数据和行为进行分离，M其实也相当于观察者模式中的被观察者，Ｖ相当于观察者。

#### 代理模式
意图：创建具有现有对象的对象，以便向外界提供功能接口。为其他对象提供一种代理以控制对这个对象的访问。

MySQL 设计的时候会有 oneToOneField，提供一个外键来访问某个对象。

#### 装饰器模式
意图：动态地给一个对象添加一些额外的职责。就增加功能来说，装饰器模式相比生成子类更为灵活。

做一个事情前和后分别加点事情，给一个对象添加一些额外的方法，而且可以不改变调用方。不用把新的逻辑注入到原始代码里。

#### 中介模式
意图：用一个中介对象来封装一系列的对象交互，中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。

比如 RPC 框架做一些基础服务，帮助开发者看哪些服务活着，压力如何，然后分配流量，又比如 web 框架里的中间件，所以的请求都需要经过一遍中间件，有效的减少层与层之间的交叉调用。

其他的去看书吧… 总之，设计模式&最佳实践&代码是相互作用的，相互促进螺旋上升，随着计算机学科的发展大致变成了现在的样子。这几年互联网架构的发展，本质上还是这些模式，但是形式变成了在廉价集群上实现，重点变成了兼容不可靠设备。

## 实路径

### 协议
```
网络传输协议或简称为传送协议（Communications Protocol），是指计算机通信或網路設備的共同语言。 
现在最普及的计算机通信为网络通信，所以“传送协议”一般都指计算机通信的传送协议。
如：TCP/IP、NetBEUI、DHCP、FTP等。
```
TCP 之类就不说了，资料太多了。拿序列化这件事情来说，有了协议，各种语言才会无障碍通信。内存对象包含各种地址和指针，传输和存储的试试需要去除这种机器相关的影响，只关注数据和数据的关联，转化为字符串，这个过程叫做序列化。字符串变成内存里的可执行可操作的对象，叫做反序列化。

Json 是序列化协议，XML 是序列化协议，而且对人类友好，数据的结构可以肉眼轻松的看出来。

ProtoBuf 和 Thrift 也是序列化协议，但是底层使用更高效的二进制协议，而且官方有 gRPC 框架和Thrift RPC框架来帮助开发者做一些诸如服务发现、负载均衡的工作，能够很好的减少前后端之间数据交换、各种基础计算服务调用的麻烦程度。
- [Json怎么写](http://jsonapi.org.cn/format/)
- [XML怎么写](http://www.jianshu.com/p/xNasBo)
- [ProtoBuf怎么写](http://www.iloveandroid.net/2015/10/08/studyPtorobuf/)
- [Thrift怎么写](http://dongxicheng.org/search-engine/thrift-guide/)

协议本身制定是为了更好的序列化反序列化，又比如 http 协议，公认的最佳实践是 restful API，可以看看开篇介绍的另一篇博客。

又比如HTML5的协议，由 RFC 文件来规定，由浏览器厂商来执行。典型的HTML 协议文档可以看 [Mozilla的文档](https://developer.mozilla.org/zh-CN/docs/Web/Guide/HTML/HTML5)


### SDK
```
软件开发工具包（Software Development Kit, SDK）一般是一些被软件工程师用于为特定的软件包、软件框架、硬件平台、作業系统等建立应用软件的开发工具的集合。
```
典型的如 [安卓SDK](https://developer.android.com/studio/index.html)

里面包括很多的工具、API文档、本地编译包、IDE 等等很多东西。根据官方文档的描述，开发必须下载的东西有：
```
SDK Tools 必须
SDK Platform-tools 必须
SDK Platform必须至少安装一个版本
System Image建议安装
Android Support建议安装
SDK Samples建议安装
```
开源世界目前以 Github 为核心，模式稍微有一些变化。SDK 被拆解到各个地方，比如 npm 来帮助管理各种依赖和版本，然后文档直接放到 Github 相关的文档里，源码直接使用 git 下载而不一定发布打包集成版。

### 类库
```
类库(Class Library)是一个综合性的面向对象的可重用类型集合，这些类型包括：接口、抽象类和具体类。
```
写过 C++ 的人都一定熟悉STL，集成了常用的内存数据结构和常用算法。实现的效率都不错，接口也很通用。有了这些类库，很多重复性的工作被省略。

写 JavaScript 的程序员有一部分是只会 jQuery 的，由于 jQuery 的封装十分简单，且给每个对象都加入了一些常用的方法，不需要再去记复杂的 api，大大提高了开发效率。

刚才两个例子都是外部实现的标准组件，STL 根据编译器配置不同可以使用 Boost 或者 SGI 版本，g++ 编译器支持一套 linux 上肯定能跑的 STL。jQuery 干脆直接由程序员自己来引入，本身完全没有放入 JavaScript 体系。

有一个神奇的存在，那就是 Golang，你可以先看看 [Golang Libs 文档](http://studygolang.com/pkgdoc)，由于 Golang 是一个完全现代化的语言，出现时间晚，因此很多 web 世界用到的东西，直接被官方支持的类库收录和实现了。包括不限于用来控制并发的互斥锁，用来数据共享管道channel，自带的json序列化反序列化工具等等。第三方实现的东西往往没有语言原生就实现靠谱和稳定，正因如此 golang 在 web 开发世界迅速崛起。

一般来说，我们说一个语言的生态好不好，主要是指它的类库多不多，其次才看对应的文档是否充要&社区是否活跃。

### 框架
```
Web应用框架（Web application framework）是一种开发框架，用来支持动态网站、网络应用程序及网络服务的开发。
```
按照我的理解，框架和类库最重要的区别是控制权的不同。

使用框架像是装饰一颗圣诞树，树干在那个地方且已经定型，你能做的就是往上面装东西，使它能完成装饰的作用。而类库是为了解决重复性工作的方法和工具，装饰圣诞树的时候需要批量给礼物打包、分类、挂上钩子，类库就像是能快速整洁的打包工具、扔进去礼物就会打乱的桶、批量把钢丝捏成钩子的钳子。

web 开发来说，框架的控制权在框架手上，你是按照框架的体系和规范去往里面添加东西，由它来调用你的代码。类库的控制权在你手中，类库只是帮你封装好了大量实用的函数，帮助你实现自己的目的，你通过调用类库来避免重复造轮子。

两者都是为了提高自己的研发效率，但是是不同的层面，类库和框架一般都是混合在一起用的。

框架涉及到一个流派之争Rails Like vs Sinatra Like

#### Rails Like
典型代表: Rails(Ruby), Django(Python), Sails(JavaScript), Revel(Golang)
- 编程要爽。可以甩锅给工具的事情就不要接，应该专注于造东西，快速的做出 MVP 的产品。例子：写好配置，帮你生成基本的增删改查API，你不需要去想 SQL 怎么写比较优美。
- 约定优于配置（CoC），主张大部分都这么做，那框架就这么做吧，有问题你自己去该配置得了。例子：数据库的模型叫做 Problem，那么模板就放problem_tmp，业务放在 ProblemView 里面，你可以填充自动生成的migration文件，然后数据库里存的表名默认使用 problem_migration1。
- 主厨精选。吃饭要相信营养大师的选择，web 开发也一样，大师你默认给我个全家桶吧。例子：ORM 直接由框架提供好了，数据库由大师去做匹配，然后支持常见的关系型数据库。


#### Sinatra Like

典型代表 Sinatra(Ruby), Flask(Python), Express(JavaScript), Gin(Golang)
- 编程要自由。我想怎么用其他的库就怎么用，只要是语言能支持的都可以，这样能够根据我的需要选择最合适的技术。例子：Flask 你可以使用ORM 工具，SQLAlchemy来同时支持MySQL/PostgreSQL/MSSQL/sqlite3 等数据库，也可以使用Flask-PyMongo来支持 mongoDB 这样的 noSQL，总之，想用啥用啥。
- 我们不需要令人生厌的模式（WDNNSP）。我只想吃根黄瓜，你非得给我一个果篮，其他水果挺浪费的，还贵。例子：我只是搭建一个 Restful API 服务器，并不需要模板引擎，除了 join 数据没有复杂的操作，因此不需要太复杂的中间件，这种时候 Django 这样的框架远远么有 Flask 灵活。
- 我需要一个极速的框架。对于大公司而已，效率是一件非常非常重要的事，有的时候为了效率需要牺牲一部分优美值和愉快值。例子：假设我们要框架返回一个不查库的页面（只用到路由绑定和少数变量模板渲染），gin 这个单机随便扛 2W QPS 请求，同样配置的 Django 做同样的事情只能扛2K QPS。

两派其实差别并没有想象中大。到了一定程度会变得折中。Rails Like的框架把影响效率的模块换成更快的，但是保留着基本的配置准则。而Sinatra Like的框架写多了代码就会把不该重复的地方抽象成新对象，慢慢会形成优美代码准则。 Django 这样慢吞吞的框架也能撑起 Instagram 这样的巨型公司，Flask 在很多小公司用得非常愉快。

### 架构
```
Architecture is like teenage sex，everybody talks about it，nobody really knows what is it。
```
我理解的架构，一方面是根据要解决的问题，对目标系统的边界进行界定，然后切分功能，最后让各个功能可以有一个沟通机制。另一方面是保证性能和可以性作出的设计。

前者使得每个部分的功能可以相对独立，也就是高内聚低耦合：

- 像 Linux 这样的操作系统，需要有好的架构。具体来说，一个精简的不容易出错的内核来负责核心的抽象操作，一系列适应硬件的驱动程序来实际操作，一系列中间层软件包负责集成 API，最后是应用层，只需要关注继承号的 API。
- 互联网大型 Web 系统更加需要好的架构。一个核心的数据库来记录一切，各种级别的缓存系统提供高性能的访问，CDN 来负责静态的重复的资源的分发，异步队列来拆解耗时的操作，监控、回滚系统来保证可用性和持续的集成。
 
后者如大型互联网应用使用各种开源工具：
- 普通 PC 需要知道的几个数据，可能有误差，但是数量级不会错。
 - 内存。响应时间可以忽略不计，吞吐量可以到 1e8-1e9 IOPS、读写5Gbps。
 - 机械硬盘。响应时间需要 5-10 ms，吞吐量可以到 100-300 IOPS，读200Mbps，写50Mbps。
 - SSD。响应时间也是需要 5-10 ms，吞吐量可以到 5-10W IOPS，读写400-1000Mbps。
- web 后端需要记住的数字
 - 关系型数据库，如MySQL 5-10K QPS
 - noSQL，事务方面支持差一些，如mongoDB，10-20K QPS
 - 经典的队列，如RabbitMQ/NSQ  10-30K QPS
 - 数据结构服务器，如Redis 10-50K QPS
 - 内存服务器，如Memcached 100-300K QPS
 - buffering队列，Kafka 100-300K QPS


## 框架做了哪些事

它们接收 HTTP 请求，分派代码，产生 HTML，创建带有内容的 HTTP 响应。事实上，所有主流的服务器端框架都以这种方式工作的（ JavaScript 框架除外）。但愿了解了这些框架的目的，你能够在不同的框架之间选择适合你应用的框架进行开发。


### 路由和模板、表单

围绕建立 web 应用的所有问题中，三个核心问题尤其突出：

- 我们如何将请求的 URL 映射到处理它的代码上？
- 我们怎样动态地从数据库中取信息构造请求的 HTML 返回给客户端？
- 前端产生的数据后端如何拿到，并根据需要进行存储？

三个问题的答案就是标题，研究一个框架也是先研究这三个问题。


每个 web 框架都以某种方法来解决这些问题，也有很多不同的解决方案。用例子来说明更容易理解，所以我将针对这些问题讨论 Django 的解决方案。

#### 路由
处理请求 URL 到负责生成相关的 HTML 的代码之间映射的过程。核心问题主要有两个，一个是准确的调用对应的代码，另一个是如何将Request 里数据传递给对应的代码。

##### Django 中的路由

urls.py来指定 url 绑定某个函数或者某个 url 根绑定某个模块：
```
from django.conf.urls import include, url
from django.contrib import admin
from app1 import views

urlpatterns = [
  url(r'^index/$', views.index),
  # 访问 http://host/index ， 框架会帮助调用views模块里的index函数
  url(r'^admin/', admin.site.urls),
  # 访问 http://host/admin/ ，会把admin.site.urls里的集成的路由引入
  url(r'^app1/', include('app01.urls')),
  # http://host/app1 ， 会把app01模块里的路由引入
]
```
app1/urls.py，用来处理请求的url，使之与views建立映射
```
urlpatterns = [
  url(r'index/$', views.index),
  # http://host/app1/index ，请求先被上面那个文件里的代码分发，框架会帮助调用app1.views模块里的index函数
]
```

### 传参形式的动态路由

利用正则表达式的分组方法，将url以参数的形式传递到函数，可以不按顺序排列。

```
urlpatterns = [
  url(r'^user_list/(?P<v1>\d+)/(?P<v2>\d+)$',views.user_list),
]
```
(?P<v1>\d+)
这是一个 Django 的正则表达式的分组，P 是指定参数类型，传递的数据相当于一个字典， key=v1, value=\d+。 {"v1":"\d+"}

然后将此参数传递到views里对应的函数，可以不按照顺序
```
def user_list(request,v2,v1):
  return HttpResponse(v1+v2)
```
参数v1 = (?P<v1>\d+)

参数v2 = (?P<v2>\d+)

#### 模板template
我们可以从不同的来源先收集数据，然后进行处理，最后得到一个数据集。
现在是要把数据集变成 HTML 源码。

典型的代码hello.py
```
def hello(request):
    context          = {}
    context['hello'] = 'Hello World!'
    return render(request, 'hello.html', context)
```
典型的模板 hello.html
```
<h1>{{ hello }}</h1>
```
这时页面会把 py 代码里面对应的字符串填充进 html 模板里面。

大量经典的模板包括简单的判断语句和循环语句，还包括helper function，你可以在模板当中调用 py 的 函数来生成更加复杂的 html。

PS：现代的框架流行前后端分离，这个步骤往往在前端完成，后端直接把数据序列化之后传递给前端。

#### 表单
表单可以用来前端给后端服务器提交数据。

request 是一个 Python 的经典库，里面对 http 进行了一个不错的封装，常用的函数和数据都被转换成 Python 对象，我们可以用 Python 的代码来得到一个 request 里面对应的 URL param 和 form data、COOKIES、meta 等等各种数据。

```
# 接收请求数据，并返回一条消息
def search(request):  
    request.encoding='utf-8'
    if 'q' in request.GET:
        message = '你搜索的内容为: ' + request.GET['q']
    else:
        message = '你提交了空表单'
    return HttpResponse(message)
    
# 接收POST请求数据，并且使用post.html模板渲染返回值
def search_post(request):
    ctx ={}
    if request.POST:
        ctx['rlt'] = request.POST['q']
    return render(request, "post.html", ctx)
```



### 数据存储
很多网站会使用关系型数据库来存储数据。你可以自己使用 SQL 来实现增删改查。这里拿 ORM 来举例

#### Django Model
一个典型的 Django 模型 ORM
```
from django.db import models

class Group(models.Model):
    name = models.CharField(max_length=128)
    members = models.ManyToManyField(Person, through='Membership')

    def __str__(self):              # __unicode__ on Python 2
        return self.name
```
只需要几行简单的命令，常见的数据库增删改查以及关系型数据库特有的join、order_by等SQL由框架去生成，我们只需要关注它留给我们的 Python API。
```
Post.objects.create(author=me, title='Sample title', text='Test')
User.objects.get(username='ola')
Post.objects.all()
Post.objects.filter(author=me)
Post.objects.filter(title__contains='title')
Post.objects.order_by('created_date')
Post.objects.filter(published_date__lte=timezone.now()).order_by('published_date')
```

#### 约定优于配置
django 中有一种叫做ModelForm的东西，当你生成了一个 Model 之后，只需要简单的指定 fields，它会根据 fields 来生成表单。

按照先读取Model里指定的类型，然后再去Form里面读取选项，最后生成 包含 form 的 HTML 模板。
```
class PostForm(forms.ModelForm):

    class Meta:
        model = Post
        fields = ('title', 'text',)
```
验证表单&存储数据
```
def post_edit(request, pk):
    post = get_object_or_404(Post, pk=pk)
    if request.method == "POST":
        form = PostForm(request.POST, instance=post)
        if form.is_valid():
            post = form.save(commit=False)
            post.author = request.user
            post.published_date = timezone.now()
            post.save()
            return redirect('post_detail', pk=post.pk)
    else:
        form = PostForm(instance=post)
    return render(request, 'blog/post_edit.html', {'form': form})
```

表单的提交一般通过 POST 请求，pk是数据的主键，post是根据 pk 读取的现在的数据库里的数据，PostForm根据request.POST里的 form data进行表单验证，如果合法则保存数据的author和published_date被存进数据库。


#### 中间件
事实上，很多请求有相似的需求，比如验证一个人的登陆状态，如果我们每个函数都写一个验证，不符合 DRY 原则也不优美。

这个时候引入一个概念：中间件。由中间件来负责做这些重复的事情，Django 中间件的具体做法是：

在请求阶段中，调用视图之前，Django会按照MIDDLEWARE_CLASSES中定义的顺序自顶向下应用中间件。在响应阶段中，调用视图之后，中间件会按照相反的顺序应用，自底向上。

中间件处理 request实现这两个函数：
```
process_request()
process_view()
```
处理 response 实现这三个函数：
```
process_exception()（仅当视图抛出异常的时候）
process_template_response()（仅用于模板响应）
process_response()
```
你可以想象一下一个典型场景，我需要通过 csrf_token 来唯一辨认用户，现在服务器每次接受请求的时候需要验证这个参数，如果参数不对要直接报错。参数对了，又需要在返回请求的时候在相应的header 里面再次写上 token，这种事情就非常适合由中间件来做。

```
MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.security.SecurityMiddleware',
)
```
很多事情中间件都能做，具体的可以去查看你在学的框架文档和源码。


### Serverless 架构
由于云服务的发展，现在 web 开发常见的需求，很多原来需要消耗人力的特性都可以直接使用云服务。现在的一个趋势是 [Serverless](https://serverless.com/framework/docs/providers/aws/) ，大致意思是就是以函数为基本单位来部署功能。由集群根据这些函数的资源调用历史来分配对应的计算服务。

- 数据库存储，基于 Paxos 的 NewSQL 现在几乎每家都支持，可以理解为无限大的 MySQL
- 缓存服务器，云服务商实现好集群，我们只需要考虑需要的内存大小，不需要花精力去考虑一致性，得到一个可以按需扩张的超大缓存服务器。
- CDN 存储，前端需要用的视频，css 等文件，可以通过 cdn 网络来快速下发。
- 图片存储，云服务的图片存储很好用，url 指定一下大小、格式就能直接返回符合要求的图片
- log 服务，帮助你做 tracking，分析产品的使用情况，收集各个地方产生的 bug/error。
- 持续集成，你只需要指定自己的函数依赖的函数对应的版本区间，服务发现会自动去寻找对应的服务生成调用链。
- 充分利用资源和硬件特点部署函数，比如大数乘法，我们可以使用 FPGA 来做傅里叶变换，比 CPU 可能要快上一千倍。
- 机器学习和大数据分析。AWS 直接开放了对应的接口，只需要按照要求填写一部分 meta data，云服务直接帮你分析结果。

结论，这个时间点学习架构一定是混合云架构。

也正是有了这些服务，国外才会有那种十几个人撑起日活几百万的现象级公司。