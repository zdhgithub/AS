# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'AS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  inhibit_all_warnings!

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

  # Pods for AS
  pod 'SwiftJWT'
  pod 'MMKV'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'SwiftyJSON'
  pod 'HandyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Toast-Swift'
  pod 'MJRefresh'
  pod 'Masonry'
  pod 'OpenSSL-Universal'
#  pod 'CertificateSigningRequest'
#  pod 'SwiftyRSA'
#  pod 'ASN1Decoder'
  
  pod 'LookinServer', :configurations => ['Debug']

end
