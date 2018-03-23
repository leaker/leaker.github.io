title: 类 enable_shared_from_this 的经验总结
date: 2015-12-13 23:32:07
tags:
  - c++
  - enable_shared_from_this
  - shared_ptr
categories: programing
---
# 不能再构造函数内使用 shared_from_this() 函数
```c++
class class_a : public std::enable_shared_from_this<class_a>
{
public:
    class_a(void)
    {
        auto self(shared_from_this());// 这里会报 bad_weak_ptr 错误
    }
};
```

# 子类无法重复继承
```c++
class class_a : public std::enable_shared_from_this<class_a>
{
};

class class_b : public class_a, public std::enable_shared_from_this<class_a>
{
};
```
这段代码将无法通过编译。
如果想返回子类的 shared_from_this 指针，则可以进行如下操作
```c++
class class_a : public std::enable_shared_from_this<class_a>
{
public:
    virtual ~class_a()// 为了确保 dynamic_pointer_cast 可以工作，需要父类拥有虚函数。
    {}
};

class class_b : public class_a
{
public:
    std::shared_ptr<class_b> shared_from_this(void)
    {
        return std::dynamic_pointer_cast<class_b>(class_a::shared_from_this());
    }
};
```

**通常来说如果定义一个类时，如果这个类可能被继承使用时，将这个类的析构函数定义为虚函数来确保析构的调用顺序**
