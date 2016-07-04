platform :ios, '7.0'

inhibit_all_warnings!

pod 'Parse'
pod 'SVProgressHUD'
pod 'TPKeyboardAvoiding', '~> 1.2'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Beeplay/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
