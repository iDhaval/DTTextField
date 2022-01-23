#
# Be sure to run `pod lib lint DTTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

s.name             = 'DTTextField'
s.version          = '0.7.0'
s.summary          = 'DTTextField is UITextField library.'

  s.description      = <<-DESC
DTTextField is UITextField library with floating and error label.
                       DESC

s.homepage         = 'https://github.com/iDhaval/DTTextField'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Dhaval Thanki' => 'dhavaldthanki@gmail.com' }
s.source           = { :git => 'https://github.com/iDhaval/DTTextField.git', :tag => s.version }

s.ios.deployment_target = '9.0'
s.swift_version = '5.0'
s.source_files = 'Sources/DTTextField/**/*'
s.frameworks = 'UIKit'

end
