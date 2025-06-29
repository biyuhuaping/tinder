platform :ios, '15.0'

target 'tinder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
end

target 'tinderDylib' do
  use_frameworks!
  pod 'LookinServer', :configurations => ['Debug']
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
          config.build_settings["CODE_SIGN_STYLE"] = "Manual"
          config.build_settings["DEVELOPMENT_TEAM"] = "L3W494J2A6"
            
        end
    end
end
