Pod::Spec.new do |s|
  s.name             = 'Kawagarbo_iOS'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight hybrid framework.'
  s.homepage         = 'https://github.com/Moirig/Kawagarbo_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Moirig' => 'https://github.com/Moirig' }
  s.source           = { :git => 'https://github.com/Moirig/Kawagarbo_iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Kawagarbo_iOS/**/*.{swift,h,m}'
  s.resource_bundles = {
    'Kawagarbo_iOS' => ['Kawagarbo_iOS/Resource/*']
  }
  
  s.dependency  'Cache'
  s.dependency  'CryptoSwift'
  s.dependency  'MBProgressHUD'
  s.dependency  'SolarNetwork'

end
