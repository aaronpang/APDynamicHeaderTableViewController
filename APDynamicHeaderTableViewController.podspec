Pod::Spec.new do |s|
  s.name         = "APDynamicHeaderTableViewController"
  s.version      = "0.1.0"
  s.summary      = "A simple table view controller with a header view made as a recreation of the Instagram header."
  s.homepage     = "https://github.com/aaronpang/APDynamicHeaderTableViewController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Aaron Pang" => "pang.aaron56@gmail.com" }
  s.source       = { 
    :git => "https://github.com/aaronpang/APDynamicHeaderTableViewController.git", 
    :tag => "0.1.0"
  }

  s.platform     = :ios, '8.3'
  s.source_files = 'APDynamicHeaderTableViewController/*.swift'
  s.requires_arc = true
end