# ETNavBarTransparent
Change NavigationBar's transparency at pop gestrue and other situation

## Animation
![image](https://github.com/EnderTan/ETNavBarTransparentDemo/blob/master/navDemo.gif)

## Installation
Add the following line to your Podfile:
```ruby
pod 'ETNavBarTransparent'
```

Then, run the following command:
```bash
$ pod install
```

Or, simply drag `ETNavBarTransparent.swift` to your project.

## Usage

Change NavigationBar's transparency and tintColor where you want:

```swift
// Example：
// Change in viewDidLoad
override func viewDidLoad() {
    super.viewDidLoad()

    self.navBarBgAlpha = 0
    self.navBarTintColor = .white
}

// Change in scrollView scroll
func scrollViewDidScroll(_ scrollView: UIScrollView) {

    if scrollView.contentOffset.y > 100 {
        navBarBgAlpha = 1
        navBarTintColor = UIColor.defaultNavBarTintColor()
    } else {
        navBarBgAlpha = 0
        navBarTintColor = .white
    }

}
```

## Related articles
[导航栏的平滑显示和隐藏 - 个人页的自我修养（1）](http://www.jianshu.com/p/454b06590cf1)

## License
MIT license. See LICENSE for details.

## Contact
Follow and contact me on Weibo [@日光镇](http://weibo.com/endertan) or [My Blog](http://www.jianshu.com/u/a958e552973b)
