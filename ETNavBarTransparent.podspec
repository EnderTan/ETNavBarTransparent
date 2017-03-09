Pod::Spec.new do |s|
  s.name     = 'ETNavBarTransparent' 
  s.version  = '1.0.0' 
  s.license  = 'MIT'
  s.summary  = 'Change NavigationBar‘s transparency at pop gestrue and other situation'
  s.homepage = 'https://github.com/EnderTan/ETNavBarTransparent'
  s.author   = { 'Ender Tan' => 'endertan@163.com' }
  s.source   = { :git => 'https://github.com/EnderTan/ETNavBarTransparent.git', :tag => '1.0.0' }
  s.platform = :ios, '7.0'
  s.source_files = 'ETNavBarTransparent','ETNavBarTransparent/**/*'
  s.framework = 'UIKit'  //依赖的framework
  s.requires_arc = true
  s.social_media_url   = 'http://weibo.com/endertan'
end