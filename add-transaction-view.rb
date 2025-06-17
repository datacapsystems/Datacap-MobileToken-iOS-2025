#!/usr/bin/env ruby

require 'xcodeproj'

# Open the project
project_path = 'DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main group
main_group = project.main_group['DatacapMobileTokenDemo']

# Create a new file reference for TransactionViewController.swift
file_ref = main_group.new_file('../DatacapMobileDemo/TransactionViewController.swift')
file_ref.name = 'TransactionViewController.swift'

# Get the main target
target = project.targets.first

# Add the file to the build phase
target.source_build_phase.add_file_reference(file_ref)

# Save the project
project.save

puts "✅ Successfully added TransactionViewController.swift to the project!"