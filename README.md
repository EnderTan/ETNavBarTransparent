# ETNavBarTransparent
Change NavigationBar's transparency at pop gestrue and other situation
###Screenshots
![image](https://github.com/EnderTan/ETNavBarTransparentDemo/blob/master/navDemo.gif)

###Installation
Add the following line to your Podfile:
```
pod 'ETNavBarTransparent'
```
Then, run the following command:
```
$ pod install
```

Or,Simply drag "ET_NavBarTransparent.swift" to your project

###Usage
Change NavigationBar's transparency and tintColor where you want:
```
    //Example：
    //Change in viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBgAlpha = 0
        self.navBarTintColor = .white
    }
    
    //Change in scrollView scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 100 {
            navBarBgAlpha = 1
            navBarTintColor = UIColor.defaultNavBarTintColor()
        }else{
            navBarBgAlpha = 0
            navBarTintColor = UIColor.white
        }
        
    }
```


###Related articles
http://www.jianshu.com/p/454b06590cf1
