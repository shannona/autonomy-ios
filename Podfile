# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def sharedPods
  pod 'BitmarkSDK/RxSwift'
  pod 'Intercom'
  pod 'OneSignal'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Sentry'

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxOptional'
  pod 'Moya/RxSwift'
  pod 'RxTheme'
  pod 'RxSwiftExt'

  pod 'IQKeyboardManagerSwift'
  pod 'Hero'
  pod 'PanModal'
  pod 'Kingfisher'
  pod 'SVProgressHUD'
  pod 'SwiftEntryKit'
  pod 'R.swift'
  pod 'SnapKit'
  pod 'BEMCheckBox'
  pod 'KMPlaceholderTextView'
  pod 'SkeletonView'
  pod 'SwiftSVG'
  pod 'YoutubePlayerView'

  pod 'SwifterSwift'

  pod 'XCGLogger', '~> 7.0.0'

  pod 'SwiftRichString'
  pod 'SwiftDate'
  pod 'MGSwipeTableCell'
  pod 'MaterialProgressBar'
  pod 'UPCarouselFlowLayout'
  pod 'Cosmos'
  pod 'BetterSegmentedControl', '~> 1.3'
end


target 'Autonomy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Autonomy
  sharedPods
end

target 'Autonomy Dev' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Autonomy Dev
  sharedPods
  pod 'SwiftLint'
end

target 'Autonomy Inhouse' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Autonomy Dev
  sharedPods
end

target 'OneSignalNotificationServiceExtension' do
  use_frameworks!

  pod 'OneSignal'
end

target 'OneSignalNotificationServiceDevExtension' do
  use_frameworks!

  pod 'OneSignal'
end

target 'OneSignalNotificationServiceInhouseExtension' do
  use_frameworks!

  pod 'OneSignal'
end

