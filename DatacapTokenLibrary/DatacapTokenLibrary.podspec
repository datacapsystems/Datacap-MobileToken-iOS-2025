Pod::Spec.new do |spec|
  spec.name         = "DatacapTokenLibrary"
  spec.version      = "1.0.0"
  spec.summary      = "Secure payment tokenization for iOS"
  spec.description  = <<-DESC
    DatacapTokenLibrary provides secure payment card tokenization for iOS applications.
    It includes a pre-built card input UI and handles all validation and API communication
    with Datacap's tokenization service.
  DESC

  spec.homepage     = "https://github.com/datacapsystems/DatacapTokenLibrary-iOS"
  spec.license      = { :type => "Commercial", :file => "LICENSE" }
  spec.author       = { "Datacap Systems" => "support@datacapsystems.com" }
  
  spec.platform     = :ios, "15.6"
  spec.source       = { :git => "https://github.com/datacapsystems/DatacapTokenLibrary-iOS.git", :tag => "#{spec.version}" }
  
  spec.source_files = "Sources/**/*.{swift}"
  spec.swift_version = "5.0"
  
  spec.frameworks = "UIKit", "Foundation"
  spec.requires_arc = true
end