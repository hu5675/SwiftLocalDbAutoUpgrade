#
# Be sure to run `pod lib lint SwiftLocalDbAutoUpgrade.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftLocalDbAutoUpgrade'
  s.version          = '1.0.0'
  s.summary          = 'IOS本地数据库自动升级'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
根据plist数据结构，使本地数据库自动升级
                       DESC

  s.homepage         = 'https://github.com/hu5675/SwiftLocalDbAutoUpgrade'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hu5675' => 'hytmars1989@126.com' }
  s.source           = { :git => 'https://github.com/hu5675/SwiftLocalDbAutoUpgrade.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftLocalDbAutoUpgrade/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftLocalDbAutoUpgrade' => ['SwiftLocalDbAutoUpgrade/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'HandyJSON', '~> 4.0.0-beta.1'
  s.dependency 'FMDB', '~> 2.7.2'
end
