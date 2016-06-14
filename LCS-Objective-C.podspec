Pod::Spec.new do |s|
    s.name         = "LCS-Objective-C"
    s.version      = "2.0"
    s.summary      = "LCS (Longest Common Subsequences) for Objective-C"
    s.homepage     = "https://github.com/hfossli/LCS-Objective-C"
    s.license      = 'MIT'
    s.platform      = :ios, '5.0'
    s.requires_arc  = true
    s.authors      = {
    	"Håvard Fossli" => "hfossli@agens.no",
      "Soroush Khanlou" => "soroush@khanlou.com"
    	}
    s.source       = {
        :git => "https://github.com/hfossli/LCS-Objective-C.git",
        :tag => s.version.to_s
        }

    s.ios.deployment_target = '6.0'
    s.osx.deployment_target = '10.8'

    s.frameworks    = 'Foundation'
    s.source_files  = 'Source/**/*.{h,m}'
end
