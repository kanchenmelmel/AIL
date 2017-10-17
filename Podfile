# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'AIL' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!


  # Pods for AIL
  pod 'SlideMenuControllerSwift'
  pod 'SwiftyJSON'
  pod 'Alamofire'
  pod 'AlamofireNetworkActivityIndicator'
  pod 'EAIntroView'
  pod 'NVActivityIndicatorView'
  #pod 'OAuthSwift', '~> 1.1.0'
  pod 'M13PDFKit'
  #pod 'EZAudio', '~> 1.1.4'
  #pod 'AudioKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.2'
      end
  end
end
