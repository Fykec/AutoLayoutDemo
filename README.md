#iOS Layout 技术回顾及 Masonry 介绍

作为一名iOS 开发者，大家都知道UIKit默认是MVC 架构的，Model，View，和Controller 。随着这几年App开发的普及，这三部分所使用的技术都越来越成熟。比如 Model 现在有很多 JSON-binding 像 Mantle，JSONModel；Controller所代表的控制层也出现很多思潮像MVVM，MV；，对于View，现在出来的UI控件更是数不胜数，让人眼花缭乱。在那么多变化中，有没有一些东西是始终不变的呢？是有的，有些核心的思想是一直没有变的，比如今天我们要谈的Layout技术。

Layout 是大家经常接触，但却很少去关注的话题。因为用起来太简单了，都是改大小，改位置。没觉得需要再做些什么了。 

**不就是 setFrame 吗？**

确实只是setFrame，但你也别小看它。细看你也会发现一整片天地。Layout 技术看上去简单，它却是整个GUI框架的基础，上层技术的设计，是必须依赖它才能实现。

##Code vs xib family

很早之前（有多早？没有 iOS 之前就有 nib 了） 关于view的Layout就有两种写法。

1. 用纯code写，继承UIView，UIButton等，实现自定义的View
2. 用nib，xib 以及后来的Storyboard，来拖控件来实现可视化的编辑

**哪一种更好呢？**

这个是没有固定答案的，哪一种都好，哪一种都不好，好坏是依据情境而定的，因为产品业务不同，技术栈不同，而且人还是有技术偏好的。所以不能从一而论。但是你用没有用好？是看的出来的。技术与熟悉它的人一起配合才会产生好的效果。所以与其说好坏，不如说一种风格，用code 写的人，觉得纯code，看起代码来更容易，方便继承，组合和代码管理。用xib的觉得xib 和 storyboard更直观，调样式更简单。不管选择怎样，对一名开发人员，你是需要明白两种的利弊来做恰当的选择，对一个iOS团队，是需要统一思想的，去发挥一种方式的优点，要建立规则规避缺点的影响，比如用xib之类的文件，很不利于merge，特别是在多人协作的情况下，这个时候有的团队，就是把xib分配到人，一个人维护一部分。哪怕是两者都用，你也需要去明白，既然你两者优点都想要，那你也会带来维护上复杂度的提升。

我是使用纯 code 来写 view 比较多的。但是代码写多了，总会不满足。总觉得不能老是 override layoutSubviews了，于是就会想：

1. 能更简单点吗？能把布局逻辑抽象出来吗？
2. 像Android 一样写在一个简单的可读的xml 里，还可以继承？
3. 能像 CSS 之于 HTML 一样，完全分开吗？甚至异步加载布局？

##有了Auto Layout 

我相信不只有我一个人这么想？还有很多人也是的。但是怎么办呢？

随着iOS平台的发展和成熟，事情出现了转机。iOS 刚开始只有 320 * 480尺寸，后来有了iPad，然后又有了320* 596尺寸，还有@2x @3x 等等。而且现在很多App还要适配多语言，不同语言下文字的长度差别可能很大。写死 size 的做法已经越来越不好用了。如何采用通用的方法来布局呢？苹果出了一个通用方案Auto Layout。

以前我们写死固定的 size，origin，现在不能再用固定的数字，否则就没办法统一了。那用什么呢？用**关系**，对于多种size的屏幕，存贮固定的大小，不如存储关系。因为对于同一个界面，很多情况下，子view 在不同的尺寸下的相对关系是不变的。我们存储关系，让程序在运行时去解析这些关系，根据当前的设备算出，该设定的尺寸，这样才能统一。

**那我们怎么找到这些关系呢？怎么抽象出来呢？**

来让我们看看我们在 layoutSubviews 里写的代码。一般写 layoutSubviews 里面的代码是这样的
  
```Objective-C
 - (void)layoutSubviews {
    [super layoutSubviews];

    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];
    _centerLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - textSize.width) / 2, (CGRectGetHeight(self.bounds) - textSize.height) / 2, textSize.width, textSize.height);
}
```
  
  我们进一步分析，如果把一个view的frame中的origin和size都拆开成left, top, width, height
 
```Objective-C
  CGFloat left = (1 / 2) * self.bounds.size.width - textSize.width / 2;
  CGFloat top = (1 / 2) * self.bounds.size.height - textSize.height / 2;
  CGFloat width = textSize.width;
  CGFloat height = textSize.height;
  _centerLabel.frame = CGRectMake(left, top, width, height);
```

 对 left top ，width, height进一步进行数学变换，分离变量和常量,
 
```
 CGFloat left = (1 / 2) * self.bounds.size.width - textSize.width / 2;
 CGFloat top = (1 / 2) * self.bounds.size.height - textSize.height / 2;
 
```
 
 对于没有变量的, 假设一个变量，并乘以0
 
```
 CGFloat width = 0 * self.bounds.size.width + textSize.width;
 CGFloat height = 0 * self.bounds.size.height + textSize.height;
```

所以呢，代码成了这个样子
 
 
```
 CGFloat left = (1 / 2) * self.bounds.size.width - textSize.width / 2;
 CGFloat top = (1 / 2) * self.bounds.size.height - textSize.height / 2;
 CGFloat width = 0 * self.bounds.size.width + textSize.width;
 CGFloat height = 0 * self.bounds.size.height + textSize.height;
 _centerLabel.frame = CGRectMake(left, top, width, height);
```
  
最后 left，top, width, height 就可以归一化到 如下形式
 
```
aView.属性 = 乘数 * bView.属性 + 常量
```

接着，如果一个view 跟多个view有关呢？

假如像下面这样跟两个view有关

```
aView.属性 = 乘数 * bView.属性 + 乘数 * cView.属性 + 常量
```
那怎么统一呢？

不急，我们先看下 CGRect 的结构

```
struct CGRect {
    CGPoint origin;
    CGSize size;
};
```
rect 有 origin 和 size，size 是 view 的大小，origin 呢？origin 是 view 左上角的位置，size在同一套单位下是绝对的，origin是相对的，但是它是相对于谁的？相对于自己的父view的，又因为所有的view 都在同一个view tree 上的，所以bView cView总是能找到相同的一个父节点的，假设是F节点 那么总会得到如下的形式

```
FView.属性 = 乘数 * bView.属性 + 常量
FView.属性 = 乘数 * cView.属性 + 常量
```

所以就也能转化成

```
aView.属性 = 乘数 * FView.属性 + 常量
```

即使，再加上 dView， eView 也没有关系，还是上面这个公式。

看到了吧，所有的布局计算都可以对应到这样一个 **一次函数**


**然而推出这个公式有什么用呢？**

我们看一下 Auto Layout 的 API

```
/* Create constraints explicitly.  Constraints are of the form "view1.attr1 = view2.attr2 * multiplier + constant" 
 If your equation does not have a second view and attribute, use nil and NSLayoutAttributeNotAnAttribute.
 */
+(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
```

知道了吧，Auto Layout的API就是如此。就是基于这个最基本的函数运算来设计的。有了这个函数， 在 layoutSubviews 里的动态布局代码，才可以抽象出来写成声明式的关系了！


###Auto Layout 介绍

Auto Layout是iOS 6之后，苹果推出的布局技术，主要是为了适配多屏幕而产生的。Auto Layout 本身的原理是基于[constraint](https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/AutolayoutPG/)的，Auto Layout内部的实现是隐藏的，接口设计的非常简单和干净，而且直击要害。  

Auto Layout 主要是一个类 **NSLayoutConstraint**

而NSLayoutConstraint主要是两个API。
 
1. 一个是就上面推导出来的那个。
2. 还有一个就 [Visual Format Language](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage.html),解析方法，而VFL也是为了表示这种函数关系而产生的。

```
+ (NSArray<__kindof NSLayoutConstraint *> *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *, id> *)views;
```

除了方法之外，再就是常用的属性，如下

```
typedef NS_ENUM(NSInteger, NSLayoutAttribute) {
    NSLayoutAttributeLeft = 1,
    NSLayoutAttributeRight,
    NSLayoutAttributeTop,
    NSLayoutAttributeBottom,
    NSLayoutAttributeLeading,
    NSLayoutAttributeTrailing,
    NSLayoutAttributeWidth,
    NSLayoutAttributeHeight,
    NSLayoutAttributeCenterX,
    NSLayoutAttributeCenterY,
    NSLayoutAttributeBaseline,
    ...
    NSLayoutAttributeNotAnAttribute = 0
};
```

关于这个基本函数的运算和属性说完了，算式是说完了。但是还没有完。

你细看，会发现NSLayoutRelation有三种，不只是可以用等号来判定等式两边，还可以大于等于，小于等于

```
typedef NS_ENUM(NSInteger, NSLayoutRelation) {
    NSLayoutRelationLessThanOrEqual = -1,
    NSLayoutRelationEqual = 0,
    NSLayoutRelationGreaterThanOrEqual = 1,
};
```

怎么多了两种呢？以前计算都是相等关系，现在不等关系也是可以处理了。神奇吧？欲知详情，可以看完文章后，查看结尾的论文链接。


好，让我们来用用试试！但是你当你写完代码，你发现它长成了这个样子。

```
    CGSize textSize = [_centerLabel.text sizeWithAttributes:@{NSFontAttributeName: _centerLabel.font}];

    [self addConstraints:@[[NSLayoutConstraint constraintWithItem:_centerLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_centerLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]]];
    [_centerLabel addConstraints:@[[NSLayoutConstraint constraintWithItem:_centerLabel
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0
                                                                 constant:textSize.width],
                                   [NSLayoutConstraint constraintWithItem:_centerLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:0
                                                                 constant:textSize.height]]];
```

恩，设计的很好，但这也太复杂了吧。


**出什么问题了？**

1. API 和参数名字太长了
2. 参数重复出现，只对两个 view  之间设置关系，但是 _centerLabel 出现数次
3. 再一次阅读代码时，思维是跳跃，你试试，当你把目光放到代码上的时候，你先要定位到第一 item，我看到设置了_centerLabel, 又往后看我设置的是 centerX，那我相对的是什么？ self，self的什么？self的centerX，就这样我的思维一直在跳动，看完之后的，我还要把我看到的参数套用到公式中去。


**还有个VFL，再试试**

```
 UIView *superview = self;
 NSDictionary *views = NSDictionaryOfVariableBindings(_centerLabel, superview);
 [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[superview]-(<=1)-[_centerLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
 self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[_centerLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
```
 
好吧，看来出现了神奇的符号。**V:[superview]-(<=1)-[_centerLabel]**，太不直观了。你要记住每个符号的意义。而且当你通过XCode，在引号内部输入一串这样的神奇符号时是没有自动补全的。反应慢的同学，囧，比如我，写之前得停顿一会儿，一次想好。

**为什么还是不好用？** 

VFL 的设计初衷是好的，想通过符号的引入，让你看到，界面元素之间的位置关系，比如 横线 **-** 表示间隔，方括号包住的内容**[]** 表示view,。[superview]-[_centerLabel] 表示superview 和 _centerLabel挨着。**(<=1)**表示距离大于1，**[superview]-(<=1)-[_centerLabel]** 表示 两个superview和_centerLabel之间的距离大于1，**V:**表示Vertical，所以完整的意思是 superview 和_centerLabel在竖直方向上某个属性挨着，且距离大于1。解释一遍还是能懂的，但是这个设计还是没有逃脱，去解方程的思维，VFL的表达式用符号表示操作符，把变量通过views和 metrics两个参数传进来。API使用者始终在考虑怎么去处理这个方程。

**Coder Interface（API）**

作为一个 Coder，我们经常写 User Interface 让 User 更爽，那么我们自己面对的 Coder Interface呢，要怎么设计，用起来更爽呢？

设计接口也是和产品设计一样的，需要考虑使用者的思维习惯，之所以NSLayoutContraint 那么不好用就是因为**不符合使用者的思维习惯**。借用产品设计的一句话["Don't make me think"](https://en.wikipedia.org/wiki/Don%27t_Make_Me_Think),来做说明的话，NSLayoutConstraint API 一直 Make me think！

##所以，该DSL上场了

DSL出场前，让我们先介绍下DSL，DSL是[Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language)的缩写，基本的目的是处理某一领域的特定问题的语言。他不像通用语言，要去覆盖全部的问题域，而是处理某一特定的问题。设计它的目的就是为了转化通用语言，让他更适合使用者的知识模型，用起来顺畅。平常我们也会经常遇到的DSL，比如CSS就是针对编写网页布局的DSL，Podfile语法就是编写Cocoapods依赖规则的DSL。

那我们要设计怎样的DSL呢？

设计DSL，先要了解你面向的使用者。设计语法本身不是目的，语言是为了传播思想服务的，是为了思维的转换，把其他领域的知识内容转换成使用者熟悉的思维方式，适应使用者的思维才行。

历史证明程序员有多少中常用思维，就会有产生多少种DSL。其实机制有了，好的方案就会浮现的。Auto Layout发布后，AutoLayout的DSL如雨后春笋般的涌现.

我找出一些有代表性的，按照程序员偏好的语法风格分下类

1. 陈述命令形式，像说一句话一样
  1. [Masonry](https://github.com/SnapKit/Masonry)
  2. [KeepLayout](https://github.com/iMartinKiss/KeepLayout)
2. 还原数学公式，仍然是代入公式计算，但更直观
  1. [Cartography](https://github.com/robb/Cartography)
  2. [CompactConstraint](https://github.com/marcoarment/CompactConstraint)
3. Shortcut形式，创造了很多short cut的方法，覆盖了常用的布局需求
  1. [PureLayout](https://github.com/PureLayout/PureLayout)
  2. [FLKAutoLayout](https://github.com/floriankugler/FLKAutoLayout)
4. 仿照 CSS 形式，用CSS的语法来做iOS的布局
  1. [SwiftBox](https://github.com/joshaber/SwiftBox)


大家都可以按照自己的口味选择。但我最终选择了Masonry。

理由是这样的，其实写代码时，我们要去设置什么，我们已经想好了，我们要的是把它写成代码，越直接，越快越好。

来看看 Masonry 是怎么做的，如果我们想 **让_centeLabel 在它的 superView 里面居中**，

如果思考地机械一点就是

```
让 _centerLabel的中心等于_centerLabel的superview 的中心
```

翻译成代码就是

```
make.center.equalTo(_centerLabel.superview);
```

这样直接陈述就可以了。每一句话，都是Masonry能听懂的命令，所以我们直接发送几条命令就能完成目的，接着把设置的清单塞到block里

```
[_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
  make.center.equalTo(_centerLabel.superview);
}];
```

然后，这个_centerLabel就居中了，是不是很简单！


##Masonry

Masonry 这种DSL 设计的优点在于把数学的函数，翻译成可读性极佳的代码，像读句子一样，人好读了，写起来思维流畅，就不容易出错，而且它并没有实现很重的语法，完全利用Objective-C的语法，"." 操作符作为连接符，block作为设置声明的清单。这样做的好处是实现简单，而且不需要单独的 parser，因此对效率也不会有太大影响，这是很巧妙的地方，这样的设计，平衡各方面的需求，使用者，语言本身，实现复杂性，性能等等。

Masonry本身只是语法的转换，并没有在 Auto Layout 的基础之上添加新的功能。

所以主要的 API 也是一个

```
- (NSArray *)mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;
```

紧接着就是可以操作的属性，和 Auto Layout一一对应。


MASViewAttribute           |  NSLayoutAttribute
-------------------------  |  --------------------------
view.mas_left              |  NSLayoutAttributeLeft
view.mas_right             |  NSLayoutAttributeRight
view.mas_top               |  NSLayoutAttributeTop
view.mas_bottom            |  NSLayoutAttributeBottom
view.mas_leading           |  NSLayoutAttributeLeading
view.mas_trailing          |  NSLayoutAttributeTrailing
view.mas_width             |  NSLayoutAttributeWidth
view.mas_height            |  NSLayoutAttributeHeight
view.mas_centerX           |  NSLayoutAttributeCenterX
view.mas_centerY           |  NSLayoutAttributeCenterY
view.mas_baseline          |  NSLayoutAttributeBaseline


然后是 关系符 也对应者 Auto Layout 定义的三种关系符

> `.equalTo` equivalent to **NSLayoutRelationEqual**

> `.lessThanOrEqualTo` equivalent to **NSLayoutRelationLessThanOrEqual**

> `.greaterThanOrEqualTo` equivalent to **NSLayoutRelationGreaterThanOrEqual**


除此之外，他还有些 shortcut的属性，来方便设置相对布局

1. edges
2. size
3. center


###与Auto Layout不同之处

Masonry 多了两个API，一个是update

```
- (NSArray *)mas_updateConstraints:(void(^)(MASConstraintMaker *make))block;
```
原因是出于苹果关于对[性能的建议](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSLayoutConstraint_Class/#//apple_ref/occ/instp/NSLayoutConstraint/constant)，如果，你只更新 constraint 里面的 constant的值，那么你不需要再 make, 你可以update

```
[_centerLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(_centerLabel.superview);
}];
```

这个句子，只是更新了center，并没有改变该view与其他view之间的依赖关系。所以 Masonry 会去从已经在_centerLabel 里面找到相似的 contraints 去更新他，而不是再添加一个 新的constraint

还有一个是 remake 

```
- (NSArray *)mas_remakeConstraints:(void(^)(MASConstraintMaker *make))block;
```

不同点就在 remake 会移除以前设定的contraints，这样调用Masonry的外部外部代码就不用为了以后能够移除contraints 而去keep contraints的reference了。

###Masonry使用

讲Masonry使用之前，我们先来比较总结一下iOS的布局系统。布局系统是GUI框架的基本组成部分，我这里从三个基本维度来简单分析下

1. 基本数据结构
2. 元素之间的相对关系
3. 常用的布局模型

还是回到CGFrame的frame，frame分为size和origin的，如果拿Android系统做对比的话size这个结构都有，但是 origin就不一样了，Android中有的是margin，margin和origin不一样，margin 是相对的是其他view，可以平级view，也可以不平级，origin却只是相对于父view，跟其他view无关的。所以如果拿Android几种常用的Layout做个解释的话，iOS的只原生支持Andorid的[AbsoluteLayout](http://developer.android.com/reference/android/widget/AbsoluteLayout.html) 。

也正是因为这个基本设计的不同，iOS里面的布局计算都可以归一到刚才推出来的一对一函数。

```
aView.属性 = 乘数 * bView.属性 + 常量
```

但是 Android的就不是这样的，天生的就是一对多的，margin有四个边，计算要考虑4个邻居元素的位置，所以 Android 的布局代码总是和LinearLayout等Layout一起用的，否则就总是要程序员去处理复杂的计算了。iOS里面却不需要去刻意突出这样的Layout模型，但也是需要这样的模型结构的。那 iOS 怎么实现LinearLayout之类的布局模型呢？通过控件比如UITtableView，UICollectionView，这些UI控件做了布局系统中复杂的计算。

总结如下表

布局      |  iOS          |  Android      | Web
-------------------------  |  --------------------------  |  --------------------------  |  --------------------------  
数据结构                    |  origin, size | margin, size   |  margin, size
相对关系 | 相对于父view    | 现对于父view 或者同级 view 都可以|  相对于父亲 view 或同级 view 都可以
布局模型       |   UITableView, UICollectionView...  |  LinearLayout, RelativeLayout...  |   posistion attribute，float attribute，flexbox...


####Masonry Demo
既然 iOS 里面没有像Android这样原生的常用的布局模型，下面让我们实现 Android 的几种常见 Layout，来熟悉Masonry的用法

Android主要五个Layout，我们主要实现下面三个Layout，LinearLayout，FrameLayout，GridLayout。AbsoluteLayout本来就是iOS的默认方式，就不用实现了，RelativeLayout本身要解决是布局嵌套过深的问题，而不是位置关系。

#####LinearLayout 主要是列表的形式，

竖直列表
![](http://i.imgur.com/x4ur7Rk.png?1)

实现竖直列表可以mas_left , mas_right, 和 mas_height 都是固定的，不断的调整 mas_top的值。这里虽然也有 top left right 和 bottom，但是和 Android 里的的 margin 是不同的。
1. 你使用的 top left right bottom，要指定相对于那个元素，margin的 top left right bottom 是不需要的。
2. 这里的数字是有方向的，向下，向右为正，所以设置 right 的 offset 是从右往左的-20。


```
 UIView *lastCell = nil;
    for (UIView *cell in _linearCells) {
        [cell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@(40));
            if (lastCell) {
                make.top.equalTo(lastCell.mas_bottom).offset(20);
            }
            else {
                make.top.equalTo(@(20));
            }
        }];

        lastCell = cell;
    }
```

水平列表
![](http://i.imgur.com/shtKuSf.png?1)

实现水平列表可以mas_top mas_bottom 和 mas_width 固定，不断调整 mas_left的值。

```
 UIView *lastCell = nil;

    for (UIView *cell in _cells) {
        [cell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(20));
            make.bottom.equalTo(@(-20));
            make.width.equalTo(@(20));
            if (lastCell) {
                make.left.equalTo(lastCell.mas_right).offset(20);
            }
            else {
                make.left.equalTo(@(20));
            }
        }];

        lastCell = cell;
    }
```



#####FrameLayout

![](http://i.imgur.com/cFRD62N.png?1)

[FrameLayout](http://developer.android.com/reference/android/widget/FrameLayout.html) 主要是实现层级堆叠的效果，通过[layout_gravity](http://developer.android.com/reference/android/widget/FrameLayout.LayoutParams.html#attr_android:layout_gravity), 设置堆叠的位置。

下面我们介绍其中的几种堆叠

左上角

当要设置的view的属性和相对的view属性相同时，相对的view的属性可以直接省略。

```
 make.left.equalTo(cell.superview.mas_left);
 make.top.equalTo(cell.superview.mas_top);
```
 
可以写成

```
 make.left.equalTo(cell.superview);
 make.top.equalTo(cell.superview);
```

居中 
很简单直接用 center 属性即可

```
make.center.equalTo(cell.superview);
```

上边对齐 左右居中

center可以分为centerX和centerY这里使用centerX， 加上top属性即可
```
 make.centerX.equalTo(cell.superview);
 make.top.equalTo(cell.superview);
```

#####GridLayout

![](http://i.imgur.com/hVtgbLp.png?1)
Grid layout 实现起来就复杂一些了，需要我们去算处于哪一行和列, 不断的更新left 和top。

```
  CGFloat cellWidth = 70;
    NSInteger countPerRow = 3;
    CGFloat gap = (self.bounds.size.width -  cellWidth * countPerRow) / (countPerRow + 1);

    NSUInteger count = _cells.count;
    for (NSUInteger i = 0; i < count; i++)
    {
        UIView *cell =  [_cells objectAtIndex:i];
        NSInteger row = i / countPerRow;
        NSInteger column = i % countPerRow;

        [cell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(row * (gap + cellWidth) + gap));
            make.left.equalTo(@(column * (gap + cellWidth) + gap));
            make.width.equalTo(@(cellWidth));
            make.height.equalTo(@(cellWidth));
        }];
    }

```

另外如果你嫌总是要敲mas_ 这个prefix太烦的话，使用时定义一个宏就可以了。

```
#define MAS_SHORTHAND
#import "Masonry"
```

好了，是不是意犹未尽？但是Masonry 的基本使用就介绍到这里了。至于更多内容，可以直接查看[Masonry](https://github.com/SnapKit/Masonry) 项目。


###SnapKit

如果是新开的的项目准备用Swift的话,可以用[SnapKit](https://github.com/SnapKit/SnapKit)， SnapKit 是 Masonry开发者开发的Swift版本。
另外在 [Swift中使用Masonry](https://github.com/cnoon/Swift-Masonry) 也会有些不便，比如下面的多出来的括号

```
view3.mas_makeConstraints { make in
  self.animatableConstraints.extend([
       make.edges.equalTo()(superview).insets()(edgeInsets).priorityLow()(),
   ])
       make.height.equalTo()(view1.mas_height)
       make.height.equalTo()(view2.mas_height)
   }
```

##结尾


本文回顾了iOS平台的布局技术的发展，讲述了Auto Layout的技术的由来，Auto Layout 技术的核心，以及相关DSL技术的产生，最后介绍了Masonry这个DSL的使用。至于文章开头提出的三个问题，部分已经有了答案，剩下要看以后的发展了。另外像我还没有介绍到的技术，比如 [Size Class](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithSelf-SizingTableViewCells.html#//apple_ref/doc/uid/TP40010853-CH25-SW1)很适合不同大小的设备上使用不同设计的情况，比如同时有iPad和iPhone版本时，使用Size Class可以带来更好的交互体验，限于篇幅就没有介绍。

最后，本文中所有代码都在[github](https://github.com/Fykec/AutoLayoutDemo)上。

如果，大家对Layout相关话题还饶有兴趣，可以继续看下面的链接

1. [Cartography 另一种优秀 Auto Layout DSL](https://github.com/robb/Cartography)
2. [Flexbox 优秀 CSS 3的布局模型](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes)
3. [Classy - Expressive, flexible, and powerful stylesheets for native iOS apps](http://classykit.github.io/Classy/)
4. [Auto Layout 内部实现的解释](http://stacks.11craft.com/cassowary-cocoa-autolayout-and-enaml-constraints.html)
5. [The Cassowary Linear Arithmetic Constraint Solving Algorithm， Auto Layout内部算法](https://constraints.cs.washington.edu/cassowary/cassowary-tr.pdf)

以下是我的博客，我会定期更新 iOS客户端 和 Hybird App开发相关文章。欢迎订阅！

[一个热爱太极的程序员](http://www.taijicoder.com)

另外，如果发现本文中有任何谬误，请联系我yinjiaji110@gmail.com，我会及时更正。 谢谢！


