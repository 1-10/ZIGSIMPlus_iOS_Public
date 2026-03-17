platform :ios, '12.1'

target 'ZIGSIMPlus' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ZIGSIMPlus
  pod 'DeviceKit', '~> 2.0'
  pod 'LicensePlist'
  pod 'SwiftSocket'
  pod 'SwiftOSC', '~> 1.2'
  pod 'SwiftyUserDefaults', '~> 4.0'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'DynamicButton', '~> 6.2.0'
  pod 'SVProgressHUD'
  pod 'MarkdownKit'
  pod 'Sourcery'
  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'

  target 'ZIGSIMPlusTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'ZIGSIMPlusUITests' do
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Xcode 14+ removed libarclite; bump any pod below 12.0 to 12.0
      deployment_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f
      if deployment_target < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
    if target.name == 'SwiftSocket'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
end
