Pod::Spec.new do |s|

  s.name         = "SamuraiTransition"
  s.version      = "0.3"
  s.summary      = "SamuraiTransiton is a ViewController transition framework in Swift."
  s.homepage     = "https://github.com/hachinobu/SamuraiTransition"


  s.license      = "MIT"
  s.author             = { "Takahiro Nishinobu" => "hachinobu@gmail.com" }
  s.source       = { :git => "https://github.com/hachinobu/SamuraiTransition.git", :tag => s.version }

  s.ios.deployment_target = "8.0"

  s.source_files = "SamuraiTransition/**/*.swift"

end
