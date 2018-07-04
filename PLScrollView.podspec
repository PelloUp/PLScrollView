#
#  Be sure to run `pod spec lint PLScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "PLScrollView"
  s.version      = "1.0.0"
  s.summary      = "A custom scrollView on iOS"
  s.description  = "A custom scrollView on iOS, Achieve special browsing effects"
  s.homepage     = "https://github.com/PelloUp/PLScrollView"
  # s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Pello" => "898202478@qq.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/PelloUp/PLScrollView.git", :tag => s.version }
  s.source_files  = "PLScrollView/*.{h,m}"
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.dependency "SDWebImage"
  s.dependency "YYKit"
  s.dependency "Masonry"

end
