Pod::Spec.new do |s|
  s.name     = 'ETNavBarTransparent' 
  s.version  = '1.0.0' 
  s.license  = 'MIT'
  s.summary  = 'Change NavigationBar‘s transparency at pop gestrue and other situation'
  s.homepage = 'https://github.com/EnderTan/ETNavBarTransparent'
  s.author   = { 'Ender Tan' => 'endertan@163.com' }
  s.social_media_url   = 'http://weibo.com/endertan'
  s.source   = { :git => 'https://github.com/EnderTan/ETNavBarTransparent.git', :tag => '1.0.0' }
  s.platform = :ios, '8.0'
  s.source_files = 'ETNavBarTransparent','ETNavBarTransparent/**/*'
  s.requires_arc = true
  s.framework = 'UIKit'
end