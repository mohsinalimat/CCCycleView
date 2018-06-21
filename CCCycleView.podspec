Pod::Spec.new do |s|
  s.name         = "CCCycleView"
  s.version      = "0.0.1"
  s.summary      = "An easy reuse cycle view"
  s.description  = <<-DESC
  目前可以用来轮播图、跑马灯、循环view的简单易用控件
                   DESC

  s.homepage     = "https://github.com/zackschen/CCCycleView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "zacks" => "cczacks@gmail.com" }

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/zackschen/CCCycleView.git", :tag => "#{s.version}" }

  s.source_files  = "CCCycleView", "CCCycleView/*.{h,m}"
  s.public_header_files = "CCCycleView/*.h"
  
  s.framework  = "UIKit"
  s.requires_arc = true

end
