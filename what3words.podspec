Pod::Spec.new do |s|
  s.name        = "what3words"
  s.version     = "1.0.0"
  s.summary     = "w3w-objectivec-wrapper allows you to convert a 3 word address to coordinates or to convert coordinates to a 3 word address"
  s.homepage    = "https://github.com/what3words/w3w-objectivec-wrapper"
  s.license     = { :type => "MIT" }
  s.authors     = { "what3words" => "office@what3words.com" }

  s.requires_arc = true
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/what3words/w3w-objectivec-wrapper.git", :tag => s.version }
  s.source_files = "Sources/*.{h,m}"
end
