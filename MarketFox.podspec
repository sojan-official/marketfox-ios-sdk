#
# Be sure to run `pod lib lint MarketFox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MarketFox'
  s.version          = '0.1.0'
  s.summary          = 'Marketing Automation Simplified'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Marketfox helps you to convert more visitors into customers by keeping track of their events and automating your marketing campaigns'



  s.homepage         = 'https://www.marketfox.io'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sojan' => 'sojan@marketfox.io' }
  s.source           = { :git => 'https://github.com/sojan-official/marketfox-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MarketFoxSDK/*.{h,m}'

  s.ios.vendored_library = "MarketFoxSDK/libMarketFox.a"
  
  # s.resource_bundles = {
  #   'MarketFox' => ['MarketFox/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end