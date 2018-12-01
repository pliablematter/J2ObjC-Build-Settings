Pod::Spec.new do |s|
  s.name         = "J2ObjC"
  s.version      = "2.3"
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
  s.prepare_command = <<-CMD
    # Copyright (C) 2013 Goodow.com
    # Updated by Doug Burns, Pliable Matter LLC 2018
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    # http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.

    echo "fetching j2objc #{s.version}"
    curl -OL https://github.com/google/j2objc/releases/download/#{s.version}/j2objc-#{s.version}.zip
    #echo "${sha1_checksum}  j2objc-${j2objc_version}.zip" | shasum -c
    unzip -o -q j2objc-#{s.version}.zip
    mv j2objc-#{s.version} dist
  CMD
  
  s.subspec 'lib' do |lib|
    lib.frameworks = 'Security'
    lib.osx.frameworks = 'ExceptionHandling'
    lib.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/J2ObjC/dist/lib"', \
      'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/J2ObjC/dist/include"' }

    lib.subspec 'jre' do |jre|
      jre.preserve_paths = 'dist'
      jre.libraries = 'jre_emul', 'icucore', 'z'
      # jre.xcconfig = { 'OTHER_LDFLAGS' => '-force_load ${PODS_ROOT}/J2ObjC/dist/lib/libjre_emul.a' }
    end

    lib.subspec 'jsr305' do |jsr305|
      jsr305.dependency 'J2ObjC/lib/jre'
      jsr305.libraries = 'jsr305'
    end

    lib.subspec 'junit' do |junit|
      junit.dependency 'J2ObjC/lib/jre'
      junit.libraries = 'j2objc_main', 'junit', 'mockito'
    end
    
    lib.subspec 'guava' do |guava|
      guava.dependency 'J2ObjC/lib/jre'
      guava.libraries = 'guava'
    end
  end
end
