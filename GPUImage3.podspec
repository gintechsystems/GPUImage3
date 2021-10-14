Pod::Spec.new do |s|
    s.name     = 'GPUImage3'
    s.version  = '3.0.0'
    s.license  = 'BSD'
    s.summary  = 'An open source iOS framework for GPU-based image and video processing.'
    s.homepage = 'https://github.com/GottaYotta/GPUImage3'
    s.author   = { 'Brad Larson' => 'contact@sunsetlakesoftware.com' }
    s.source   = { :git => 'https://github.com/gintechsystems/GPUImage3.git', :tag => s.version }

    s.source_files = 'framework/Source/**/*.{swift,h,metal}'
    s.public_header_files = 'framework/Source/Empty.h'

    s.ios.deployment_target = '11.0'
    s.frameworks   = ['Metal', 'QuartzCore', 'AVFoundation']
    s.swift_version = '5.0'
end
