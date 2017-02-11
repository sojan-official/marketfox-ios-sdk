Pod::Spec.new do |s|
  s.name             = 'MarketFox'
  s.version          = '0.1.4'
  s.summary          = 'Marketing Automation Simplified'
  s.description      = 'Marketfox helps you to convert more visitors into customers by keeping track of their events and automating your marketing campaigns'
  s.homepage         = 'https://www.marketfox.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sojan' => 'sojan@marketfox.io'}
  s.source           = { :git => 'https://github.com/sojan-official/marketfox-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'MarketFoxSDK/*.{h,m}'
  s.ios.vendored_library = 'MarketFoxSDK/libMarketFox.a'
  s.frameworks        =  ['CoreLocation','UserNotifications','UIKit','CoreTelephony']
end
