#
# Be sure to run `pod lib lint IPQueueDispatcher.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'IPQueueDispatcher'
    s.version          = '0.1.3'
    s.summary          = 'Queue Dispatcher'
    s.description      = "A Queue dispatcher"
    s.homepage         = 'https://github.com/ipavlidakis/IPQueueDispatcher'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Ilias Pavlidakis' => 'ipavlidakis@gmail.com' }
    s.source           = { :git => 'https://github.com/ipavlidakis/IPQueueDispatcher.git', :tag => "#{s.version}" }
    s.social_media_url = 'https://twitter.com/3liaspav'
    s.ios.deployment_target = '8.0'
    #    s.public_header_files = 'IPQueueDispatcher/Classes/**/*.h'
    #    s.public_header_files = 'IPQueueDispatcher/Classes/IPQueueDispatcherHeader.h'
    s.source_files = 'IPQueueDispatcher/Classes/**/*.{h,m,xcdatamodeld}'
    s.resources = 'IPQueueDispatcher/Classes/Models/Schema/*.xcdatamodeld'
    s.resources = [ 'IPQueueDispatcher/Classes/Models/Schema/IPQueueDispatcherModel.xcdatamodeld','IPQueueDispatcher/Classes/Models/Schema/IPQueueDispatcherModel.xcdatamodeld/*.xcdatamodel']
    s.preserve_paths = 'IPQueueDispatcher/Classes/Models/Schema/IPQueueDispatcherModel.xcdatamodeld'
    s.framework  = 'CoreData'
    s.requires_arc = true
    s.dependency "MagicalRecord"
    s.dependency "AFNetworking"
end