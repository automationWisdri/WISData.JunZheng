platform :ios, '8.0'
use_frameworks!

def pods
    pod 'Alamofire', '~> 3.5'           #swift3v3.0
    pod 'SwiftyJSON', '~> 2.3.1'        #swift3v3.0
    pod 'DrawerController', '~> 2.0'    #swift3v3.0
    pod 'SVProgressHUD'
    pod 'SnapKit', '~> 0.22.0'          #swift3v3.0
    pod 'KeyboardMan', '~> 0.7.0'       #swift3v1.0
    pod 'Ruler', '~> 0.8'               #swift3v1.0
    pod 'FXBlurView'
    pod 'LMDropdownView'
    pod 'PagingMenuController', '~> 1.2.0'#swift3v2.0
    pod 'MJExtension'
    pod 'RxSwift', '~> 2.6'             #swift3v3.0
    pod 'RxCocoa', '~> 2.6'             #swift3v3.0
    pod 'RxDataSources', '~> 0.9'       #swift3v1.0
    pod 'DeviceKit', :git => 'https://github.com/dennisweissmann/DeviceKit.git', :branch => 'swift-2.3-unsupported'
                                        #swift3v1.0
    pod 'MJRefresh', '~> 3.1.0'
end

target 'WISData.JunZheng' do
    pods
end

target 'WISData.JunZhengTests' do
    pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end

