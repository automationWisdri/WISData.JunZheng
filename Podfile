platform :ios, '8.0'
use_frameworks!

def pods
    pod 'Alamofire', '~> 3.4.0'
    pod 'SwiftyJSON'
    pod 'DrawerController', '~> 1.0'
    pod 'SVProgressHUD'
    pod 'SnapKit', '~> 0.18.0'
    pod 'KeyboardMan', '~> 0.6.0'
    pod 'Ruler', '~> 0.7.0'
    pod 'FXBlurView'
    pod 'LMDropdownView'
    pod 'PagingMenuController'
    pod 'MJExtension'
    pod 'RxSwift', '~> 2.6.0'
    pod 'RxCocoa', '~> 2.6.0'
    pod 'RxDataSources'
    pod 'DeviceKit', '~> 0.3.0'
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

