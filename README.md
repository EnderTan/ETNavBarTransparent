# ETNavBarTransparentDemo
Change NavigationBar's transparency at pop gestrue and other situation

![image](https://github.com/EnderTan/ETNavBarTransparentDemo/blob/master/navDemo.gif)
####使用方法
1、把ET_NavBarTransparent.swift导入到项目中
2、在需要的地方修改导航栏透明度和navigationItem的颜色：
```
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBgAlpha = 0
        self.navBarTintColor = .white
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 100 {
            navBarBgAlpha = 1
            navBarTintColor = UIColor.gray
        }else{
            navBarBgAlpha = 0
            navBarTintColor = UIColor.white
        }
        
    }
```
####相关文章
http://www.jianshu.com/p/454b06590cf1
