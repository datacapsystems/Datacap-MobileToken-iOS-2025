#!/usr/bin/env ruby

require 'xcodeproj'

project_path = 'DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get main group
main_group = project.main_group

# Add Swift files
swift_files = [
  'DatacapMobileDemo/ModernViewController.swift',
  'DatacapMobileDemo/GlassMorphismExtensions.swift'
]

target = project.targets.first

swift_files.each do |file_path|
  full_path = File.join('DatacapMobileTokenDemo', file_path)
  if File.exist?(full_path)
    file_ref = main_group.new_file(file_path)
    target.add_file_references([file_ref])
    puts "Added #{file_path}"
  else
    puts "File not found: #{full_path}"
  end
end

# Add bridging header file reference
bridging_header_path = 'DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h'
bridging_header_ref = main_group.new_file(bridging_header_path)
puts "Added bridging header reference"

# Set bridging header in build settings
target.build_configurations.each do |config|
  config.build_settings['SWIFT_OBJC_BRIDGING_HEADER'] = 'DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
  puts "Updated build settings for #{config.name}"
end

project.save
puts "Successfully updated Xcode project!"