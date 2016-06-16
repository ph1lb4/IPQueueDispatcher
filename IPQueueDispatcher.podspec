#
# Be sure to run `pod lib lint IPQueueDispatcher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'IPQueueDispatcher'
s.version          = '0.1.0'
s.summary          = 'Queue Dispatcher'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = "A Queue dispatcher"
s.homepage         = 'https://github.com/ipavlidakis/IPQueueDispatcher'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Ilias Pavlidakis' => 'ipavlidakis@gmail.com' }
s.source           = { :git => 'https://github.com/ipavlidakis/IPQueueDispatcher.git', :tag => "#{s.version}" }
s.social_media_url = 'https://twitter.com/3liaspav'

s.ios.deployment_target = '8.0'

s.source_files = 'IPQueueDispatcher/Classes/**/*.{h,m}'

# s.resource_bundles = {
#   'IPQueueDispatcher' => ['IPQueueDispatcher/Assets/*.png']
# }

s.requires_arc = true
# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency "MagicalRecord"
s.dependency "AFNetworking"
end