platform :ios, '15.0'

target 'tinder' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DCDAPP

end

target 'tinderDylib' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
#  pod 'DoraemonKit/Core', '~> 3.0.4' #必选
#  pod 'DoraemonKit/WithLogger', '~> 3.0.4', :configurations => ['Debug'] #可选
#  pod 'DoraemonKit/WithGPS', '~> 3.0.4', :configurations => ['Debug'] //可选
#  pod 'DoraemonKit/WithLoad', '~> 3.0.4', :configurations => ['Debug'] #可选
#  pod 'DoraemonKit/WithWeex', '~> 3.0.4', :configurations => ['Debug'] //可选
#  pod 'DoraemonKit/WithDatabase', '~> 3.0.4', :configurations => ['Debug'] #可选
#  pod 'DoraemonKit/WithMLeaksFinder', '3.0.4', :configurations => ['Debug'] #可选
#  pod 'FLEX'
  pod 'AFNetworking'
#  pod 'LookinServer', :configurations => ['Debug']
  pod 'NetworkInterceptor'
  pod 'Masonry'

  pod 'Protobuf', '3.17.0'

  # Pods for DCDAPPDylib

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
