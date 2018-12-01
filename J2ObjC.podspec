Pod::Spec.new do |s|
  s.name         = "J2ObjC"
  s.version      = "1.0"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.summary      = "Podspec for using Google's J2ObjC Objective-C Translator and Runtime in a Cocoapods project."
  s.homepage     = "https://github.com/pliablematter/J2ObjC-pod"
  s.author       = "Pliable Matter LLC"
  s.source       = { :git => "https://github.com/pliablematter/J2ObjC-pod.git", :tag => "v#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '12.1'
  s.requires_arc = false
  s.default_subspec = 'lib/jre'

  # Top level attributes can't be specified by subspecs.
  s.header_mappings_dir = 'dist/include'
  
  s.subspec 'lib' do |lib|
    lib.frameworks = 'Security'
    lib.osx.frameworks = 'ExceptionHandling'
    lib.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"/usr/local/bin/j2objc/lib"', \
      'HEADER_SEARCH_PATHS' => '"/usr/local/bin/j2objc/include"' }

    lib.subspec 'jre' do |jre|
      jre.preserve_paths = 'dist'
      jre.libraries = 'jre_emul', 'icucore', 'z'
    end

    lib.subspec 'jsr305' do |jsr305|
      jsr305.dependency '/usr/local/bin/j2objc/lib/jre'
      jsr305.libraries = 'jsr305'
    end

    lib.subspec 'junit' do |junit|
      junit.dependency '/usr/local/bin/j2objc/lib/jre'
      junit.libraries = 'j2objc_main', 'junit', 'mockito'
    end
    
    lib.subspec 'guava' do |guava|
      guava.dependency '/usr/local/bin/j2objc/lib/jre'
      guava.libraries = 'guava'
    end
  end
end
