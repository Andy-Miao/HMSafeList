Pod::Spec.new do |s|
  s.name         = "HMSafeList"
  s.version      = "0.0.1"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.8'
  s.summary      = "Custom and Apple-Native Derived Safe Array"
  s.homepage     = "https://github.com/Andy-Miao/HMSafeList"
  s.license      = "MIT"
  s.author             = { "Andy-Miao" => "randy_hm@qq.com" }
  s.social_media_url   = "hhttps://twitter.com/Andy-Miao"
  s.source       = { :git => "https://github.com/Andy-Miao/HMSafeList.git", :tag => s.version }
  s.source_files  = "List"
  s.requires_arc = true
end