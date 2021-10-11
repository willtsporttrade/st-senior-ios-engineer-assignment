using_bundler = defined? Bundler
is_ci = defined? ENV['CI']

unless using_bundler || is_ci
    puts "\nPlease re-run using:".red
    puts "  bundle exec pod install\n\n"
    exit(1)
end

inhibit_all_warnings!
use_frameworks!

abstract_target 'sporttrade-senior-ios-engineer-assignment' do
    platform :ios, '13.0'

    pod 'Moya/Combine', :git => 'https://github.com/Moya/Moya.git', :tag => '15.0.0-alpha.1'
    pod 'NeedleFoundation', '~> 0.17'
    pod 'SwiftyJSON', '~> 5.0'
    pod 'Charts'
    
    target 'Assignment' do
    end

    abstract_target 'sporttrade-senior-ios-engineer-assignment-tests' do
        pod 'Nimble', '~> 9.0'
        pod 'Quick', '~> 4.0'

        target 'AssignmentTests' do
        end

        target 'AssignmentUITests' do
        end
    end
end

project 'Assignment'
workspace 'Assignment'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # This disables bitcode for all pods
            config.build_settings['ENABLE_BITCODE'] = 'NO'

            # This fixes the iOS 8.0 deployment target warning
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
    end
end
