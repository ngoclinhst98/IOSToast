Pod::Spec.new do |spec|

  spec.name         = "IOSToast"
  spec.version      = "0.0.3"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you perform calculation.
                   DESC

  spec.homepage     = "https://github.com/ngoclinhst98/IOSToast"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Nguyễn Ngọc Linh" => "ngoclinhst98@gmail.com" }

  spec.ios.deployment_target = "15.0"
  spec.swift_version = "5.5"

  spec.source        = { :git => "https://github.com/ngoclinhst98/IOSToast.git", :tag => "#{spec.version}" }
  spec.source_files  = 'IOSToast/Classes/*.{h,m,swift}'

end

  